# 强制绑定 Microsoft USB RNDIS6（解决设备管理器 RNDIS 感叹号 / 错误 28）
$Base = "C:\Users\chenx\AppData\Local\Temp"
$Log = Join-Path $Base "atlas-rndis-fix.log"
function Log($msg) {
    $line = "[$(Get-Date -Format 'HH:mm:ss')] $msg"
    Add-Content -Path $Log -Value $line -Encoding UTF8
    Write-Host $line
}

Log "=== fix RNDIS exclamation (error 28) ==="
$Inf = "C:\Windows\inf\netrndis.inf"
if (-not (Test-Path $Inf)) { Log "ERROR: $Inf missing"; exit 1 }

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class NewDev {
    [DllImport("newdev.dll", CharSet=CharSet.Auto, SetLastError=true)]
    public static extern bool UpdateDriverForPlugAndPlayDevices(
        IntPtr hwndParent, string HardwareId, string FullInfPath,
        uint InstallFlags, out bool RebootRequired);
}
"@

$flags = 0x00000001 -bor 0x00000002  # force + readonly
$reboot = $false
$hwids = @(
    "USB\VID_12D1&PID_107E&MI_00",
    "USB\Class_02&SubClass_06&Prot_00",
    "USB\VID_12D1&PID_107E"
)
foreach ($hw in $hwids) {
    Log "UpdateDriverForPlugAndPlayDevices: $hw"
    $ok = [NewDev]::UpdateDriverForPlugAndPlayDevices([IntPtr]::Zero, $hw, $Inf, $flags, [ref]$reboot)
    Log "  result=$ok reboot=$reboot lastError=$([Runtime.InteropServices.Marshal]::GetLastWin32Error())"
}

Start-Sleep -Seconds 3
Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue | ForEach-Object {
    Log "RNDIS: $($_.Status) code=$($_.ConfigManagerErrorCode) $($_.InstanceId)"
}

$Devcon = Get-ChildItem "C:\Program Files\Oray\SunLogin\SunloginClient\driver" -Recurse -Filter devcon.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
$stillErr = Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue | Where-Object { $_.ConfigManagerErrorCode -eq 28 }
if ($stillErr -and $Devcon) {
    $id = $stillErr.InstanceId
    Log "devcon remove + rescan: $id"
    & $Devcon remove "@$id" 2>&1 | ForEach-Object { Log $_ }
    Start-Sleep -Seconds 3
    & $Devcon rescan 2>&1 | ForEach-Object { Log $_ }
    Start-Sleep -Seconds 5
    foreach ($hw in $hwids) {
        Log "devcon update after rescan: $hw"
        & $Devcon update $Inf "@$hw" 2>&1 | ForEach-Object { Log $_ }
    }
}

Start-Sleep -Seconds 2
Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue | ForEach-Object {
    Log "final RNDIS: $($_.Status) code=$($_.ConfigManagerErrorCode)"
}

$adapters = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object {
    $_.InterfaceDescription -match 'RNDIS6|RNDIS 6|Remote NDIS|USB RNDIS'
}
if ($adapters) {
    foreach ($a in $adapters) {
        Log "Adapter OK: $($a.Name) $($a.InterfaceDescription) $($a.Status)"
        if ($a.Status -eq 'Disabled') { Enable-NetAdapter -Name $a.Name -Confirm:$false }
        Get-NetIPAddress -InterfaceIndex $a.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue |
            Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue
        New-NetIPAddress -InterfaceIndex $a.ifIndex -IPAddress 192.168.0.101 -PrefixLength 24 -ErrorAction SilentlyContinue | Out-Null
    }
    Log "ping 192.168.0.2"
    ping.exe -n 3 192.168.0.2 2>&1 | ForEach-Object { Log $_ }
} else {
    Log "仍无网卡 — 请按文档手动: 取消「显示兼容硬件」-> Microsoft -> USB RNDIS6 适配器"
    Log "INF 路径: $Inf"
}

Log "=== done ==="
