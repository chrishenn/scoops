param (
    [switch] $pre_install,
    [switch] $post_install
)

function pre_install {
    $ret = gcim Win32_PnPEntity | where-object {($_.pnpclass -eq 'processor') -and ($_.deviceid -like "ACPI\AUTHENTICAMD*")}
    if (-not $ret) {
        error \"No AMD CPU detected\"
        break
    }
}

function svc_rm ($name) {
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        remove-service -ea 0 $name
    } else {
        [void](sc.exe delete $name)
    }
}

function post_install {
    if ($svc = get-service -ea 0 "AMD Crash Defender Service") {
        stop-service -force -ea 0 $svc
        set-service $svc -startuptype Disabled -ea 0
        svc_rm $svc.name
    }

    write-host ''
    write-host ''
    write-host -f y 'amdchipset install: reboot required'
}

function main {
    if ($pre_install) {
        pre_install
    } elseif ($post_install) {
        post_install
    }
}
main
