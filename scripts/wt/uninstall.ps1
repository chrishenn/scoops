$shell_dir = "HKLM:\Software\Classes\Directory\shell"
$shell_back = "HKLM:\Software\Classes\Directory\Background\shell"
$cstore = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell"

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

function rm_menus (
    [string] $menustr
) {
    rm -r -force -ea 0 "$shell_dir\$menustr"
    rm -r -force -ea 0 "$shell_back\$menustr"
}

function rm_menucmds (
    [string] $menustr
) {
    rm -r -force -ea 0 "$shell_dir\$menustr"
    rm -r -force -ea 0 "$shell_back\$menustr"
}

function wt_rmmenu {
    rm_menucmds 'SUBMENU0'
    rm_menus 'SUBMENU1'
    rm -r -force -ea 0 "$cstore\{SUBMENU2}"
    rm -r -force -ea 0 "$cstore\{SUBMENU4}"
    rm -r -force -ea 0 "$cstore\{SUBMENU3}"

    $key = "HKLM:\Software\Classes\Directory\shell"
    SetProp $key '(Default)' 'String' 'Open'
    $key = 'HKLM:\Software\Classes\Directory\Background\shellex\ContextMenuHandlers\new_dir'
    SetProp $key '(Default)' 'String' '{D969A300-E7FF-11d0-A93B-00A0C90F2719}'
}

wt_rmmenu
