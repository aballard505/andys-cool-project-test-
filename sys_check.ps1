# Get System Info
$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$battery = Get-CimInstance Win32_Battery
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

Write-Host "--- ?? SYSTEM REPORT ---" -ForegroundColor Cyan
Write-Host "PC Name: $($os.CSName)"
Write-Host "OS: $($os.Caption)"
Write-Host "Processor: $($cpu.Name)"
Write-Host ""

Write-Host "--- ?? BATTERY HEALTH ---" -ForegroundColor Green
if ($battery) {
    Write-Host "Status: $($battery.Status)"
    Write-Host "Charge Remaining: $($battery.EstimatedChargeRemaining)%"
    Write-Host "Estimated Life: $($battery.EstimatedRunTime) minutes"
} else {
    Write-Host "No battery detected (Desktop Mode)"
}
Write-Host ""

Write-Host "--- ?? STORAGE CHECK (C:) ---" -ForegroundColor Yellow
$freeGB = [Math]::Round($disk.FreeSpace / 1GB, 2)
$totalGB = [Math]::Round($disk.Size / 1GB, 2)
Write-Host "Free Space: $freeGB GB / $totalGB GB"
Write-Host "-----------------------"
