$forceDevice = [System.Convert]::ToBoolean($env:ForceDevice)
$debug = [System.Convert]::ToBoolean($env:Debug)
write-host "*********************************************************"
write-host "SecondsToSleep=$env:SecondsToSleep"
write-host "TempOffset=$env:TempOffset"
write-host "ForceDevice=$forceDevice"
write-host "PoolPumpDeviceName=$env:PoolPumpDeviceName"
write-host "PoolTempDeviceName=$env:PoolTempDeviceName"
write-host "PoolInTempDeviceName=$env:PoolInTempDeviceName"
write-host "PoolOnOffDeviceName=$env:PoolOnOffDeviceName"

write-host "PoolMaxTemp=$env:PoolMaxTemp"
write-host "Debug=$debug"
write-host "*********************************************************"

DO
{
    $currentTime = $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

    # Connect to Telldus Live!
    $AccessTokenSecret = $env:AccessTokenSecret | ConvertTo-SecureString -AsPlainText -Force

    Connect-TelldusLive -AccessToken $env:AccessToken -AccessTokenSecret $AccessTokenSecret

    # Start Or Stop Pool Pump based on temperature
    $pool_sensor = Get-TDSensor | where-object{$_.Name -eq $env:PoolTempDeviceName}
    $poolUt_sensor = Get-TDSensor | where-object{$_.Name -eq $env:PoolInTempDeviceName}
    $poolPump_Device = Get-TDDevice | Where-Object {$_.Name -eq $env:PoolPumpDeviceName}

    $enabled = $true
    if($env:PoolOnOffDeviceName -ne ""){
        $poolOnOff_Device = Get-TDDevice | Where-Object {$_.Name -eq $env:PoolOnOffDeviceName}
        $enabled = $poolOnOff_Device.State -eq "On"
    }

    [decimal]$poolUt_sensor.temp= [decimal]$poolUt_sensor.temp -$env:TempOffset

    $startPump = [decimal]$pool_sensor.temp -lt [decimal]$poolUt_sensor.temp
    $heatingtemp = [decimal]$poolUt_sensor.temp - [decimal]$pool_sensor.temp
    $maxPoolTempReached = $pool_sensor.temp -ge $env:PoolMaxTemp

    if($debug){
        write-host "DBG: AutoPoolHeater is $enabled"
        Write-Host 'DBG: Temp Offset ' $env:TempOffset 'C'
        Write-Host 'DBG: Sun temp ' $poolUt_sensor.temp 'C'
        Write-Host 'DBG: Pool temp ' $pool_sensor.temp 'C'
        if($heatingtemp -ge 0){Write-Host 'DBG: Is sun heating with ' $heatingtemp 'C'}
        if($heatingtemp -lt 0){Write-Host 'DBG: Is sun cooling with ' $heatingtemp 'C'}
    }
    
    if($maxPoolTempReached){
        if($debug){write-host "DBG: Max pool temp $($env:PoolMaxTemp) reached!"}
        $startPump = $false;
    }

    

    if($startPump -and $enabled)
    {
        if(-NOT $forceDevice -AND $poolPump_Device.State -eq "On") 
        { 
            if($debug){Write-Host "DBG: $($poolPump_Device.Name) is already [On]"}
            Start-Sleep -Seconds $env:SecondsToSleep
            continue
        }
        Write-Host "`r`n$($currentTime)"
        if($heatingtemp -ge 0){Write-Host 'Is sun heating with ' $heatingtemp 'C'}
        if($heatingtemp -lt 0){Write-Host 'Is sun cooling with ' $heatingtemp 'C'}
        Write-Host "Setting $($poolPump_Device.Name) to [On]"
        Set-TDDevice -DeviceID $($poolPump_Device.DeviceID) -Action turnOn
    }

    if(!$startPump -and $enabled)
    {
        if(-NOT $forceDevice -AND $poolPump_Device.State -eq "Off")
        { 
            if($debug){Write-Host "DBG: $($poolPump_Device.Name) is already [Off]"}
            Start-Sleep -Seconds $env:SecondsToSleep
            continue
        }
        Write-Host "`r`n$($currentTime)"
        if($heatingtemp -ge 0){Write-Host 'Is sun heating with ' $heatingtemp 'C'}
        if($heatingtemp -lt 0){Write-Host 'Is sun cooling with ' $heatingtemp 'C'}
        Write-Host "Setting $($poolPump_Device.Name) to [Off]"
        Set-TDDevice -DeviceID $($poolPump_Device.DeviceID)-Action turnOff
    }

    Start-Sleep -Seconds $env:SecondsToSleep

} While ($true)