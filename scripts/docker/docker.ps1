param (
    [switch] $install,
    [switch] $uninstall
)

function containers_client ($name) {
    write-host ''
    write-host ''
    $features = @("Containers", "microsoft-Hyper-V")
    $need_reboot = $false
    foreach ($feature in $features) {
        if ((Get-WindowsOptionalFeature -FeatureName $feature -Online).State -eq "Enabled") {
            Write-host -f cyan "Windows optional feature '$feature' is already enabled."
        } else {
            Write-host -f cyan "Windows optional feature '$feature' is not enabled. Enabling"
            DISM /Online /Enable-Feature /All /NoRestart /FeatureName:$feature
            $need_reboot = $true
        }
    }
    if ($need_reboot) {
        Write-host -F y "REBOOT REQUIRED TO ENABLE CONTAINER FEATURES"
    }
}

function scoop_docker {
    dockerd --register-service
    set-service docker -startuptype automatic -ea 0
    start-service docker -ea 0
    if (get-service -name docker -ea 0) {
        write-host -f green 'registered docker service'
    } else {
        write-host -f red 'failed to register docker service'
    }
}

function install {
    containers_client
    scoop_docker
}

function uninstall {
    write-host ''
    write-host ''
    Write-host -f y 'note: windows containers features will not be removed'
    if (get-service -name docker -ea 0) {
        [void](stop-service -name docker -ea 0)
    }
    if (get-process -name dockerd -ea 0) {
        [void](stop-process -name dockerd -ea 0)
        wait-process -name dockerd -ea 0
    }
    if (get-process -name docker -ea 0) {
        [void](stop-process -name docker -ea 0)
        wait-process -name docker -ea 0
        start-sleep 0.5
    }
    dockerd --unregister-service
}

function main {
    if ($install) {
        install
    } elseif ($uninstall) {
        uninstall
    }
}
main
