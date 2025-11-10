function uninstall {
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
    foreach ($exe in (get-childitem $dir -filter *.exe)) {
        remove-itemproperty $key $exe.basename
    }
}
uninstall
