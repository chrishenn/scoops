param (
    [switch] $pre_install,
    [switch] $install,
    [switch] $pre_uninstall
)

function pre_install {
    Start-Process "$dir\setup.exe" -Wait -a 'extract64' -WorkingDirectory "$dir"
    Remove-Item "$dir\setup.exe"
    Get-ChildItem "$dir\*.msi" | Rename-Item -NewName 'setup.msi'
}

function install {
    if (-not (is_admin)) {
        error "$app requires admin rights to $cmd"
        break
    }

    [void](mkdir -ea 0 "$env:programfiles\Open-Shell\Skins")
    cp -force "$bucketsdir\$bucket\scripts\$app\ame.skin7" "$env:programfiles\Open-Shell\Skins"

    reg import "$bucketsdir\$bucket\scripts\$app\openshell.reg"

    $proc = start-process 'msiexec' -NoNewWindow -passthru -a "/i $dir\setup.msi /qn ADDLOCAL=StartMenu"
    if (-not $proc.waitforexit(10000)) {
        write-host -F red 'failed installing openshell due to timeout (10 seconds)'
        error 'failed installing openshell'
        break
    }
    if (get-process explorer -ea 0) {
        stop-process -name 'explorer' -force
    }
}

function pre_uninstall {
    if (-not (is_admin)) {
        error "$app requires admin rights to $cmd"
        break
    }

    $proc = start-process 'msiexec' -NoNewWindow -passthru -a "/x $dir\setup.msi /qn"
    if (-not $proc.waitforexit(10000)) {
        error 'failed uninstalling openshell due to timeout (10 seconds)'
        break
    }

    rm -r -force -ea 0 "HKCU:\Software\OpenShell"
    rm -r -force -ea 0 "$env:programfiles\Open-Shell"
    rm -r -force -ea 0 "$env:localappdata\openshell"

    if (get-process explorer -ea 0) {
        stop-process -name 'explorer' -force
    }
}

function main {
    if ($pre_install) {
        pre_install
    } elseif ($install) {
        install
    } elseif ($pre_uninstall) {
        pre_uninstall
    }
}
main
