# 清理冲突 RNDIS 节点 + 依次尝试 Remote NDIS / RNDIS6
$Base = "C:\Users\chenx\AppData\Local\Temp"
$Log = Join-Path $Base "atlas-rndis-fix.log"
function Log($msg) {
    $line = "[$(Get-Date -Format 'HH:mm:ss')] $msg"
    Add-Content -Path $Log -Value $line -Encoding UTF8
    Write-Host $line
}

$Inf = "C:\Windows\inf\netrndis.inf"
$Devcon = Get-ChildItem "C:\Program Files\Oray\SunLogin\SunloginClient\driver" -Recurse -Filter devcon.exe -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName

Log "=== cleanup + retry RNDIS drivers ==="

# 1. 卸载所有 RNDIS / 18990560 相关节点（含幽灵 USB RNDIS6）
$targets = @(
    "USB\VID_12D1&PID_107E&MI_00\6&18990560&2&0000",
    "USB\CLASS_02&SUBCLASS_06&PROT_00\6&18990560&2&0000",
    "USB\CLASS_02&SUBCLASS_06&PROT_00\6&18990560&1&0000"
)
foreach ($id in $targets) {
    Log "pnputil remove: $id"
    pnputil /remove-device $id /force 2>&1 | ForEach-Object { Log $_ }
}
Get-PnpDevice -Class Net -ErrorAction SilentlyContinue |
    Where-Object { $_.FriendlyName -match 'RNDIS' -and $_.Status -ne 'OK' } |
    ForEach-Object {
        Log "remove net phantom: $($_.InstanceId)"
        pnputil /remove-device $_.InstanceId /force 2>&1 | ForEach-Object { Log $_ }
    }

Start-Sleep -Seconds 2
if ($Devcon) { & $Devcon rescan 2>&1 | ForEach-Object { Log $_ } }
pnputil /scan-devices 2>&1 | ForEach-Object { Log $_ }
Start-Sleep -Seconds 6

Add-Type @"
using System; using System.Runtime.InteropServices;
public class NewDev {
  [DllImport("newdev.dll", CharSet=CharSet.Auto, SetLastError=true)]
  public static extern bool UpdateDriverForPlugAndPlayDevices(
    IntPtr h, string HardwareId, string InfPath, uint Flags, out bool Reboot);
}
"@

$hw = "USB\VID_12D1&PID_107E&MI_00"
$reboot = $false
# 先试 Remote NDIS Compatible Device (ms_rndisusb) — Win11 对部分 Huawei 更兼容
Log "try UpdateDriver: $hw"
$ok = [NewDev]::UpdateDriverForPlugAndPlayDevices([IntPtr]::Zero, $hw, $Inf, 3, [ref]$reboot)
Log "  ok=$ok err=$([Runtime.InteropServices.Marshal]::GetLastWin32Error()) reboot=$reboot"

Start-Sleep -Seconds 3
$r = Get-PnpDevice -FriendlyName "RNDIS" -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Error" }
if ($r) {
    Log "still error — try Class_02 hwid"
    $ok2 = [NewDev]::UpdateDriverForPlugAndPlayDevices([IntPtr]::Zero, "USB\Class_02&SubClass_06&Prot_00", $Inf, 3, [ref]$reboot)
    Log "  ok=$ok2 err=$([Runtime.InteropServices.Marshal]::GetLastWin32Error())"
}

Start-Sleep -Seconds 2
Log "--- status ---"
Get-PnpDevice | Where-Object { $_.FriendlyName -match 'RNDIS' } | ForEach-Object {
    Log "$($_.Class) | $($_.Status) | code=$($_.ConfigManagerErrorCode) | $($_.FriendlyName)"
}
Get-NetAdapter -IncludeHidden -ErrorAction SilentlyContinue |
    Where-Object { $_.InterfaceDescription -match 'RNDIS|Remote NDIS|Gadget' } |
    ForEach-Object { Log "NetAdapter: $($_.Name) $($_.Status) $($_.InterfaceDescription)" }

$na = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.InterfaceDescription -match 'RNDIS|Remote NDIS|Gadget' } | Select-Object -First 1
if ($na) {
    Remove-NetIPAddress -InterfaceIndex $na.ifIndex -Confirm:$false -ErrorAction SilentlyContinue
    New-NetIPAddress -InterfaceIndex $na.ifIndex -IPAddress 192.168.0.101 -PrefixLength 24 -ErrorAction SilentlyContinue | Out-Null
    ping.exe -n 2 192.168.0.2 2>&1 | ForEach-Object { Log $_ }
} else {
    Log "仍失败 — 建议改 RJ45 网线连 Atlas eth 口，或 Windows 更新 -> 可选更新 搜 RNDIS"
}
Log "=== cleanup done ==="
