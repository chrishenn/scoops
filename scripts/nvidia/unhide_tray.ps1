function keyadd (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $key
) {
    if (!(Test-Path "$key")) {
        [void](ni "$key" -Force)
    }
}

function propexist (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $key,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $val
) {
    # when key has no properties, this is null
    $prop = Get-ItemProperty $key -ea 0
    if ($null -eq $prop) {
        return $false
    }
    if ($null -eq ($prop | Select-Object -ExpandProperty $val -ea 0)) {
        return $false
    }
    return $true
}

function setprop (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $key,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $name,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $type,
    [parameter(Mandatory = $true)] $Value
) {
    keyadd "$key"
    if (-not (propexist "$key" "$name")) {
        [void](new-itemProperty "$key" -Name "$name" -PropertyType $type -Value $Value -Force)
    } else {
        [void](Set-ItemProperty "$key" -Name "$name" -Type $type -Value $Value -Force)
    }
}

function tray_unhide {
    write-host -f cyan "Unhiding nvidia tray icon; the tray icon will start after the next reboot"
    $key = 'HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\NVTray'
    SetProp $key 'StartOnLogin' 'DWORD' 1
    $key = 'HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak'
    SetProp $key 'DisableStoreNvCplNotifications' 'DWORD' 0
}

tray_unhide
