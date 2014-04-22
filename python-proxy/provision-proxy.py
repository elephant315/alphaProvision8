#!/usr/bin/python

HOST           = '127.0.0.1'
MANAGER        = '127.0.0.1'
MANAGERPORT    = 5038
USERNAME       = 'eventmonitor'
SECRET         = '*pwd*'

SQLhost        = 'localhost'
SQLuser        = '*user*'
SQLpass        = '*pwd*'
SQLdb          = 'isoft_config'
SQLport        = 3306

import sys
import socket
import os
import MySQLdb
import time
import datetime
import string

import traceback
import syslog
import atexit
import grp
import pwd
import daemon
import lockfile

# For debug purposes this may be turned on to watch timeout conditions
# with TCP/IP socket connections
#
# SOCKET_TIMEOUT = 20.0
# socket.setdefaulttimeout(SOCKET_TIMEOUT)
#

def _syslog(level, message, *args):
  syslog.syslog(level, "provision-proxy: " + message % args)

def logInfo(message, *args):
  _syslog(syslog.LOG_INFO,  message % args)

def logDebug(message, *args):
  _syslog(syslog.LOG_DEBUG, message % args)

def logError(exception, message, *args):
  _syslog(syslog.LOG_ERR,   message % args)
  etype, evalue, etraceback = sys.exc_info()
  logException(syslog.LOG_ERR, etype, evalue, etraceback)

def logException(level, etype, evalue, etb):
  for line in traceback.format_exception(etype, evalue, etb):
    for line in line.rstrip().split('\n'):
      syslog.syslog(level, line)

def server():
  global SQLhost,SQLuser,SQLpass,SQLdb,SQLport
  msconn = None
  db = None
  logDebug("Connecting to Asterisk Manager")
  try:
    msconn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    msconn.connect((MANAGER,MANAGERPORT))
  except socket.error, err:
    logError(err, "Manager Connection Error %d: %s", err.args[0], err.args[1])
    return 1
  logDebug("Sending Action: Login")
  msconn.send("Action: Login\r\n")
  msconn.send("UserName: " + USERNAME + "\r\n")
  msconn.send("Secret: " + SECRET + "\r\n\r\n");
  logDebug("Sending Action: Events Eventmask: On")
  msconn.send("Action: Events\r\nEventmask: On\r\n\r\n")
  logDebug("Starting to accept events")
  dbdata = ""
  while (1):
    try: data = msconn.recv(1024)
    except socket.error, err:
      logError(err, "Manager Received error %d: %s", err.args[0], err.args[1])
      return 1
    if not data:
      logDebug("Nothing to read from asterisk connection, authentication error?")
      break
    ct = datetime.datetime.now()
    dbdata += data
    if (dbdata[-4:] != "\r\n\r\n"): continue
    events = dbdata.split("\r\n\r\n")
    for i in range(len(events)):
      events[i] = events[i].replace("\r", " ")
      events[i] = events[i].replace("\n", " ")
      if events[i] == "":
        continue
      if not events[i].startswith("Event:"):
        continue

      event = events[i]
#
# Sample Filter Code
#
# Make sure the if statements below, line up with other if statements when
# they are uncommented. Also if any other filters are added make sure the
# columns being compared match.
#
# 0....5...10...15...20...25...30...35...40...45...50...55...60...65...70...75...80
# Event: PeerStatus   
# Event: JabberEvent
#  
#      if (events[i][7:17] == "PeerStatus"):  continue
#      if (events[i][7:18] == "JabberEvent"): continue
#
      if db:
        try:
          db.ping()
        except MySQLdb.Error, err:
          logDebug("MySQLdb Error %d: %s, trying now to reconnect.", err.args[0], err.args[1])
          db = None
      if db is None:
        try:
          db = MySQLdb.connect(host=SQLhost,user=SQLuser,passwd=SQLpass,db=SQLdb,port=SQLport)
        except MySQLdb.Error, err:
          logError(err, "Error %d: %s", err.args[0], err.args[1])
          return 1
        cursor = db.cursor()
        db.autocommit(1)
      try:
        properties = {}
        for entry in event.split("  "):
          key, value = entry.split(":", 1)
          properties[key.strip()] = value.strip()

          logDebug("Event: %s", properties)

        if (properties["Event"] == "PeerStatus"):
          status = 2
          peer = int(properties["Peer"][4:])
          if (properties["PeerStatus"] == "Unregistered"):
            status = 2
            logDebug("Peer went offline: %s", peer)
          elif (properties["PeerStatus"] == "Registered"):
            status = 3
            logDebug("Peer came online: %s", peer)
          cursor.execute("UPDATE devices SET statusflag = %s WHERE provisionextension = %s and statusflag < 4 limit 1", (status, peer))
          logDebug("Updated %s rows", cursor.rowcount)
      except db.DatabaseError as e:
        logError(e, "Database error")
      except Exception as e:
        logError(e, "Error in main loop")
    dbdata = ""
  logDebug("Main loop exited")
  msconn.close()
  return 0

def main ():
  logDebug("Entering main loop")
  while 1:
    server()
    logDebug("main loop turned around, sleeping for 10 sec")
    time.sleep(10)
  logInfo("exiting")
  sys.exit(result)

if __name__ == "__main__":
  logInfo("starting with pid %d", os.getpid())

  context = daemon.DaemonContext(
    working_directory = '/opt',
    umask = 0o002,
    gid = grp.getgrnam('asterisk').gr_gid,
    uid = pwd.getpwnam('asterisk').pw_uid,
    # this is lame: doesn't clean up, doesn't write the pid in the file, etc...
    #pidfile = lockfile.FileLock('/var/run/provision-proxy.pid'),
    )

  try:
    logDebug("setting up pid file")
    pidfilename = '/var/run/asterisk/provision-proxy.pid'
    with context:
      if os.access(pidfilename, os.F_OK):
        pidfile = open(pidfilename, "r")
        pidfile.seek(0)
        oldPid = pidfile.readline()
        try:
          oldPid = int(oldPid)
        except ValueError:
          oldPid = None
        if oldPid and os.kill(int(oldPid), 0):
          logDebug("Deamon already running, exiting.")
          sys.exit(1)
        else:
          logInfo("Cleaning up leftover daemon file from previous abnormal exit")
          os.remove(pidfilename)

      pidfile = open(pidfilename, "w")
      pidfile.write("%s" % os.getpid())
      pidfile.close
      atexit.register(lambda: os.remove(pidfilename))
      main()
  except Exception as e:
    logError(e, "Error while starting")
