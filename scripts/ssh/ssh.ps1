param (
    [switch] $install,
    [switch] $uninstall
)

function install {
    mv $dir/OpenSSH-Win64 $dir/OpenSSH
    cp -r -force -ea 0 $dir/OpenSSH C:\Windows\System32\
    rm -r -force $dir/OpenSSH

    C:\Windows\System32\OpenSSH\install-sshd.ps1

    Set-Service ssh-agent -StartupType Disabled
    Set-Service sshd -StartupType Automatic
    Start-Service sshd

    git config --global core.sshCommand 'C:/Windows/System32/OpenSSH/ssh.exe'
    [Environment]::SetEnvironmentVariable('GIT_SSH', 'C:\Windows\System32\OpenSSH\ssh.exe', 'Machine')
}

function uninstall {
    stop-service -force sshd
    if (get-process -name sshd -ea 0) {
        stop-process -force -name sshd -ea 0
        wait-process -name sshd -ea 0
        start-sleep 0.5
    }
    C:\Windows\System32\OpenSSH\uninstall-sshd.ps1
}

function main {
    if ($install) {
        install
    } elseif ($uninstall) {
        uninstall
    }
}
main
