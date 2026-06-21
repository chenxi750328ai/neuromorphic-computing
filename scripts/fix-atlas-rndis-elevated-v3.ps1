# Atlas 200I DK A2 — 昇腾官方流程：RNDIS6 + 192.168.0.x
$Base = "C:\Users\chenx\AppData\Local\Temp"
$Log = Join-Path $Base "atlas-rndis-fix.log"
function Log($msg) {
    $line = "[$(Get-Date -Format 'HH:mm:ss')] $msg"
    Add-Content -Path $Log -Value $line -Encoding UTF8
    Write-Host $line
}

$Inf = Join-Path $Base "huawei-atlas-rndis.inf"
Log "=== v3 Atlas RNDIS6 (hiascend official) ==="
Log "Admin: $(([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))"

if (-not (Test-Path $Inf)) {
    Log "ERROR: missing $Inf"
    exit 1
}

# 移除失败实例后重装
$bad = Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue | Where-Object { $_.Problem -eq "CM_PROB_FAILED_INSTALL" }
foreach ($d in $bad) {
    Log "remove failed RNDIS: $($d.InstanceId)"
    pnputil /remove-device $d.InstanceId /force 2>&1 | ForEach-Object { Log $_ }
}
Start-Sleep -Seconds 2

Log "pnputil add-driver $Inf /install"
pnputil /add-driver $Inf /install 2>&1 | ForEach-Object { Log $_ }
Start-Sleep -Seconds 1
Log "pnputil scan-devices"
pnputil /scan-devices 2>&1 | ForEach-Object { Log $_ }
Start-Sleep -Seconds 4

Log "--- RNDIS PnP ---"
Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue | ForEach-Object {
    Log "$($_.Status) $($_.Problem) $($_.InstanceId)"
}

$adapter = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object {
    $_.InterfaceDescription -match "RNDIS6|RNDIS 6|Remote NDIS|USB RNDIS" -or $_.Name -match "RNDIS|本地连接"
} | Where-Object { $_.InterfaceDescription -notmatch "Hyper-V|WSL" } | Select-Object -First 1

if (-not $adapter) {
    # Win11 可能显示为「以太网 N」
    $adapter = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object {
        $_.Status -eq "Up" -or $_.Status -eq "Disconnected"
    } | Where-Object {
        $n = $_.InterfaceDescription
        $n -match "RNDIS|Remote NDIS|USB" -and $n -notmatch "Wi-Fi|Wireless|Hyper"
    } | Select-Object -First 1
}

if ($adapter) {
    Log "Net adapter: $($adapter.Name) [$($adapter.InterfaceDescription)] Status=$($adapter.Status)"
    if ($adapter.Status -eq "Disabled") {
        Enable-NetAdapter -Name $adapter.Name -Confirm:$false
        Start-Sleep -Seconds 2
    }
    # 清除旧 IP，设 192.168.0.101（官方示例）
    Get-NetIPAddress -InterfaceIndex $adapter.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue |
        ForEach-Object { Remove-NetIPAddress -InterfaceIndex $_.InterfaceIndex -Confirm:$false -ErrorAction SilentlyContinue }
    New-NetIPAddress -InterfaceIndex $adapter.ifIndex -IPAddress 192.168.0.101 -PrefixLength 24 -ErrorAction SilentlyContinue 2>&1 | ForEach-Object { Log $_ }
    Log "ipconfig for $($adapter.Name):"
    ipconfig 2>&1 | Select-String -Pattern "192\.168\.0|RNDIS|本地连接|以太网" -Context 0,4 | ForEach-Object { Log $_.Line; $_.Context.PostContext | ForEach-Object { Log $_ } }
} else {
    Log "WARN: no RNDIS net adapter found — driver may still need Device Manager manual pick (USB RNDIS6)"
}

Log "--- ping 192.168.0.2 (Atlas Type-C default) ---"
ping.exe -n 4 192.168.0.2 2>&1 | ForEach-Object { Log $_ }

if ($LASTEXITCODE -eq 0 -or (Select-String -InputObject (Get-Content $Log -Tail 8 -Raw) -Pattern "TTL=" -Quiet)) {
    Log "--- ssh probe root@192.168.0.2 ---"
    $ssh = Get-Command ssh -ErrorAction SilentlyContinue
    if ($ssh) {
        echo y | ssh -o StrictHostKeyChecking=no -o ConnectTimeout=8 -o BatchMode=yes root@192.168.0.2 "hostname; npu-smi info 2>/dev/null | head -5 || echo npu-smi-missing" 2>&1 | ForEach-Object { Log $_ }
    } else {
        Log "ssh client not in PATH"
    }
}

Log "=== v3 done ==="
Start-Sleep -Seconds 3
