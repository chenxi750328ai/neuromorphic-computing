# Atlas RNDIS v4 — 重装 INF + 重启 USB 复合设备 + 配 IP
$Base = "C:\Users\chenx\AppData\Local\Temp"
$Log = Join-Path $Base "atlas-rndis-fix.log"
function Log($msg) {
    $line = "[$(Get-Date -Format 'HH:mm:ss')] $msg"
    Add-Content -Path $Log -Value $line -Encoding UTF8
    Write-Host $line
}

$Inf = Join-Path $Base "huawei-atlas-rndis.inf"
Log "=== v4 replug + RNDIS6 ==="

pnputil /add-driver $Inf /install 2>&1 | ForEach-Object { Log $_ }

$Devcon = Get-ChildItem "C:\Program Files\Oray\SunLogin\SunloginClient\driver" -Recurse -Filter devcon.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
$UsbId = "USB\VID_12D1&PID_107E\310B-1"

if ($Devcon) {
    Log "restart USB composite: $UsbId"
    & $Devcon restart $UsbId 2>&1 | ForEach-Object { Log $_ }
    Start-Sleep -Seconds 5
}

pnputil /scan-devices 2>&1 | ForEach-Object { Log $_ }
Start-Sleep -Seconds 5

$rndis = Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue
if (-not $rndis) {
    Log "WARN: no RNDIS node — 请拔插 Type-C 或给 Atlas 重新上电后重跑"
} else {
    $rndis | ForEach-Object { Log "RNDIS: $($_.Status) $($_.Problem) $($_.InstanceId)" }
    $err = $rndis | Where-Object { $_.Problem -eq "CM_PROB_FAILED_INSTALL" }
    foreach ($d in $err) {
        if ($Devcon) {
            Log "devcon update netrndis for $($d.InstanceId)"
            & $Devcon update 'C:\Windows\inf\netrndis.inf' 'USB\Class_02&SubClass_06&Prot_00' 2>&1 | ForEach-Object { Log $_ }
        }
    }
}

Start-Sleep -Seconds 3
Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue | ForEach-Object {
    Log "after: $($_.Status) $($_.Problem)"
}

$adapter = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object {
    $_.InterfaceDescription -match "RNDIS6|RNDIS 6|Remote NDIS|USB RNDIS|Huawei Atlas"
}
if ($adapter) {
    foreach ($a in $adapter) {
        Log "Adapter: $($a.Name) $($a.Status) $($a.InterfaceDescription)"
        if ($a.Status -eq "Disabled") { Enable-NetAdapter -Name $a.Name -Confirm:$false }
        Get-NetIPAddress -InterfaceIndex $a.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue |
            Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue
        New-NetIPAddress -InterfaceIndex $a.ifIndex -IPAddress 192.168.0.101 -PrefixLength 24 -ErrorAction SilentlyContinue | Out-Null
    }
} else {
    Log "No RNDIS adapter — 设备管理器手动: RNDIS -> USB RNDIS6 适配器"
}

Log "ping 192.168.0.2"
ping.exe -n 4 192.168.0.2 2>&1 | ForEach-Object { Log $_ }

$pingOk = Select-String -Path $Log -Pattern "TTL=" -Quiet
if ($pingOk) {
    Log "SSH probe..."
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o BatchMode=yes root@192.168.0.2 "hostname; uname -a; npu-smi info 2>/dev/null | head -8" 2>&1 | ForEach-Object { Log $_ }
}

Log "=== v4 done ==="
