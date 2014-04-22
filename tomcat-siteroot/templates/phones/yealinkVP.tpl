<!-- BEGIN: main -->
[ cfg:/rundata/config/user/voip/sipAccount0.cfg, reboot=0 ]
#basic
account.Enable =  {enabled}
account.DisplayName = {label}
account.UserName = {username}
account.AuthName = {username}
account.password = {password}
account.SIPServerHost = {serverhost}
account.SIPServerPort = {serverport}
account.SIPListenPort = {listenport}
account.Expire = {expire}
account.UseOutboundProxy = {useproxy}
account.OutboundHost = {proxyhost}
account.OutboundPort = {proxyport}
;account.BakOutboundHost = 
;account.BakOutboundPort = 5060
;account.EnableUserEqualPhone = 0
;account.Enable 100rel = 1
;account.SubsribeRegister = 1
;account.EnableSessionTimer = 0
;account.SessionExpires = 100
;account.SessionRefresher = 0
;account.CIDSource = 0
;account.VoiceMail = 
;Ring.strRingFile = 

#DTMF
DTMF.DTMFInbandTransfer = {dtmftype}
DTMF.DTMFPayload = {dtmfpayload}

#NAT
NAT.MaxRTPPort = {rtpmax}
NAT.MinRTPPort = {rtpmin}
NAT.NATTraversal = {nattraversal}
NAT.STUNServer = {stunserver}
NAT.STUNPort = {stunport}
;NAT.EnableUDPUpdate = 0
;NAT.UDPUpdateTime = 30
;NAT.rport = 0

#advanced
;ADVANCED.default_t1 = 0.5
;ADVANCED.default_t2 = 4
;ADVANCED.default_t4 = 5
;ADVANCED.VideoBandwidth = 0
;account.Transport = 0
account.srtp_encryption = {rtpencrypt}
;account.BlfListCode =
;blf.BLFList_URI = 
;account.SubscribeMWI = 0 
;account.SubscribeMWIExpire = 3600
;ADVANCED.VideoBandwidth = 0
;vaServer.nFrameRate = 30


#Audio Codecs:audio0/audio1/audio2/audio3/audio4/audio5/audio6/audio7
;audio0.enable = 1
;audio0.priority = 2
;audio0.PayloadType = PCMA
;audio0.rtpmap = 8

;audio1.enable = 1
;audio1.priority = 1
;audio1.PayloadType = PCMU
;audio1.rtpmap = 0

;audio2.enable = 1
;audio2.priority = 3
;audio2.PayloadType = G729
;audio2.rtpmap = 18

;audio3.enable = 0
;audio3.priority = 4
;audio3.PayloadType = G722
;audio3.rtpmap = 9

;audio4.enable = 0
;audio4.priority = 5
;audio4.PayloadType = G723
;audio4.rtpmap = 4

;audio5.enable = 0
;audio5.priority = 6
;audio5.PayloadType = GSM
;audio5.rtpmap = 3

;audio6.enable = 0
;audio6.priority = 7
;audio6.PayloadType = AACLC
;audio6.rtpmap = 102

;audio7.enable = 0
;audio7.priority = 8
;audio7.PayloadType = iLBC
;audio7.rtpmap = 122

#Video Codecs:video0/video1/video2
video0.enable = 1
video0.priority = 1
video0.PayloadType = H264
video0.rtpmap = 99

video1.enable = 1
video1.priority = 2
video1.PayloadType = H263
video1.rtpmap = 34

video2.enable = 1
video2.priority = 3
video2.PayloadType = mp4v-es
video2.rtpmap = 102

;account.AnonymousCall = 0
;account.AnonymousCall_OnCode = 
;account.AnonymousCall_OffCode = 

;account.RejectAnonymousCall = 0
;account.AnonymousReject_OnCode = 
;account.AnonymousCall_OffCode = 

#Auto Answer
AutoAnswer.bEnable = {autoanswer}
AutoAnswer.nTimeout = 0

;[ cfg:/rundata/config/user/user.ini,reboot=0 ]
#Always FWD
;AlwaysForward.bEnable = 0
;AlwaysForward.strTarget = 
;AlwaysForward.nOnCode =
;AlwaysForward.nOffCode =

#Busy FWD
;BusyForward.bEnable = 0
;BusyForward.strTarget = 
;BusyForward.nOnCode =
;BusyForward.nOffCode =

#No Answer FWD
;NoAnswerForward.bEnable = 0
;NoAnswerForward.strTarget = 
;NoAnswerForward.nTimeout = 60
;NoAnswerForward.nOnCode =
;NoAnswerForward.nOffCode =

#language 
;Language.strGUILanguage = English
;Language.strWebLanguage = English

#screensaver
;ScreenSaver.eType = 1
;ScreenSaver.nTimeout = 60

#sleep
;Sleep.nTimeout = 600

#Call Mode
;CallOption.eCallMode = 1
;CallOption.bActiveCamera = 1

#Call Waiting
;CallWaiting.bEnable = 1
;CallWaiting.nRingTime = -1

#Key as send
;KeyAsSend.eType = 1

#Date and Time format
#1--DDMMYYYY£¬2--MMDDYYYY£¬3--YYYYMMDD
;DateTime.eDateFormat = 3
#1--24hours£¬2--12hours
;DateTime.eTimeFormat = 1

#Password
[psw:/rundata/data/htpasswd]
admin= 2030
var= 2030
user=2030

#Local Phone Book
;[bin:/rundata/data/contactData.xml,reboot=0]
;url=

#Remote Phone Book
;[bin:/rundata/data/remotebook.xml,reboot=0]
;url =

;[ cfg:/rundata/config/user/user.ini,reboot=0 ]

;DefaultIme.strAdminPwd = 2aB
;DefaultIme.strSecurity = 2aB

[ cfg:/rundata/config/system.ini,reboot=1 ]
Network.eWANType = {wantype}
Network.strWANIP = {wanstaticip}
Network.strWANMask = {wanmask}
Network.strWanGateway ={wangw}
Network.strWanPrimaryDNS ={primarydns}
Network.strWanSecondaryDNS ={secondarydns}
;Network.strPPPoEUser = 
;Network.strPPPoEPin = 
Network.bBridgeMode = {lantype}
Network.strLanIP = {langatewayip}
Network.strLanMask = {lansubnet}
Network.bLanDHCPServer = {enabledhcp}
Network.strDHCPClientBegin = {dhcpstart}
Network.strDHCPClientEnd = {dhcpend}

;LLDP.EnableLLDP = 0
;LLDP.PacketInterval = 120

LocalTime.TimeZone = +6
LocalTime.TimeZoneName = Almaty
LocalTime.TimeServer1 = {ntpserver1}
LocalTime.TimeServer2 = ru.pool.ntp.org
LocalTime.Interval = 1000
;LocalTime.TimeZoneInstead = 8
;LocalTime.StartTime = 1/1/0
;LocalTime.EndTime = 12/31/23
;LocalTime.TimeFormat = 1
;LocalTime.DateFormat = 0
;LocalTime.OffSetTime = 60
;LocalTime.bDSTEnable = 1
;LocalTime.bNTPEnable = 1


AutoProvision.bEnablePowerOn = 1
;AutoProvision.bEnableWeekly = 0
;AutoProvision.strWeeklyMask = 0123456
;AutoProvision.strWeeklyBeginTime = 00:00
;AutoProvision.strWeeklyEndTime = 00:00
AutoProvision.bEnableRepeat = 1
AutoProvision.nRepeatMinutes = {provision_retry_min}
AutoProvision.bEnablePNP = 0
AutoProvision.bEnableDHCPOption = 1
;AutoProvision.listUserOptions = 
AutoProvision.strServerURL = {provisionserver}
AutoProvision.strKeyAES16 = {aeskey}
AutoProvision.strKeyAES16MAC = {aeskey}
<!-- END: main -->