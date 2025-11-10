function pre_install {
    Start-Process "$dir\setup.exe" -Wait -ArgumentList 'extract64' -WorkingDirectory "$dir"
    Remove-Item "$dir\setup.exe"
    Get-ChildItem "$dir\*.msi" | Rename-Item -NewName 'setup.msi'
}

function install {
    if (-not (is_admin)) {
        error "$app requires admin rights to $cmd"
        break
    }
    $proc = start-process 'msiexec' -NoNewWindow -passthru -argumentlist "/i $dir\setup.msi /qn ADDLOCAL=StartMenu"
    if (-not $proc.waitforexit(10000)) {
        error 'failed installing openshell due to timeout (10 seconds)'
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
    $proc = start-process 'msiexec' -NoNewWindow -passthru -argumentlist "/x $dir\setup.msi /qn"
    if (-not $proc.waitforexit(10000)) {
        error 'failed uninstalling openshell due to timeout (10 seconds)'
        break
    }
    if (get-process explorer -ea 0) {
        stop-process -name 'explorer' -force
    }
}
