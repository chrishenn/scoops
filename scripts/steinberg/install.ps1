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
        start-process "$dir\$instdir\setup.exe" -wait -NoNewWindow -ArgumentList '/i /quiet /passive /S /qn /silent'
    }
}

install
