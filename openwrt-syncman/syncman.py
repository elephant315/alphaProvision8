#!/usr/bin/python
#############################
# CONFIG PARAMS
#############################
server			= "serverip:8080"
branchName		= "OPENWRTorg1branchXXX"
AESKey			= "PUTKEYHERE"
asteriskConfigDir	= "/etc/asterisk"
commandPath		= "/etc/syncman/syncman.py"
############################
import os.path,subprocess,sys,re,time
import gzip
import traceback
import syslog
import md5
import cStringIO
import binascii
import urllib
import urllib2
import itertools
import mimetools
import mimetypes
import random
from Crypto.Cipher import AES
from base64 import b64decode,b64encode
from crontab import CronTab
from datetime import datetime
#############################
print "Alpha 8 - syncman"
#############################
asteriskNeedsRestart = False

def _syslog(level, message, *args):
  formattedMessage = message % args
  syslog.syslog(level, "syncman: " + formattedMessage)
  print(formattedMessage)

def logInfo(message, *args):
  _syslog(syslog.LOG_INFO,  message % args)

def logDebug(message, *args):
  _syslog(syslog.LOG_DEBUG, message % args)

def logError(exception, message, *args):
  _syslog(syslog.LOG_ERR,   message % args)
  etype, evalue, etraceback = sys.exc_info()
  if exception:
          logException(syslog.LOG_ERR, etype, evalue, etraceback)

def logException(level, etype, evalue, etb):
  for line in traceback.format_exception(etype, evalue, etb):
    for line in line.rstrip().split('\n'):
      syslog.syslog(level, line)

#########################
def sysstat():
        try:
#		load = str(os.getloadavg()) #GET 15 MINUTE LOAD AVERAGE
                l1 = subprocess.Popen(["uptime"], stdout=subprocess.PIPE)
                l2 = subprocess.Popen(["awk", "{split($0,a,\",\");print a[1]}"], stdin=l1.stdout, stdout=subprocess.PIPE)
                uptime= str(l1.communicate()[0])
                #ram size buben
                r1 = subprocess.Popen(["free"], stdout=subprocess.PIPE)
                r2 = subprocess.Popen(["awk", "{print $4}"], stdin=r1.stdout, stdout=subprocess.PIPE)
                r3 = subprocess.Popen(["head", "-2"], stdin=r2.stdout, stdout=subprocess.PIPE)
                r4 = subprocess.Popen(["tail", "-1"], stdin=r3.stdout, stdout=subprocess.PIPE)
                ram = str(r4.communicate()[0])
                #hdd size
                h1 = subprocess.Popen(["df","-h","/overlay"], stdout=subprocess.PIPE)
                h2 = subprocess.Popen(["awk", "{print $4}"], stdin=h1.stdout, stdout=subprocess.PIPE)
                h3 = subprocess.Popen(["head", "-2"], stdin=h2.stdout, stdout=subprocess.PIPE)
                h4 = subprocess.Popen(["tail", "-1"], stdin=h3.stdout, stdout=subprocess.PIPE)
                hdd = str(h4.communicate()[0])
                sstat = "FRAM:"+ram.strip()+"kb;FROOT:"+hdd.strip()+";UPTIME:"+uptime.strip()+";"
                logInfo("System status: " + sstat)
                print sstat
                return sstat
        except:
                logError("Error getting sys stat.")
                return "NOSTAT"
############################
def writeconfig(fileName, newConfig):
        filepath = "%s/%s.conf" % (asteriskConfigDir, fileName)
        if os.path.exists(filepath):
                oldconfig = open(filepath, "r").read()
        else:
                oldconfig = "EMPTY"

        if md5.new(newConfig).hexdigest() == md5.new(oldconfig).hexdigest():
                logInfo("Config file " + filepath + " has not changed.")
        else:
                logInfo("Updating config file '" + filepath + "'...")
                open(filepath, "w").write(newConfig)
                global asteriskNeedsRestart
                asteriskNeedsRestart = True
                logInfo("Update done.")
##########################
def updateConfigFile(sourceUrl, targetFileName):
  data = downloadConfigUrl(sourceUrl)
  writeconfig(targetFileName, data)

##########################
def downloadConfigUrl(url):
  logDebug("Getting url: " + url)
  response = urllib2.urlopen(url)
  html = response.read()

  decryptor = AES.new(AESKey, AES.MODE_ECB)
  decstring = decryptor.decrypt(b64decode(html))
  newConfig = decstring.strip()

  # remove padding. TODO: it's not too safe this way, make it more explicit by adding the file size at the beginning before encryption.
  fixit = newConfig.find(";end")
  if fixit != -1:
    newConfig = newConfig[:fixit + 4]

  if not (newConfig.startswith( ";start" ) and newConfig.endswith( ";end" )):
    raise Exception("received corrupt config data")

  return newConfig

##########################
def install():
  sipconf = open(asteriskConfigDir + "/sip.conf", "r").read()
  if sipconf.find("#include sip_autop.conf") == -1:
    open(asteriskConfigDir + '/sip.conf', "a").write("\n#include sip_autop.conf\n")
    logDebug("editing of sip.conf is done")
    return_code = subprocess.call("asterisk -rx 'core reload'", shell=True)
  else:
    logDebug("sip.conf if fine")

  sipconf = open(asteriskConfigDir + "/sip.conf", "r").read()
  if sipconf.find("#include sip_autopcu.conf") == -1:
    open(asteriskConfigDir + '/sip.conf', "a").write("\n#include sip_autopcu.conf\n")
    logDebug("editing of sip.conf is done (autopcu)")
    return_code = subprocess.call("asterisk -rx 'core reload'", shell=True)
  else:
    logDebug("sip.conf if fine (autopcu)")

  sipconf = open(asteriskConfigDir + "/extensions.conf", "r").read()
  if sipconf.find("#include extensions_autopin.conf") == -1:
    open(asteriskConfigDir + '/extensions.conf', "a").write("\n#include extensions_autopin.conf\n")
    logDebug("editing of extensions.conf is done (autopin)")
    return_code = subprocess.call("asterisk -rx 'core reload'", shell=True)
  else:
    logDebug("extensions.conf if fine (autopin)")

  sipconf = open(asteriskConfigDir + "/extensions.conf", "r").read()
  if sipconf.find("#include extensions_autopout.conf") == -1:
    open(asteriskConfigDir + '/extensions.conf', "a").write("\n#include extensions_autopout.conf\n")
    logDebug("editing of extensions.conf is done (autopout)")
    return_code = subprocess.call("asterisk -rx 'core reload'", shell=True)
  else:
    logDebug("extensions.conf if fine (autopout)")

  tab = CronTab()
  crons = unicode(tab.render())
  if crons.find("syncman.py") == -1:
    logDebug("adding myself to crontab")
    cron = tab.new(command=commandPath)
    cron.minute().every(5)
    tab.write()
  else:
    logDebug("crontab is fine")

#########################
def sendCDRs():
        logDir = "/var/log/asterisk/cdr-csv/"

        def compressFile(filePath):
                logDebug("Compressing file '" + filePath + "'")
                data = open(filePath, "rb").read()
                originalmd5 = md5.new(data).hexdigest().upper()
                zbuf = cStringIO.StringIO()
                zfile = gzip.GzipFile(mode = 'wb',  fileobj = zbuf, compresslevel = 4)
                zfile.write(data)
                zfile.close()
                compressedData = zbuf.getvalue()
                logInfo("Original size is " + str(len(data)) + ", compressed size is " + str(len(compressedData)) + ", md5 is '" + originalmd5 + "'")
                return compressedData, originalmd5

        def sendFile(filePath):
                logDebug("Sending file '" + filePath + "'")
                data, originalmd5 = compressFile(filePath)

                # add PKCS#5 padding
                padsize = 16 - (len(data) % 16)
                data = data + chr(padsize) * padsize
                data = AES.new(AESKey, AES.MODE_ECB).encrypt(data)
                params = {'report': data,
                          'md5': originalmd5}
                try:
                        response = urllib2.urlopen("http://%s/%s.cdr" % (server, branchName), urllib.urlencode(params))
                        body = response.read()
                        logDebug("For file '" + filePath + "' response is: '" + body + "'")
                        if body == "ok":
                                logDebug("Server answered ok, deleting '" + filePath + "'...")
                                os.remove(filePath)
                        else:
                                logError("Server processing error")
                except urllib2.HTTPError, error:
                        logError(None, "For from server for file '" + filePath + "':" + error.read())

        files = os.listdir(logDir)
        now = time.localtime()
        for fileName in sorted(files, key=str.lower):
                match = re.match("(\d+)-(\d+)-(\d+)-Master.csv", fileName)
                if match and not (int(match.group(1)) == now.tm_year and
                                  int(match.group(2)) == now.tm_mon and
                                  int(match.group(3)) == now.tm_mday):
                        sendFile(logDir + fileName)
#########################
def remove():
        tabremove = CronTab()
        cronsremove = unicode(tabremove.render())
        if cronsremove.find("syncman.py") != -1:
                tabremove.remove_all('syncman.py')
                tabremove.write()
                print "removed self from crontab"
        else: print "nothing to remove from crontab"
        print "manually remove me from sip.conf and extensions.conf"
#########################

def updateCrontabInterval():
  crontab = CronTab()
  crontabEntries = crontab.find_command(commandPath)
  if len(crontabEntries) > 1:
    raise Exception("more than one entry in the crontab!?")
  elif len(crontabEntries) == 1:
    updateIntervalString = downloadConfigUrl("http://%s/%s.config?type=updinterval" % (server, branchName))
    updateIntervalString = updateIntervalString[6:-4]
    updateInterval = int(updateIntervalString)
    if updateInterval < 5 or updateInterval > 480:
      raise Exception("received corrupt update interval")

    logInfo("update interval will be set to: " + str(updateInterval) + " mins")
    crontabEntry = crontabEntries[0]
    crontabEntry.clear()
    if updateInterval > 59:
      crontabEntry.hour().every(updateInterval / 60)
      crontabEntry.minute().on(random.randint(0, 59))
    else:
      crontabEntry.minute().every(updateInterval)

    logDebug("Will write new crontab '" + unicode(crontab.render()) + "'")
    crontab.write()
  else:
    logInfo("we are not installed in crontab, update interval will not be updated")

#########################
for i in range(len(sys.argv)):
        if (sys.argv[i] == "remove"):
                print "#################"
                print "removing script..."
                remove()
                continue
        if (sys.argv[i] == "install"):
                print "#################"
                print "installing script..."
                install()
#########################
try:
  updateConfigFile("http://%s/%s.config?type=dialplan1" % (server, branchName), "extensions_autopin")
  updateConfigFile("http://%s/%s.config?type=dialplan2" % (server, branchName), "extensions_autopout")
  updateConfigFile("http://%s/%s.config?type=customsip" % (server, branchName), "sip_autopcu")
  updateConfigFile("http://%s/%s.config?hwstat=%s" % (server, branchName, b64encode(sysstat())), "sip_autop")

  if asteriskNeedsRestart:
    logInfo("Restarting asterisk...")
    subprocess.call("asterisk -rx 'core reload'", shell=True)
    logDebug("Restart done.")

  sendCDRs()

  updateCrontabInterval()

except Exception as e:
  logError(e, "Error reached toplevel")
