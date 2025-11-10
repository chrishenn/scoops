function stop {
    foreach ($exe in (get-childitem $dir -filter *.exe)) {
        if (get-process -name $exe.basename -ea 0) {
            stop-process -name $exe.basename -ea 0
        }
    }
}
stop
