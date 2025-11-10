function uninstall {
    $pkg = 'Display.NvApp'
    $dll = 'C:\Program Files\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL'
    $argsl = """$dll"",UninstallPackage $pkg -silent -deviceinitiated"
    Start-Process RunDll32 -ArgumentList $argsl -Wait
    rm -r -force 'C:\\program files\\NVIDIA Corporation\\NVIDIA App'
}
