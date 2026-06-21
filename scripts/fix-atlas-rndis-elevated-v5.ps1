# v5 — 恢复 RNDIS 枚举 + 打开设备管理器（手动选 USB RNDIS6）
$Base = "C:\Users\chenx\AppData\Local\Temp"
$Log = Join-Path $Base "atlas-rndis-fix.log"
function Log($msg) {
    $line = "[$(Get-Date -Format 'HH:mm:ss')] $msg"
    Add-Content -Path $Log -Value $line -Encoding UTF8
    Write-Host $line
}

$Devcon = Get-ChildItem "C:\Program Files\Oray\SunLogin\SunloginClient\driver" -Recurse -Filter devcon.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
Log "=== v5 enumerate RNDIS ==="

if ($Devcon) {
    Log "devcon find *12D1*"
    & $Devcon find '*12D1*' 2>&1 | ForEach-Object { Log $_ }
    Log "devcon find *107E*"
    & $Devcon find '*107E*' 2>&1 | ForEach-Object { Log $_ }
    Log "devcon rescan"
    & $Devcon rescan 2>&1 | ForEach-Object { Log $_ }
    Start-Sleep -Seconds 6
}

pnputil /scan-devices 2>&1 | ForEach-Object { Log $_ }
Start-Sleep -Seconds 4

$rndis = @(Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue)
if ($rndis.Count -eq 0) {
    Log "NO RNDIS — 请确认: Atlas 已上电+SD卡 | Type-C 数据线 | 拔插 USB 一次"
} else {
    foreach ($d in $rndis) {
        Log "RNDIS $($d.Status) $($d.Problem) $($d.InstanceId)"
    }
}

# 若 RNDIS 存在且失败：用微软已签名 netrndis 强制 update（非自定义 inf）
if ($Devcon -and ($rndis | Where-Object { $_.Status -ne 'OK' })) {
    Log "devcon update netrndis (signed Microsoft)"
    & $Devcon update 'C:\Windows\inf\netrndis.inf' '@USB\Class_02&SubClass_06&Prot_00' 2>&1 | ForEach-Object { Log $_ }
    Start-Sleep -Seconds 3
}

Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue | ForEach-Object {
    Log "after: $($_.Status) $($_.Problem)"
}

$adapters = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object {
    $_.InterfaceDescription -match 'RNDIS6|RNDIS 6|Remote NDIS|USB RNDIS'
}
foreach ($a in $adapters) {
    Log "Adapter $($a.Name) $($a.Status)"
    if ($a.Status -eq 'Disabled') { Enable-NetAdapter -Name $a.Name -Confirm:$false }
    Remove-NetIPAddress -InterfaceIndex $a.ifIndex -Confirm:$false -ErrorAction SilentlyContinue
    New-NetIPAddress -InterfaceIndex $a.ifIndex -IPAddress 192.168.0.101 -PrefixLength 24 -ErrorAction SilentlyContinue | Out-Null
}

if (-not $adapters) {
    Log "打开设备管理器 — 请手动: RNDIS -> 更新驱动 -> USB RNDIS6 适配器 (Microsoft)"
    Start-Process devmgmt.msc
}

Log "ping 192.168.0.2"
ping.exe -n 3 192.168.0.2 2>&1 | ForEach-Object { Log $_ }
if (Select-String -Path $Log -Pattern 'TTL=' -Quiet) {
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -o BatchMode=yes root@192.168.0.2 "hostname; npu-smi info 2>/dev/null | head -6" 2>&1 | ForEach-Object { Log $_ }
}
Log "=== v5 done ==="
