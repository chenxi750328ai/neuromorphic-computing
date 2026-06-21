# Atlas 200DK RNDIS — 需管理员 + UAC 批准
$Log = Join-Path $env:TEMP "atlas-rndis-fix.log"
function Log($msg) {
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"
    Add-Content -Path $Log -Value $line -Encoding UTF8
    Write-Host $line
}

"" | Set-Content -Path $Log -Encoding UTF8
Log "=== Atlas RNDIS fix (elevated) ==="
Log "User: $([Security.Principal.WindowsIdentity]::GetCurrent().Name)"
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Log "IsAdmin: $admin"

$Inf = "$env:windir\inf\netrndis.inf"
if (Test-Path $Inf) {
    Log "pnputil add-driver netrndis.inf /install ..."
    pnputil /add-driver $Inf /install 2>&1 | ForEach-Object { Log $_ }
} else {
    Log "ERROR: missing $Inf"
}

Log "pnputil scan-devices ..."
pnputil /scan-devices 2>&1 | ForEach-Object { Log $_ }

$rndis = Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue
foreach ($d in $rndis) {
    Log "RNDIS device: $($d.InstanceId) Status=$($d.Status) Problem=$($d.Problem)"
    if ($d.Status -eq "Error" -or $d.Problem) {
        Log "  try restart-device ..."
        pnputil /restart-device $d.InstanceId 2>&1 | ForEach-Object { Log "  $_" }
        Start-Sleep -Seconds 2
        Log "  try enable-device ..."
        pnputil /enable-device $d.InstanceId 2>&1 | ForEach-Object { Log "  $_" }
    }
}

Start-Sleep -Seconds 2
Log "--- RNDIS after fix ---"
Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue |
    ForEach-Object { Log "  $($_.Status) Problem=$($_.Problem) ID=$($_.InstanceId)" }

Log "--- Net adapters ---"
Get-NetAdapter -ErrorAction SilentlyContinue |
    Where-Object { $_.InterfaceDescription -match "RNDIS|Remote NDIS|NDIS" -or $_.Name -match "RNDIS|Remote" } |
    ForEach-Object { Log "  $($_.Name) $($_.Status) $($_.InterfaceDescription) $($_.LinkSpeed)" }

if (-not (Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.InterfaceDescription -match "RNDIS|Remote NDIS" })) {
    Log "No RNDIS net adapter yet — may need Device Manager: Remote NDIS Compatible Device"
}

Log "--- Ping 192.168.1.2 ---"
ping.exe -n 3 192.168.1.2 2>&1 | ForEach-Object { Log $_ }

Log "=== Done. Log: $Log ==="
Start-Sleep -Seconds 3
