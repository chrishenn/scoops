param (
    [switch] $install,
    [switch] $uninstall
)

function lnk_exe (
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][System.IO.FileInfo] $exe,
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $lnkdir
) {
    $ws = New-Object -comObject WScript.Shell
    $short = $ws.CreateShortcut("$lnkdir\$($exe.basename)" + ".lnk")
    $short.TargetPath = $exe.fullname
    $short.Save()
}

function lnk_portable (
    [Parameter(Mandatory = $true)][System.IO.DirectoryInfo] $appdir

) {
    $lnkdir = [System.Environment]::GetFolderPath("CommonStartMenu") + "\Programs\portable"
    [void](mkdir -force -ea 0 $lnkdir)

    $app_name = $appdir.basename
    $exes = Get-ChildItem $appdir -filter *.exe

    if ($exes.count -eq 1) {
        lnk_exe $exes $lnkdir
        return
    }
    foreach ($app_exe in $exes) {
        $srcn = $app_name.tolower()
        $namn = $app_exe.basename.tolower()
        if ($srcn.contains($namn) -or $namn.contains($srcn)) {
            lnk_exe $app_exe $lnkdir
            return
        }
    }

    $rexes = Get-ChildItem -recurse $appdir -filter *.exe
    foreach ($app_exe in $rexes) {
        $srcn = $app_name.tolower()
        $namn = $app_exe.basename.tolower()
        if ($srcn.contains($namn) -or $namn.contains($srcn)) {
            lnk_exe $app_exe $lnkdir
            return
        }
    }
    if ($rexes) {
        lnk_exe $rexes[0] $lnkdir
        return
    }

    write-host -f red "ERROR: no exe found for $appdir"
    return 1
}

function install {
    write-host ''
    foreach ($appdir in (Get-ChildItem $dir -Directory)) {
        write-host -f cyan "installing: $($appdir.name)"
        lnk_portable $appdir
    }
}

function uninstall {
    $lnkdir = [System.Environment]::GetFolderPath("CommonStartMenu") + "\Programs\portable"
    [void](rm -r -force -ea 0 $lnkdir)
}

function main {
    if ($install) {
        install
    } elseif ($uninstall) {
        uninstall
    }
}
main
