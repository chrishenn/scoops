function uninstall {
    if (get-process -force -name sshd -ea 0) {
        stop-process -force -name sshd -ea 0
    }
    stop-service -force sshd
    C:\Windows\System32\OpenSSH\uninstall-sshd.ps1
}
uninstall
