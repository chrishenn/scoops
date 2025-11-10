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

function add_menu (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $root_path,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $item_id,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $item_str,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $item_ico,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $item_subcmd_ids
) {
    ## Add items to right-click menu
    # Add simple submenu for shell item at root_path, with subcommands in cmd store at item_subcmd_ids
    $submenu_root = "$root_path\$item_id"
    SetProp "$submenu_root" 'MUIVerb' "String" "$item_str"
    SetProp "$submenu_root" 'Icon' "String" "$item_ico"
    SetProp "$submenu_root" 'SubCommands' "String" "$item_subcmd_ids"
}

function add_menus (
    [string] $menustr,
    [string] $name,
    [string] $topico,
    [string] $subcmds
) {
    # add menu with subcmds to right click menu for: {directoy, background of file explorer}
    $shell_dir = "HKLM:\Software\Classes\Directory\shell"
    $shell_back = "HKLM:\Software\Classes\Directory\Background\shell"
    add_menu $shell_dir $menustr $name $topico $subcmds
    add_menu $shell_back $menustr $name $topico $subcmds
}

function add_menucmd (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $root_path,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $item_id,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $item_str,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $item_ico,
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] $item_cmd
) {
    # Add menu option for shell item at root_path, with command item_cmd
    $item_path = "$root_path\$item_id"
    $item_cmd_path = "$item_path\command"

    SetProp $item_path 'Icon' "String" "$item_ico"
    SetProp $item_path 'MUIVerb' "String" "$item_str"
    SetProp $item_cmd_path '(default)' "String" "$item_cmd"
}

function add_menucmds (
    [string] $menustr,
    [string] $name,
    [string] $topico,
    [string] $cmd
) {
    # add menu with subcmds to right click menu for: {directoy, background of file explorer}
    $shell_dir = "HKLM:\Software\Classes\Directory\shell"
    $shell_back = "HKLM:\Software\Classes\Directory\Background\shell"
    add_menucmd $shell_dir $menustr $name $topico $cmd
    add_menucmd $shell_back $menustr $name $topico $cmd
}

function wt_addmenu {
    $rsc_src = "$bucketsdir\chris\scripts\$app\resources"
    $rsc = "$persist_dir\resources"
    [void](mkdir -force -ea 0 "$rsc")
    [void](cp -force "$rsc_src\*" -filter *.ico "$rsc")

    add_menucmds 'SUBMENU0' 'Terminal Here' "$rsc\term.ico" 'cmd.exe /c start wt -d "%V"'
    $cmd = @('{SUBMENU2}', 'Cmd', "$rsc\cmd.ico", 'cmd.exe /c start wt -p "Command Prompt" -d "%V"')
    $bash = @('{SUBMENU4}', 'Bash', "$rsc\bash.ico", 'cmd.exe /c start wt -p "Git Bash" -d "%V"')
    $pshell = @('{SUBMENU3}', 'Powershell', "$rsc\pshell.ico", 'cmd.exe /c start wt -p "Windows PowerShell" -d "%V"')

    $cstore = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell"
    add_menucmd $cstore @cmd
    add_menucmd $cstore @bash
    add_menucmd $cstore @pshell
    add_menus 'SUBMENU1' 'Terminal' "$rsc\term.ico" "$($cmd[0]);$($bash[0]);$($pshell[0])"

    $key = "HKLM:\Software\Classes\Directory\shell"
    SetProp $key '(Default)' 'String' 'Open'
    $key = 'HKLM:\Software\Classes\Directory\Background\shellex\ContextMenuHandlers\new_dir'
    SetProp $key '(Default)' 'String' '{D969A300-E7FF-11d0-A93B-00A0C90F2719}'
}

function install {
    $winVer = [Environment]::OSVersion.Version
    if (($winver.Major -lt '10') -or ($winVer.Build -lt 19041)) {
        error 'At least Windows 10 20H1 (build 19041) is required.'
        break
    }
    if (!(Test-Path "$persist_dir\.portable")) {
        Add-Content "$dir\.portable" ''
    }

    [void](mkdir -force -ea 0 "$persist_dir\settings")
    $sett = "$persist_dir\settings\settings.json"
    cp -force "$bucketsdir\chris\scripts\$app\settings.json" "$sett"

    $bash = "$(scoop prefix git)\bin\bash.exe"
    jq -n --arg BASH_EXE $bash -f "$sett" | set-content "$sett"
}

install
wt_addmenu
