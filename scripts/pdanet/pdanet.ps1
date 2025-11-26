param (
    [switch] $install,
    [switch] $pre_uninstall,
    [switch] $uninstall
)

function interactive {
    $noni = [Environment]::GetCommandLineArgs() | Where-Object{ $_ -like '-NonI*' }
    return ([Environment]::UserInteractive -and -not $noni)
}

function install {
    write-host -f c 'NOTE: Install requires manual GUI interaction'
    if (-not (interactive)) {
        error 'error: pdanet must be installed from an interactive shell'
        return 0
    }
    $ars = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /CLOSEAPPLICATIONS /DIR=$dir"
    start-process "$dir\setup.exe" -a $ars
}

function pre_uninstall {
    if ($p = get-process pdanetpc -ea 0) {
        stop-process $p -force -ea 0
        wait-process -inputobject $p -ea 0
    }
}

function uninstall {
    if ($p = get-process pdanetpc -ea 0) {
        stop-process $p -force -ea 0
        wait-process -inputobject $p -ea 0
    }
    start-process -wait "$dir\unins000.exe" -a '/VERYSILENT /CLOSEAPPLICATIONS'
    rm -r -force -ea 0 "C:\Program Files (x86)\PdaNet for Android"
}

function main {
    if ($install) {
        install
    } elseif ($pre_uninstall) {
        pre_uninstall
    } elseif ($uninstall) {
        uninstall
    }
}
main
