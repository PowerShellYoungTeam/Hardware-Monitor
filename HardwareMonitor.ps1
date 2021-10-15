Import-Module Graphical

$CPUData = [int[]]::new(60); $CPUData.length
$MemoryData = [int[]]::new(60); $MemoryData.length
$DiskData = [int[]]::new(60); $DiskData.length
$NICData = [int[]]::new(60); $NICData.length


$LaunchTime = (Get-date)
$i = $LaunchTime.Minute

Do{
    $CPULoad = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    $MemoryLoad = (Get-CIMInstance Win32_OperatingSystem )
    $MemoryLoad = ($MemoryLoad.FreePhysicalMemory) / ($MemoryLoad.TotalVisibleMemorySize ) * 100
    $MemoryLoad =
    $DiskTime = (Get-Counter '\physicaldisk(_total)\% disk time').CounterSamples.CookedValue
    $NICTime = (Get-Counter '\network interface(intel[r] ethernet connection i219-lm)\bytes total/sec').CounterSamples.CookedValue

    if($i -gt 59){
        $CPUData = [int[]]::new(60); $CPUData.length
        $MemoryData = [int[]]::new(60); $MemoryData.length
        $DiskData = [int[]]::new(60); $DiskData.length
        $NICData = [int[]]::new(60); $NICData.length
        $i = 0
    }
    $CPUData[$i] += [int]$CPULoad
    $MemoryData[$i] += [int]$MemoryLoad
    $DiskData[$i] += [int]$DiskTime
    $NICData[$i] += [int]$NICTime
    $i++
    clear-host
    Write-host "##### Performance Monitor ######"
    Write-host "Time started: $($LaunchTime)"
    Write-host ""
    Show-Graph -Datapoints $CPUData -GraphTitle "CPU Usage %" -type Bar -XAxisTitle "Time (min)"  -YAxisTitle "%"
    Show-Graph -Datapoints $MemoryData -GraphTitle "Physical Memory Free %" -type Bar -XAxisTitle "Time (min)"  -YAxisTitle "%"
    Show-Graph -Datapoints $DiskData -GraphTitle "Disk Usage %" -type Bar -XAxisTitle "Time (min)"  -YAxisTitle "%"
    Show-Graph -Datapoints $NICData -GraphTitle "LAN Traffic Bytes per Sec" -type Bar -XAxisTitle "Time (min)" -YAxisStep 100000
    Start-Sleep -Seconds 60
}While($true)
