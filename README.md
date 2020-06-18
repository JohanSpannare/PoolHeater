# Introduction 
Start Stop pump heating pool based on sun activity

# Getting Started

## Generate Accesstoken for AutomaTD (Telldus Powershell Module)
```
docker run --rm -it  jspannare/autopoolheater
```
```
*********************************************************
SecondsToSleep=10
TempOffset=1.5
ForceDevice=False
PoolPumpDeviceName=Pool Pump
PoolTempDeviceName=Pool
PoolInTempDeviceName=Pool Ut
PoolOnOffDeviceName=Pool Automatik
PoolMaxTemp=30
Debug=False
*********************************************************
AccessToken not detected!
Creating AccessToken...
Please go to the following URL to authenticate this module:
https://pa-api.telldus.com/oauth/authorize?oauth_token=98c44515d7a227db8fe4dfa93219ff9a05eeb6ca4&oauth_callback=https%3A%2F%2Fautomatd.net%2F
Token: b6ab4b578hfede8cb81545398085a05805edf5b41 TokenSecret: 67g4a8c6eca1d6c14c19ccf935d830b1
Save this!
```
## Start Container using AccessToken
```
docker run -e AccessToken=b6ab4b578hfede8cb81545398085a05805edf5b41 -e AccessTokenSecret=67g4a8c6eca1d6c14c19ccf935d830b1 --rm -it  jspannare/autopoolheater
```
```
*********************************************************
SecondsToSleep=10
TempOffset=1.5
ForceDevice=False
PoolPumpDeviceName=Pool Pump
PoolTempDeviceName=Pool
PoolInTempDeviceName=Pool Ut
PoolOnOffDeviceName=Pool Automatik
PoolMaxTemp=30
Debug=False
*********************************************************

2020-06-18 13:34:35
Is sun heating with  3.8 C
Setting Pool pump to [On]
```

ENV AccessToken=<YOUR AutomaTD ACCESS TOKEN>
  
ENV AccessTokenSecret=<TOKEN SECRET>
  
ENV SecondsToSleep=10

ENV PoolOnOffDeviceName="Pool Pump" <Name of pump in TelldusLive>
  
ENV PoolTempDeviceName="Pool" <Name of the pool temperature in TelldusLive>
  
ENV PoolInTempDeviceName="Pool Ut" <Name of the temperature coming into pool in TelldusLive>

ENV PoolOnOffDeviceName="Pool Automatik" <Name of the device to enable or disable Pool heater process [OPTIONAL]>

ENV PoolMaxTemp=30 <Max allowed temperature in pool>

ENV ForceDevice=false <True=Send the command to Telldus regardless of previous state>

ENV TempOffset=1 <How much the Sun must be heating before starting the pump>

ENV Debug=false <True to enable debug logging>

# Docker Hub
https://hub.docker.com/r/jspannare/autopoolheater