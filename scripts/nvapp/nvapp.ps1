param (
    [switch] $post_install,
    [switch] $uninstall
)

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
    $pkg = 'Display.NvApp'
    $dll = 'C:\Program Files\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL'
    $argsl = """$dll"",UninstallPackage $pkg -silent"
    Start-Process RunDll32 -wait -a $argsl

    # assuming that only the nvapp relies on the frameviewsdk
    $pkg = 'FrameViewSdk'
    $dll = 'C:\Program Files\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL'
    $argsl = """$dll"",UninstallPackage $pkg -silent"
    Start-Process RunDll32 -wait -a $argsl
}

function main {
    if ($post_install) {
        post_install
    } elseif ($uninstall) {
        uninstall
    }
}
main
