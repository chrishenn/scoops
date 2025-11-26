param (
    [switch] $install,
    [switch] $uninstall
)

function install {
    if ($architecture -eq 'arm64') {
        mv "$dir\EverythingARM64.exe" 'Everything.exe'
    }
    cp "$bucketsdir\$bucket\scripts\$app\Everything.ini" "$dir" -force
    cp "$bucketsdir\$bucket\scripts\$app\Everything.db" "$dir" -force
    cp "$bucketsdir\$bucket\scripts\$app\Everything.lng" "$dir" -force

    if (get-service -name everything -ea 0) {
        set-service -name everything -startuptype Automatic -ea 0
        start-service -name everything -ea 0
    }
}

function svc_rm ($name) {
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        remove-service -ea 0 $name
    } else {
        [void](sc.exe delete $name)
    }
}

function uninstall {
    if (get-service -name everything -ea 0) {
        stop-service -name everything -ea 0
        svc_rm everything
    }
    if (get-process -name everything -ea 0) {
        Stop-Process -name everything -force -ea 0
        wait-process -name everything -ea 0
    }
}

function main {
    if ($install) {
        install
    } elseif ($uninstall) {
        uninstall
    }
}
main
