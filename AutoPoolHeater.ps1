$forceDevice = [System.Convert]::ToBoolean($env:ForceDevice)
write-host "*********************************************************"
write-host "SecondsToSleep=$env:SecondsToSleep"
write-host "TempOffset=$env:TempOffset"
write-host "ForceDevice=$forceDevice"
write-host "PoolOnOffDeviceName=$env:PoolOnOffDeviceName"
write-host "PoolTempDeviceName=$env:PoolTempDeviceName"
write-host "PoolInTempDeviceName=$env:PoolInTempDeviceName"
write-host "PoolMaxTemp=$env:PoolMaxTemp"
write-host "*********************************************************"

DO
{
    Write-Host "`r`n$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

    # Connect to Telldus Live!
    $AccessTokenSecret = $env:AccessTokenSecret | ConvertTo-SecureString -AsPlainText -Force

    Connect-TelldusLive -AccessToken $env:AccessToken -AccessTokenSecret $AccessTokenSecret

    # Start Or Stop Pool Pump based on temperature
    $pool_sensor = Get-TDSensor | where-object{$_.Name -eq "Pool"}
    $poolUt_sensor = Get-TDSensor | where-object{$_.Name -eq "Pool Ut"}
    $poolPump_Device = Get-TDDevice | Where-Object {$_.Name -eq "Pool Pump"}

    [decimal]$poolUt_sensor.temp= [decimal]$poolUt_sensor.temp -$env:TempOffset

    $startPump = [decimal]$pool_sensor.temp -lt [decimal]$poolUt_sensor.temp
    $heatingtemp = [decimal]$poolUt_sensor.temp - [decimal]$pool_sensor.temp
    $maxPoolTempReached = $pool_sensor.temp -ge $env:PoolMaxTemp

    Write-Host 'Temp Offset ' $env:TempOffset 'C'
    Write-Host 'Sun temp ' $poolUt_sensor.temp 'C'
    Write-Host 'Pool temp ' $pool_sensor.temp 'C'
    
    if($startPump){Write-Host 'Is sun heating with ' $heatingtemp 'C'}
    if(!$startPump){Write-Host 'Is sun cooling with ' $heatingtemp 'C'}
    
    if($maxPoolTempReached){
        write-host "Max pool temp $($env:PoolMaxTemp) reached!"
        
        $startPump = $false;
    }

    if($startPump)
    {
        if(-NOT $forceDevice -AND $poolPump_Device.State -eq "On") 
        { 
            Write-Host "$($poolPump_Device.Name) is already [On]"
            Start-Sleep -Seconds $env:SecondsToSleep
            continue
        }
        
        Write-Host "Setting $($poolPump_Device.Name) to [On]"
        Set-TDDevice -DeviceID $($poolPump_Device.DeviceID) -Action turnOn
    }

    if(!$startPump)
    {
        if(-NOT $forceDevice -AND $poolPump_Device.State -eq "Off")
        { 
            Write-Host "$($poolPump_Device.Name) is already [Off]"
            Start-Sleep -Seconds $env:SecondsToSleep
            continue
        }
    
        Write-Host "Setting $($poolPump_Device.Name) to [Off]"
        Set-TDDevice -DeviceID $($poolPump_Device.DeviceID)-Action turnOff
    }

    Start-Sleep -Seconds $env:SecondsToSleep

} While ($true)