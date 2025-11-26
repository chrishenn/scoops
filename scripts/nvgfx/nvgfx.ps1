param (
    [switch] $pre_install,
    [switch] $post_install,
    [switch] $uninstall
)

function pre_install {
    $files = 'Display.Driver NVI2 EULA.txt ListDevices.txt setup.cfg setup.exe'
    Start-Process 7z -wait -NoNewWindow -a "x -bso0 -bsp1 -bse1 -aoa $dir\dl.7z_ $files -o$dir"
    $cfg = Get-Content "$dir\setup.cfg" | Where-Object {$_ -notmatch 'name=(.*)(EulaHtmlFile|FunctionalConsentFile|PrivacyPolicyFile)'}
    Set-Content "$dir\setup.cfg" "$cfg" -Encoding UTF8 -Force
}

function svc_rm ($name) {
    if ($PSVersionTable.PSVersion.Major -gt 5) {
        remove-service -ea 0 $name
    } else {
        [void](sc.exe delete $name)
    }
}

function rm_nvcpl {
    write-host -f c 'Uninstalling nvidia control panel'
    if ($cp = get-appxpackage NVIDIACorp.NVIDIAControlPanel) {
        remove-appxpackage $cp
    }
}

function rm_nvlocalsys {
    write-host -f c 'Removing ContainerLocalSystem service'
    if ($svc = get-service NVDisplay.ContainerLocalSystem -ea 0) {
        stop-service -force -ea 0 $svc
        set-service $svc -startuptype Disabled -ea 0
        svc_rm $svc.name
    }
}

function post_install {
    write-host ''
    write-host ''
    & "$bucketsdir\chris\scripts\nvidia\tray_hide.ps1"

    # write-host ''
    # write-host -f cyan 'To hide the nvidia tray icon, run:'
    # write-host -f cyan "$bucketsdir\chris\scripts\nvidia\tray_hide.ps1"
    # write-host ''
    # write-host -f cyan 'To unhide the nvidia tray icon, run:'
    # write-host -f cyan "$bucketsdir\chris\scripts\nvidia\tray_unhide.ps1"
    # write-host ''
}

function uninstall {
    # if we're upgrading, we can run the installer without first uninstalling
    # uninstalling would necessitate a reboot before we can install again
    if ($cmd -ne 'uninstall') {
        return
    }

    $pkg = 'Display.Driver'
    $dll = 'C:\Program Files\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL'
    $argsl = """$dll"",UninstallPackage $pkg -silent -deviceinitiated"
    Start-Process RunDll32 -wait -a $argsl

    write-host ''
    write-host ''
    write-host -f yellow 'Note: A reboot is required before installing a graphics driver'
    write-host ''
}

function main {
    if ($pre_install) {
        pre_install
    } elseif ($post_install) {
        post_install
    } elseif ($uninstall) {
        uninstall
    }
}
main
