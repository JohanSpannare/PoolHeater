# Introduction 
Auto Start Stop pump heating pool based on Sun activity

# Getting Started

docker run -e AccessToken=<YOUR AutomaTD ACCESS TOKEN> -e AccessTokenSecret=<TOKEN SECRET> --rm -it  autopoolheater:latest

ENV AccessToken=<YOUR AutomaTD ACCESS TOKEN>
ENV AccessTokenSecret=<TOKEN SECRET>
ENV SecondsToSleep=10
ENV PoolOnOffDeviceName="Pool Pump" <Name of pump in TelldusLive>
ENV PoolTempDeviceName="Pool" <Name of the pool temperature in TelldusLive>
ENV PoolInTempDeviceName="Pool Ut" <Name of the temperature coming into pool in TelldusLive>
ENV ForceDevice=false <True=Send the command to Telldus regardless of previous state>
ENV TempOffset=1 <How much the Sun must be heating before starting the pump>