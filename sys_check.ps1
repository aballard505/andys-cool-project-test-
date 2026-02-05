Write-Host "===============================================" -ForegroundColor Gray
Write-Host "REPORT GENERATED: $(Get-Date -Format 'MMMM dd, yyyy | HH:mm:ss')" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Gray

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

Write-Host "`n--- NETWORK HEALTH ---" -ForegroundColor Yellow

# 1. Check Local IP
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" }).IPAddress[0]
Write-Host "Local IP Address: $localIP"

# 2. Test Connection to Google (Ping)
Write-Host "Testing Internet Connection..." -NoNewline
if (Test-Connection -ComputerName google.com -Count 1 -Quiet) {
    Write-Host " [ONLINE]" -ForegroundColor Green
} else {
    Write-Host " [OFFLINE]" -ForegroundColor Red
}

# 3. Check WiFi Name (SSID)
$wifi = (netsh wlan show interfaces | Select-String "SSID" | Select-Object -First 1).ToString().Split(":")[1].Trim()
if ($wifi) { Write-Host "Connected to: $wifi" }


