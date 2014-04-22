<!-- BEGIN: main -->
[ account ]
path = /config/voip/sipAccount0.cfg
Enable = {enabled}
Label = {label}
DisplayName = {label}
AuthName = {username}
UserName = {username}
password = {password}
SIPServerHost = {serverhost}
SIPServerPort = {serverport}
UseOutboundProxy = {useproxy}
OutboundHost = {proxyhost}
OutboundPort = {proxyport}
Transport = {transport}
#BakOutboundHost = 
#BakOutboundPort = 5060
#proxy-require = 
#AnonymousCall = 0
#RejectAnonymousCall = 0
Expire = {expire}
SIPListenPort = {listenport}
#Enable 100Rel = 0
#precondition = 0
#SubscribeRegister = 0
#SubscribeMWI = 0
#CIDSource = 0
#EnableSessionTimer = 0
#SessionExpires = 
#SessionRefresher = 0
#EnableUserEqualPhone = 0
srtp_encryption = {rtpencrypt}
#ptime = 20
#ShareLine = 
#dialoginfo_callpickup = 
#MissedCallLog = 1
AutoAnswer = {autoanswer}
#AnonymousCall_OnCode = 
#AnonymousCall_OffCode = 
#AnonymousReject_OnCode = 
#AnonymousReject_OffCode = 
#BLANumber =
#conf-type = 0  
#conf-uri = 
#BlfListCode =
#SubscribeACDExpire= 3600
#SubscribeMWIToVM = 
#SIPServerType =

[ DTMF ]
path = /config/voip/sipAccount0.cfg
DTMFInbandTransfer = {dtmftype}
InfoType = {dtmfinfo}
DTMFPayload = {dtmfpayload}

[ NAT ]
path = /config/voip/sipAccount0.cfg
NATTraversal = {nattraversal}
STUNServer = {stunserver}
STUNPort = {stunport}
#EnableUDPUpdate = 1
#UDPUpdateTime = 30
#rport = 0

#[blf]
#path = /config/voip/sipAccount0.cfg
#SubscribePeriod = 1800
#BLFList_URI = 

#[ audio0 ]
#path = /config/voip/sipAccount0.cfg
#enable = 1
#PayloadType = PCMU
#priority = 1
#rtpmap = 0

#[ audio1 ]
#path = /config/voip/sipAccount0.cfg
#enable = 1
#PayloadType = PCMA
#priority = 2
#rtpmap = 8

#[ audio2 ]
#path = /config/voip/sipAccount0.cfg
#enable = 0
#PayloadType = G723_53
#priority = 0
#rtpmap = 4

#[ audio3 ]
#path = /config/voip/sipAccount0.cfg
#enable = 0
#PayloadType = G723_63
#priority = 0
#rtpmap = 4

#[ audio4 ]
#path = /config/voip/sipAccount0.cfg
#enable = 1
#PayloadType = G729
#priority = 3
#rtpmap = 18

#[ audio5 ]
#path = /config/voip/sipAccount0.cfg
#enable = 1
#PayloadType = G722
#priority = 4
#rtpmap = 9

#[ audio7 ]
#path = /config/voip/sipAccount0.cfg
#enable = 0
#PayloadType = G726-16
#priority = 0
#rtpmap = 112

#[ audio8 ]
#path = /config/voip/sipAccount0.cfg
#enable = 0
#PayloadType = G726-24
#priority = 0
#rtpmap = 102

#[ audio9 ]
#path = /config/voip/sipAccount0.cfg
#enable = 0
#PayloadType = G726-32
#priority = 0
#rtpmap = 2

#[ audio10 ]
#path = /config/voip/sipAccount0.cfg
#enable = 0
#PayloadType = G726-40
#priority = 0
#rtpmap = 104

[ RingTone ]
path = /config/voip/sipAccount0.cfg
RingType = {ringtype}

[ WAN ]
path = /config/Network/Network.cfg
#WANType:0:DHCP,1:PPPoE,2:StaticIP
WANType = {wantype}
WANStaticIP = {wanstaticip}
WANSubnetMask = {wanmask}
WANDefaultGateway = {wangw}

[ DNS ]
path = /config/Network/Network.cfg
PrimaryDNS = {primarydns}
SecondaryDNS = {secondarydns}

#[ PPPoE ]
#path = /config/Network/Network.cfg
#PPPoEUser = 
#PPPoEPWD = 

[ LAN ]
path = /config/Network/Network.cfg
#LANTYPE:0:Router, 1:Bridge
LANTYPE = {lantype}
RouterIP = {langatewayip}
LANSubnetMask = {lansubnet}
EnableDHCP = {enabledhcp}
DHCPStartIP = {dhcpstart}
DHCPEndIP = {dhcpend}
#SpanToPCPort = 0

[ VLAN ]
path = /config/Network/Network.cfg
#ISVLAN,VID and USRPRIORITY are used for VLAN on LAN port
#PC_PORT_VLAN_ENABLE,PC_PORT_VID and PC_PORT_PRIORITY are used for PC port
ISVLAN = {vlanwan}
VID = {vlanvid}
#USRPRIORITY = 0
#PC_PORT_VLAN_ENABLE = 0
#PC_PORT_VID = 0
#PC_PORT_PRIORITY = 0

[ QOS ]
path = /config/Network/Network.cfg
SIGNALTOS = {signaltos}
RTPTOS = {rtpqos}

[ RTPPORT ]
path = /config/Network/Network.cfg
MaxRTPPort = {rtpmax}
MinRTPPort = {rtpmin}

#[ VPN ]
#path = /config/Network/Network.cfg
#EnableVPN =0

#[ Ethernet ]
#path = /config/Network/Network.cfg
#WANPortLink = 0
#PCPortLink = 0

#[ Lang ]
#path = /config/Setting/Setting.cfg
#WebLanguage is the setting of language on web management
#WebLanguage = 

[ Time ]
path = /config/Setting/Setting.cfg
TimeZone = +6
TimeServer1 = {ntpserver1}
TimeServer2 = ru.pool.ntp.org
Interval = 1000
#Set daylight saving time.SummerTime 0 means disable,1 means enable, 2 means automatic
#SummerTime = 2
#StartTime = 
#EndTime = 
#TimeFormat = 
#DateFormat = 
#OffSetTime = 
#DSTTimeType = 

[ PhoneSetting ]
path = /config/Setting/Setting.cfg
#InterDigitTime = 4
#FlashHookTimer = 1
#Lock = 0
#Ringtype = Ring1.wav
BackLight = {backlight}
#BacklightTime = 30
#ProductName = 
Contrast = {contrast}
#HandFreeSpkVol = 8
#HandFreeMicVol = 8
#HandSetSpkVol = 8
#HandSetMicVol = 8
#HeadSetSpkVol = 8
#HeadSetMicVol = 8
RingVol= {ringvol}
#RingForTranFailed = Ring1.wav
#LogonWizard = 0
#PreDialAutoDial = 0
#IsDeal180 = 0
#DialNowDelay = 1
#IsDefineKey = 0
#LogLevel =

#[ SignalToneVol ]
#path = /config/Setting/Setting.cfg
#Handset = 8
#Headset = 8
#Handfree = 8

#[ AlwaysFWD ]
#path = /config/Features/Forward.cfg
#Enable = 0
#Target = 
#On_Code = 
#Off_Code = 

#[ BusyFWD ]
#path = /config/Features/Forward.cfg
#Enable = 0
#Target = 
#On_Code = 
#Off_Code = 

#[ TimeoutFWD ]
#path = /config/Features/Forward.cfg
#Enable = 0
#Target = 
#Timeout = 10
#On_Code = 
#Off_Code = 

#[ Features ]
#path = /config/Features/Phone.cfg
#Call_Waiting = 1
#Hotlinenumber = 
#BusyToneDelay = 
#LCD_Logo = 
#DND_Code = 
#Refuse_Code = 
#DND_On_Code = 
#DND_Off_Code = 
#ButtonSoundOn = 1
#CallCompletion = 0
#AllowIntercom  = 1
#IntercomMute  = 0
#IntercomTone  = 1
#IntercomBarge  = 1
#Call_WaitingTone = 1
#Hotlinedelay = 4
#SendKeySoundOn = 1
#BroadsoftFeatureKeySync  = 0
#PswPrefix =
#PswLength =
#PswDialEnable = 0
#HistorySaveDisplay = 1
#SaveCallHistory = 1
#PswPrefix =
#PswLength =
#PswDialEnable = 0
#HistorySaveDisplay = 1
#SaveCallHistory = 1
#ButtonSoundOn = 1
#ClosePowerLight = 
#HideDTMF = 
#HideDTMFDelay = 
#DTMFRepetition = 
#ActionURILimitIP = 

#[ RingerDevice ]
#path = /config/Features/Phone.cfg
#IsUseHeadset = 0

#[ Trans ]
#path = /config/Features/Phone.cfg
#IsOnHookTrans = 1

#[ AutoRedial ]
#path = /config/Features/Phone.cfg
#EnableRedial = 0
#RedialInterval = 10
#RedialTimes = 10

#[ Profile ]
#path = /config/vpm.cfg
#VAD = 0
#CNG = 1
#ECHO = 1
#SIDE_TONE = -3
#headset_send = 29

#[ Jitter ]
#path = /config/vpm.cfg
#Adaptive = 1
#Min = 0
#Max = 300
#Nominal = 120

#[ Message ]
#path = /config/Features/Message.cfg
#Set voicemail number for each account
#VoiceNumber0 = 
#VoiceNumber1 = 
#VoiceNumber2 = 
#VoiceNumber3 = 
#VoiceNumber4 = 
#VoiceNumber5 = 

#[ Country ]
#path = /config/voip/tone.ini
#The tones are defined by countries.If Country = Custom,the customized values will be used.
#Country = 

[ autop_mode ]
path = /config/Setting/autop.cfg
mode = 6
schedule_min = {provision_retry_min}
#schedule_time = 
#schedule_time_end = 
#schedule_dayofweek = 

[ PNP ]
path = /config/Setting/autop.cfg
Pnp = 0

#[ cutom_option ]
#path = /config/Setting/autop.cfg
#cutom_option_code0 = 
#cutom_option_type0 = 1

[ autoprovision ]
path = /config/Setting/autop.cfg
server_address = {provisionserver}
#user = 
#password = 

[ AES_KEY ]
path = /config/Setting/autop.cfg
aes_key_16 = {aeskey}
aes_key_16_mac = {aeskey}
 
#[ ringtone ]
#path = /tmp/download.cfg
#server_address = 
 
#[ Lang ]
#path = /tmp/download.cfg
#server_address = 
 
#[ ContactList ]
#path = /tmp/download.cfg
#server_address = 

[ UserName ]
path = /config/Advanced/Advanced.cfg
admin = admin
user = user

[ AdminPassword ]
path =  /config/Setting/autop.cfg
password = 2030

[ UserPassword ]
path =  /config/Setting/autop.cfg
password = 2030

#[ firmware ]
#path = /tmp/download.cfg
#server_type = tftp
#server_ip = 
#server_port = 
#login_name = 
#login_pswd = 
#http_url   = 
#firmware_name = 

#[ DialNow ]
#path = /tmp/dialnow.xml 
#server_address =
<!-- END: main -->