# Atlas RNDIS v2 — devcon force bind netrndis.inf
$Log = Join-Path $env:TEMP "atlas-rndis-fix.log"
function Log($msg) {
    $line = "[$(Get-Date -Format 'HH:mm:ss')] $msg"
    Add-Content -Path $Log -Value $line -Encoding UTF8
    Write-Host $line
}

Log "=== v2 devcon bind ==="
$Devcon = Get-ChildItem "C:\Program Files\Oray\SunLogin\SunloginClient\driver" -Recurse -Filter devcon.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
$Inf = "$env:windir\inf\netrndis.inf"
$Hwid = "USB\Class_02&SubClass_06&Prot_00"

if (-not $Devcon) { Log "ERROR: devcon.exe not found"; exit 1 }
Log "Devcon: $Devcon"
Log "Inf: $Inf"

Log "--- devcon find 12D1 ---"
& $Devcon find *12D1* 2>&1 | ForEach-Object { Log $_ }
Log "--- devcon find RNDIS ---"
& $Devcon find *RNDIS* 2>&1 | ForEach-Object { Log $_ }

Log "--- devcon update netrndis ---"
& $Devcon update $Inf $Hwid 2>&1 | ForEach-Object { Log $_ }

Start-Sleep -Seconds 3
$stillBad = Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue | Where-Object { $_.Problem -eq "CM_PROB_FAILED_INSTALL" }
if ($stillBad) {
    Log "--- still failed; remove + rescan + update ---"
    & $Devcon remove $Hwid 2>&1 | ForEach-Object { Log $_ }
    Start-Sleep -Seconds 2
    & $Devcon rescan 2>&1 | ForEach-Object { Log $_ }
    Start-Sleep -Seconds 3
    & $Devcon update $Inf $Hwid 2>&1 | ForEach-Object { Log $_ }
}

Start-Sleep -Seconds 2
Log "--- RNDIS status ---"
Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue | ForEach-Object {
    Log "$($_.Status) $($_.Problem) $($_.InstanceId)"
}
Log "--- Net adapters (RNDIS) ---"
Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.InterfaceDescription -match "RNDIS|Remote NDIS" } | ForEach-Object {
    Log "$($_.Name) $($_.Status) $($_.InterfaceDescription)"
    if ($_.Status -eq "Up") {
        Get-NetIPAddress -InterfaceIndex $_.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue | ForEach-Object { Log "  IP: $($_.IPAddress)" }
    }
}
Log "--- ping ---"
ping.exe -n 3 192.168.1.2 2>&1 | ForEach-Object { Log $_ }
Log "=== v2 done ==="
Start-Sleep -Seconds 4
