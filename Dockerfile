FROM mcr.microsoft.com/powershell
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

#Install Telldus Powershell Module
RUN Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
RUN Install-Module -Name AutomaTD -Confirm:$False

ENV AccessToken=
ENV AccessTokenSecret=
ENV SecondsToSleep=10
ENV PoolOnOffDeviceName="Pool Pump"
ENV PoolTempDeviceName="Pool"
ENV PoolInTempDeviceName="Pool Ut"
ENV PoolMaxTemp=30
ENV ForceDevice=false
ENV TempOffset=1
ENV APPDATA="/"

COPY AutoPoolHeater.ps1 AutoPoolHeater.ps1
ENTRYPOINT pwsh -file AutoPoolHeater.ps1