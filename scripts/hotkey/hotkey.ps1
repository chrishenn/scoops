param (
    [switch] $install,
    [switch] $pre_uninstall,
    [switch] $uninstall
)

function interactive {
    $noni = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonI*' }
    return ([Environment]::UserInteractive -and -not $noni)
}

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
    [parameter(Mandatory = $true)] $value
) {
    keyadd "$key"
    if (-not (propexist "$key" "$name")) {
        [void](new-itemProperty "$key" -Name "$name" -PropertyType $type -Value $value -Force)
    } else {
        [void](Set-ItemProperty "$key" -Name "$name" -Type $type -Value $value -Force)
    }
}

function install {
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
    foreach ($exe in (get-childitem $dir -filter *.exe)) {
        setprop $key $exe.basename 'String' $exe.fullname

        if (interactive) {
            & $exe.fullname
        }
    }
    if (-not (interactive)) {
        write-host ''
        write-host ''
        write-host -f y "Installing from non-interactive shell: binaries will run at next login"
        write-host ''
    }
}

function pre_uninstall {
    foreach ($exe in (get-childitem $dir -filter *.exe)) {
        if (get-process -name $exe.basename -ea 0) {
            stop-process -name $exe.basename -ea 0
            wait-process -name $exe.basename -ea 0
        }
    }
}

function uninstall {
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
    foreach ($exe in (get-childitem $dir -filter *.exe)) {
        remove-itemproperty $key $exe.basename
    }
}

function main {
    if ($install) {
        install
    } elseif ($pre_uninstall) {
        pre_uninstall
    } elseif ($uninstall) {
        uninstall
    }
}
main
