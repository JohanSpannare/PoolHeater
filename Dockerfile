FROM mcr.microsoft.com/powershell
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#Install Telldus Powershell Module
RUN Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
RUN Install-Module -Name AutomaTD -Confirm:$False

ENV AccessToken=
ENV AccessTokenSecret=
ENV SecondsToSleep=10
ENV PoolPumpDeviceName="Pool Pump"
ENV PoolTempDeviceName="Pool"
ENV PoolInTempDeviceName="Pool Ut"
ENV PoolOnOffDeviceName="Pool Automatik"
ENV PoolMaxTemp=30
ENV ForceDevice=false
ENV TempOffset=1.5
ENV APPDATA="/"
ENV Debug=false
ENTRYPOINT pwsh -file AutoPoolHeater.ps1
COPY AutoPoolHeater.ps1 AutoPoolHeater.ps1