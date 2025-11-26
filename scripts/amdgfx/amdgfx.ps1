param (
    [switch] $post_install
)

function find_ustr ($name) {
    $keys = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    if ($chld = Get-childitem $keys | get-itemproperty | Where-Object {$_.DisplayName -match "$name"}) {
        return $chld.uninstallstring
    }
    return $null
}

function ustr ($name){
    if (! ($ustr = (find_ustr $name))) {
        write-host -f red "failed to find uninstall string for: $name"
        return $false
    }
    if (! ($ustr -match 'msiexec')) {
        write-host -f red "uninstall string is not msiexec for: $name"
        return $false
    }
    $ustr = $ustr.replace('msiexec.exe', '', 'OrdinalIgnoreCase')
    $ustr = $ustr.replace('msiexec', '', 'OrdinalIgnoreCase')
    $ustr += ' /quiet /qn'

    start-process msiexec -wait -NoNewWindow -a $ustr
    return $true
}

function svc_rm ($name) {
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        remove-service -ea 0 $name
    } else {
        [void](sc.exe delete $name)
    }
}

function post_install {
    write-host -f c "removing 'amd crash defender service'"
    if ($svc = get-service -ea 0 "AMD Crash Defender Service") {
        stop-service -force -ea 0 $svc
        set-service $svc -startuptype Disabled -ea 0
        svc_rm $svc.name
    }

    write-host -f c "removing 'amd install manager'"
    ustr 'amd install manager'

    write-host ''
    write-host ''
    write-host -f y 'amdgfx install: reboot required'
}

function main {
    if ($post_install) {
        post_install
    }
}
main
