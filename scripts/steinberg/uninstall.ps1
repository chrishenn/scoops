function find_ustr ($name) {
    $key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    $chld = Get-childitem $key | get-itemproperty | Where-Object { $_.DisplayName -match "$name" }
    if ($chld) {
        return $chld.uninstallstring
    }
    return $null
}

function ustr ($name){
    # uninstall with msiexec via registry uninstall string
    if (! ($ustr = (find_ustr $name))) {
        write-host -f red "failed to find uninstall string for: $name"
        return 1
    }
    if (! ($ustr -match 'msiexec')) {
        write-host -f red "uninstall string is not msiexec for: $name"
        return 1
    }
    $ustr = $ustr.replace('msiexec.exe', '', 'OrdinalIgnoreCase')
    $ustr = $ustr.replace('msiexec', '', 'OrdinalIgnoreCase')
    $ustr += ' /quiet'
    echo "uninstalling with msiexec and: $ustr"
    start-process msiexec -wait -NoNewWindow -argumentlist $ustr
}

ustr 'steinberg'
