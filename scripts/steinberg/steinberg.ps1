param (
    [switch] $install,
    [switch] $uninstall
)

function reg_app (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $name
) {
    $apps = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $apps += Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    return ($apps | Where-Object {$_.displayname -match "$name"} | measure).count -gt 0
}

function install {
    if (-not (reg_app 'steinberg')) {
        $instdir = $fname.split('.')[0]
        start-process "$dir\$instdir\setup.exe" -wait -NoNewWindow -a '/i /quiet /passive /S /qn /silent'
    }
}

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

    start-process msiexec -wait -NoNewWindow -a $ustr
}

function uninstall {
    ustr 'steinberg'
}

function main {
    if ($install) {
        install
    } elseif ($uninstall) {
        uninstall
    }
}
main


