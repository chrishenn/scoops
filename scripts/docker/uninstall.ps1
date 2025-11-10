function uninstall {
    write-host ''
    write-host ''
    Write-host -f yellow 'note: windows containers features will not be removed'
    if (get-service -name docker -ea 0) {
        [void](stop-service -name docker -ea 0)
    }
    if (get-process -name dockerd -ea 0) {
        [void](stop-process -name dockerd -ea 0)
    }
    dockerd --unregister-service
}

uninstall
