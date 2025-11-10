function install {
    # instead of copying out the eula files, we can patch out the refs to them in the setup.cfg manifest

    $url = 'https://us.download.nvidia.com/Windows/581.80/581.80-desktop-win10-win11-64bit-international-dch-whql.exe'
    irm -useb $url -outfile driver.exe

    $dir = ".\nvdriver"
    $files = "Display.Driver NVI2 EULA.txt ListDevices.txt setup.cfg setup.exe"
    Start-Process 7z -wait -NoNewWindow -ArgumentList "x -bso0 -bsp1 -bse1 -aoa driver.exe $files -o$dir"

    $cfg = Get-Content "$dir\setup.cfg" | Where-Object {$_ -notmatch 'name=(.*)(EulaHtmlFile|FunctionalConsentFile|PrivacyPolicyFile)'}
    Set-Content "$dir\setup.cfg" "$cfg" -Encoding UTF8 -Force

    Start-Process -wait "$dir\setup.exe" -ArgumentList '-s -n -noeula -nofinish -clean'
}

function install_ref {
    # copy all the eula files from the nvapp package that's included in the driver installer package
    $dir = ".\nvdriver"
    $files = 'Display.Driver NVI2 setup.exe setup.cfg EULA.txt ListDevices.txt nvapp\FunctionalConsent* nvapp\PrivacyPolicy nvapp\Unified_EULA\*'
    Start-Process -wait 7z -ArgumentList "x -bso0 -bsp1 -bse1 -aoa driver.exe $files -o$dir"
    Start-Process -wait "$dir\setup.exe" -ArgumentList '-passive -noreboot -noeula -nofinish -s -clean'
}

function uninstall {
    $pkg = 'Display.Driver'
    $dll = 'C:\Program Files\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL'
    $argsl = """$dll"",UninstallPackage $pkg -silent -deviceinitiated"
    Start-Process RunDll32 -ArgumentList $argsl -Wait
}

function nvcontainer {
    # required for nvcontrol panel, but safe to disable and use nvapp instead
    svc_disable 'NVDisplay.ContainerLocalSystem'
}
