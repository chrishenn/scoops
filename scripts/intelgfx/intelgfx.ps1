param (
    [switch] $post_install,
    [switch] $pre_uninstall
)

function svc_rm ($name) {
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        remove-service -ea 0 $name
    } else {
        [void](sc.exe delete $name)
    }
}

function debloat {
    stop-service -force -ea 0 'cplspcon'
    svc_rm 'cplspcon'

    stop-service -force -ea 0 'dsaservice'
    svc_rm 'dsaservice'

    stop-service -force -ea 0 'dsaupdateservice'
    svc_rm 'dsaupdateservice'

    stop-service -force -ea 0 'igccservice'
    set-service -ea 0 'igccservice' -startuptype manual

    start-process -wait "$dir\resources\extras\intel-driver-and-support-assistant-installer.exe" -a '/uninstall /quiet /norestart'
}

function post_install {
    debloat

    write-host ''
    write-host ''
    write-host -f y 'to complete intelgfx install, you must reboot'
}

function pre_uninstall {
    debloat
}

function main {
    if ($post_install) {
        post_install
    } elseif ($pre_uninstall) {
        pre_uninstall
    }
}
main
