# Introduction 
Start Stop pump heating pool based on sun activity

# Getting Started

docker run -e AccessToken=<YOUR AutomaTD ACCESS TOKEN> -e AccessTokenSecret=<TOKEN SECRET> --rm -it  jspannare/autopoolheater

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