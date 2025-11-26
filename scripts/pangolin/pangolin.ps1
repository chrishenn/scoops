param (
    [switch] $uninstall
)

function svc_rm ($name) {
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        remove-service -ea 0 $name
    } else {
        [void](sc.exe delete $name)
    }
}

function uninstall {
    Invoke-ExternalCommand msiexec -runas -argumentlist "/x $dir\\setup.msi_ /qn"

    # the uninstaller doesn't remove the service, which will fail on subsequent install when the bin location changes
    if ($svc = get-service pangolinmanager) {
        stop-service -force -ea 0 $svc
        svc_rm $svc.name
    }
    if ($svc = get-service 'PangolinTunnel$olm') {
        stop-service -force -ea 0 $svc
        svc_rm $svc.name
    }
}

function main {
    if ($uninstall) {
        uninstall
    }
}
main
