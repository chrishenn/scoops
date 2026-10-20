param (
    [switch] $pre_install,
    [switch] $post_install
)

function pre_install {
    $ret = gcim Win32_PnPEntity | where-object {($_.pnpclass -eq 'processor') -and ($_.deviceid -like "ACPI\AUTHENTICAMD*")}
    if (-not $ret) {
        error "No AMD CPU detected"
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

    #  https://www.neowin.net/news/amd-makes-cpu-changing-easy-as-you-wont-need-to-reinstall-windows-1110-any-more/
    # ... a whitelist of [programs] that do not work properly with .. PPKG and AMD's 3D V-cache performance optimizer.
    # [it] ... works by reducing the thread pool size.
    #   Deus Ex: Mankind Divided, Dying Light 2, Far Cry 6, Metro Exodus and the Enhanced Edition,
    #   Total War: Three Kingdoms, Total War: Warhammer III, and Wolfenstein: Youngblood.
#    if ($svc = get-service -ea 0 "AMD Application Compatibility Database") {
#        stop-service -force -ea 0 $svc
#        set-service $svc -startuptype Disabled -ea 0
#        svc_rm $svc.name
#    }

    # todo: this is for discrete AMD gpus, so we need a chplib/hardware/hw_amdgpu detection method
    if ($svc = get-service -ea 0 "AMD External Events Utility") {
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
