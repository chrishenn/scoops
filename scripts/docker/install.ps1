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
        Write-host -F yellow "REBOOT REQUIRED TO ENABLE CONTAINER FEATURES"
    }
}

function scoop_docker {
    dockerd --register-service
    set-service docker -startuptype automatic
    start-service docker -ea 0
    if (get-service -name docker -ea 0) {
        write-host -f green 'registered docker service'
    } else {
        write-host -f red 'failed to register docker service'
    }
}

containers_client
scoop_docker
