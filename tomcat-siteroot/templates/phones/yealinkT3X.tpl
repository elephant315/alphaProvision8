<!-- BEGIN: main -->
;;[ cfg:/rundata/config/system.ini,onchanged=system(reboot);onchs=123; ]
;;cfg:/rundata/config/user/voip/sipAccount0.cfg-->Path for configuration file
;;cfg:/rundata/config/user/voip/sipAccount0.cfg,reboot=0--> reboot=0,it means it will not reboot updating
;;cfg:/rundata/config/user/voip/sipAccount0.cfg,reboot=1-->reboot-1,it means it will reboot after updating


[ cfg:/phone/config/voip/sipAccount0.cfg,account=0;reboot=0 ]
;audio0.enable = 1
;audio0.priority = 2
;audio0.PayloadType = PCMU
;audio0.rtpmap = 0

;audio1.enable = 1
;audio1.priority = 1
;audio1.PayloadType = PCMA
;audio1.rtpmap = 8

;audio2.enable = 0
;audio2.priority = 3
;audio2.PayloadType = G723_53
;audio2.rtpmap = 4

;audio3.enable = 0
;audio3.priority = 4
;audio3.PayloadType = G723_63
;audio3.rtpmap = 4

;audio4.enable = 1
;audio4.priority = 5
;audio4.PayloadType = G729
;audio4.rtpmap = 18

;audio5.enable = 1
;audio5.priority = 6
;audio5.PayloadType = G722
;audio5.rtpmap = 9

;audio6.enable = 0
;audio6.priority = 7
;audio6.PayloadType = iLBC
;audio6.rtpmap = 102

;audio7.enable = 0
;audio7.priority = 8
;audio7.PayloadType = G726-16
;audio7.rtpmap = 112

;audio8.enable = 0
;audio8.priority = 9
;audio8.PayloadType = G726-24
;audio8.rtpmap = 102

;audio9.enable = 0
;audio9.priority = 10
;audio9.PayloadType = G726-32
;audio9.rtpmap = 2

;audio10.enable = 0
;audio10.priority = 11
;audio10.PayloadType = G726-40
;audio10.rtpmap = 104

account.Enable = {enabled}
account.Label = {label}
account.DisplayName = {label}
account.UserName = {username}
account.AuthName = {username}
account.password = {password}
account.SIPServerHost = {serverhost}
account.SIPServerPort = {serverport}
;account.SIPListenRandom = 0
account.SIPListenPort = {listenport}
account.Expire = {expire}
account.UseOutboundProxy = {useproxy}
account.OutboundHost = {proxyhost}
account.OutboundPort = {proxyport}
;account.EnableEncrypt = 0
;account.EncryptKey = 29749
;account.EncryptVersion = 1
;account.BakOutboundHost = 
;account.BakOutboundPort = 5060
;;account.EnableSTUN = {nattraversal}
;;account.proxy-require = {nattraversal}
account.ptime = 20
account.srtp_encryption = {rtpencrypt}
;account.srtp_encryption_algorithm = 0
;account.BackupSIPServerHost = 
;account.BackupSIPServerPort = 5060
;account.Enable 100Rel = 0
;account.precondition = 0
;account.SubsribeRegister = 0
;account.CIDSource = 0
;account.EnableSessionTimer = 0
;account.SessionExpires = 
;account.SessionRefresher = 0
;account.EnableUserEqualPhone = 0
;account.BLFList_URI = 
;account.BlfListCode = 
;account.SubsribeMWI = 0
;account.AnonymousCall = 0
;account.RejectAnonymousCall = 0
;account.Transport = 0
;account.ShareLine = 0
;account.dialoginfo_callpickup = 0
account.AutoAnswer = {autoanswer}
;account.MissedCallLog = 1
;account.AnonymousCall_OnCode = 
;account.AnonymousCall_OffCode = 
;account.AnonymousReject_OnCode = 
;account.AnonymousReject_OffCode = 
;account.BLANumber = 
;account.SubscribeMWIExpire = 3600
;account.RegisterMAC = 
;account.RegisterLine = 
;account.conf-type = 0  
;account.conf-uri = 
;account.SubscribeACDExpire= 3600
;account.IdleScreenEnable = 0
;account.IdleScreenURL = 
RingTone.RingType = {ringtype}

DTMF.DTMFInbandTransfer = {dtmftype}
DTMF.DTMFPayload = {dtmfpayload}
DTMF.InfoType = {dtmfinfo}

NAT.MaxRTPPort = {rtpmax}
NAT.MinRTPPort = {rtpmin}
NAT.NATTraversal = {nattraversal}
NAT.STUNServer = {stunserver}
NAT.STUNPort = {stunport}
;NAT.EnableUDPUpdate = 1
;NAT.UDPUpdateTime = 30
;NAT.rport = 0

;ADVANCED.default_t1 = 0.5
;ADVANCED.default_t2 = 4
;ADVANCED.default_t4 = 5

;blf.SubscribePeriod = 1800
;blf.BLFList_URI = 


[ cfg:/config/system.ini,reboot=1 ]
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
LocalTime.bNTPEnable = 1


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


;QoS.SIGNALTOS = 40
;QoS.RTPTOS = 40

;VPN.EnableVPN = 0

RTPPORT.MaxRTPPort = {rtpmax}
RTPPORT.MinRTPPort = {rtpmin}

VLAN.ISVLAN = {vlanwan}
VLAN.VID = {vlanvid}
;VLAN.USRPRIORITY = 0
;VLAN.CFI = 0
;VLAN.PC_PORT_VLAN_ENABLE = 0
;VLAN.PC_PORT_VID = 0
;VLAN.PC_PORT_PRIORITY = 0

;telnet.telnet_enable = 0

[ cfg:/phone/config/user.ini,reboot=0 ]
;PoundSend.Enable = 0
;Webserver Type.WebType = 1

;AreaCode.code = 
;AreaCode.minlen = 1
;AreaCode.maxlen = 15
;AreaCode.LineID = 

;BlockOut.1 = 
;BlockOut.2 = 
;BlockOut.3 = 
;BlockOut.4 = 
;BlockOut.5 = 
;BlockOut.6 = 
;BlockOut.7 = 
;BlockOut.8 = 
;BlockOut.9 = 
;BlockOut.10 = 


;AlwaysFWD.Enable = 0
;AlwaysFWD.Target = 
;AlwaysFWD.On_Code = 
;AlwaysFWD.Off_Code = 


;BusyFWD.Enable = 0
;BusyFWD.Target = 
;BusyFWD.On_Code = 
;BusyFWD.Off_Code = 

;TimeoutFWD.Enable = 0
;TimeoutFWD.Target = 
;TimeoutFWD.Timeout = 10
;TimeoutFWD.On_Code = 
;TimeoutFWD.Off_Code = 

;Message.VoiceNumber0 = 
;Message.VoiceNumber1 = 
;Message.VoiceNumber2 = 
;Message.VoiceNumber3 = 
;Message.VoiceNumber4 = 
;Message.VoiceNumber5 = 

;Features.Call_Waiting = 1
;Features.Hotlinenumber = 
;Features.Hotlinedelay = 4
;Features.BusyToneDelay = 0
;Features.DND_Code = 480
;Features.Refuse_Code = 486
;Features.CallCompletion = 0
;Features.AllowIntercom  = 1
;Features.IntercomMute  = 0
;Features.IntercomTone  = 1
;Features.IntercomBarge  = 1
;Features.Call_WaitingTone = 1
;Features.ButtonSoundOn = 1
;Features.BroadsoftFeatureKeySync  = 0 
;Features.SaveCallHistory = 1 

;Phone-DND.DND_On_Code = 
;Phone-DND.DND_Off_Code = 

;Trans.IsOnHookTrans = 1
;Emergency.Num = 0
;RingerDevice.IsUseHeadset = 0

;ACD.AutoAvailable = 0
;ACD.AutoAvailableTimer = 60
;ACD.Broadsoft = 0

;AutoRedial.EnableRedial = 0
;AutoRedial.RedialInterval = 10
;AutoRedial.RedialTimes = 10

;Transfer.BlindTranOnHook = 1 
;Transfer.EnableSemiAttendTran = 1
;Transfer.TranOthersAfterConf = 0  

;Forbidden.DND = 0
;Forbidden.FWD = 0

;sip.ReservePound = 1
;sip.RFC2543Hold = 0
;sip.UseOutBoundInDialog = 1

;FactoryConfig.CustomEnabled = 0

PhoneSetting.BackLight = {backlight}
;PhoneSetting.UnusedBackLight = 1
;PhoneSetting.BacklightTime = 60
PhoneSetting.BackGrounds = {backgroundpng}
;PhoneSetting.ScreensaverTime = 60
;PhoneSetting.Theme = 0
;PhoneSetting.Voicevolume = 4
;PhoneSetting.Ringtype = Ring1.wav
;PhoneSetting.InterDigitTime = 4
;PhoneSetting.FlashHookTimer = 1
;PhoneSetting.Lock = 0
;;PhoneSetting.ProductName = SIP-T38G
;PhoneSetting.ReDialTone = 
;PhoneSetting.RingForTranFailed = Ring1.wav
;PhoneSetting.PreDialAutoDial = 0
;PhoneSetting.LogonWizard = 0
;PhoneSetting.IsDeal180 = 1
;PhoneSetting.ContrastEXP1 = 6 
;PhoneSetting.ContrastEXP2 = 6 
;PhoneSetting.ContrastEXP3 = 6 
;PhoneSetting.ContrastEXP4 = 6 
;PhoneSetting.ContrastEXP5 = 6 
;PhoneSetting.ContrastEXP6 = 6
;PhoneSetting.IsDefineKey = 0


;Lang.ActiveWebLanguage = English
;Lang.WEBLanguage = English

;RemotePhoneBook0.URL = 
;RemotePhoneBook0.Name = 
;RemotePhoneBook1.URL = 
;RemotePhoneBook1.Name = 
;RemotePhoneBook2.URL = 
;RemotePhoneBook2.Name = 
;RemotePhoneBook3.URL = 
;RemotePhoneBook3.Name = 
;RemotePhoneBook4.URL = 
;RemotePhoneBook4.Name = 


;AlertInfo0.Text = 
;AlertInfo0.Ringer = 1

;AlertInfo1.Text = 
;AlertInfo1.Ringer = 1

;AlertInfo2.Text = 
;AlertInfo2.Ringer = 1

;AlertInfo3.Text = 
;AlertInfo3.Ringer = 1

;AlertInfo4.Text = 
;AlertInfo4.Ringer = 1

;AlertInfo5.Text = 1
;AlertInfo5.Ringer = 1

;AlertInfo6.Text = 
;AlertInfo6.Ringer = 1

;AlertInfo7.Text = 
;AlertInfo7.Ringer = 1

;AlertInfo8.Text = 
;AlertInfo8.Ringer = 1

;AlertInfo9.Text = 
;AlertInfo9.Ringer = 1
                    
;vpm_tone_Country.Country = Custom   
;Tone Param.dial = 
;Tone Param.ring = 
;Tone Param.busy =  
;Tone Param.congestion = 
;Tone Param.callwaiting = 
;Tone Param.dialrecall = 
;Tone Param.record = 
;Tone Param.info = 
;Tone Param.stutter = 
;Tone Param.message = 
;Tone Param.autoanswer = 
;Tone Param.callwaiting2 = 
;Tone Param.callwaiting3 = 
;Tone Param.callwaiting4 = 

;Zero.WaitTime = 5
;Zero.ForbidZero = 1 

;ActionURL.SetupCompleted = 
;ActionURL.LogOn = 
;ActionURL.LogOff = 
;ActionURL.RegisterFailed = 
;ActionURL.Offhook = 
;ActionURL.Onhook = 
;ActionURL.IncomingCall = 
;ActionURL.OutgoingCall = 
;ActionURL.CallEstablished = 
;ActionURL.CallTerminated = 
;ActionURL.DNDOn = 
;ActionURL.DNDOff = 
;ActionURL.AwaysFWDOn = 
;ActionURL.AwaysFWDOff = 
;ActionURL.BusyFWDOn = 
;ActionURL.BusyFWDOff = 
;ActionURL.NoAnswerFWDOn = 
;ActionURL.NoAnswerFWDOff = 
;ActionURL.TransferCall = 
;ActionURL.BlindTransferCall =
;ActionURL.AttendedTransferCall = 
;ActionURL.Hold = 
;ActionURL.Unhold = 
;ActionURL.Mute = 
;ActionURL.Unmute = 
;ActionURL.MissedCall = 


;[ cfg:/phone/config/vpPhone/vpPhone.ini ]
;programablekey1.DKtype = 28
;programablekey1.Line = 0
;programablekey1.Value = 
;programablekey1.XMLPhoneBook = 

;memory1.DKtype = 
;memory1.Line = 0
;memory1.Value = 
;memory1.Label = 
;memory1.PickupValue = 



;[ cfg:/phone/config/Contacts/LDAP.cfg ]
;LDAP.NameFilter = 
;LDAP.NumberFilter = 
;LDAP.host = 0.0.0.0
;LDAP.port = 389
;LDAP.base = 
;LDAP.user = 
;LDAP.pswd = 
;LDAP.MaxHits = 50
;LDAP.NameAttr = 
;LDAP.NumbAttr = 
;LDAP.DisplayName = 
;LDAP.version = 3
;LDAP.SearchDelay = 2000
;LDAP.CallInLookup = 0
;LDAP.LDAPSort = 0
;LDAP.DialLookup = 0


;[ cfg:/phone/config/vpPhone/Ext38_00000000000001.cfg ]
;Key0.DKtype = 37
;Key0.Line = 0
;Key0.Value = 
;Key0.type = 
;Key0.PickupValue = 
;Key0.Label = List 1


;[ bin:/phone/config/ContactData.xml ]
;url = 

;[ bin:/phone/config/Pics/Contact.tar ]
;url = 

[ bin:/phone/userdata/ScreenSaver/IMG_3156.png]
url = {screensaverpngurl}

[ bin:/phone/userdata/BackGround/IMG_3156.png]
url = {backgroundpngurl}

;[ rom:Firmware]
;url = 




[ cfg:/phone/config/user.ini,reboot=0 ] 
UserName.admin = admin
UserName.var = var
UserName.user = user

[ psw:/phone/config/.htpasswd ]
user = 2030
admin = 2030
var = 2030
;;For T3XG series IP phones, if you want to apply a new user name, you have delete the previous user name via sentences as below:
;;-admin = 
;;-user = 
;;-var =

;;Enable 3-Level privilege
;[ cfg:/phone/config/user.ini,reboot=0 ] 
;Advanced.var_enabled = 0

;;Upload end-point side certificate and the certificate will be saved in path:/phone/config/certs
;[ bin: /tmp/ca.crt]
;url = 

;;Upload server side certificate and the certificate will be saved in path:/phone/config/certs/server
;[ bin: /tmp/server.pem]
;url = 

;;Upload configuration file for 3-Level privilege
;[ bin:/phone/config/WebItemsLevel.cfg ]
;url = 
<!-- END: main -->
