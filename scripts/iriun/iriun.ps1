param (
    [switch] $install,
    [switch] $uninstall
)

function install {
    if (-not (is_admin)) {
        error "$app requires admin rights to install"
        break
    }
    Start-Process -wait "$dir\setup.exe" -a "/verysilent /dir=$dir"
    rm "$dir\setup.exe"
}

function uninstall {
    if (-not (is_admin)) {
        error "$app requires admin rights to uninstall"
        break
    }
    start-process -wait "$dir\unins000.exe" -a '/verysilent'

    $dstore = 'C:\windows\system32\driverstore\filerepository'
    $dirs = gci -directory $dstore | ? {$_.name -like "iriun*"}
    foreach ($dir in $dirs) {
        pnputil /delete-driver $dir.fullname /uninstall
    }
}


function main {
    if ($install) {
        install
    } elseif ($uninstall) {
        uninstall
    }
}
main
