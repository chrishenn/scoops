function uninstall {
    $lnkdir = [System.Environment]::GetFolderPath("CommonStartMenu") + "\Programs\portable"
    [void](rm -r -force -ea 0 $lnkdir)
}
uninstall
