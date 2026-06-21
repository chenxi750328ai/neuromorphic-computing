# Fix PL2303 "PHASED OUT" — run as Administrator
# Tries: (1) legacy Prolific 3.3.2.102 INF  (2) rollback to usbser.sys
$ErrorActionPreference = 'Stop'
$Log = "$env:TEMP\pl2303-fix.log"
function Log($m) { $line = "$(Get-Date -Format 'HH:mm:ss') $m"; Add-Content $Log $line; Write-Host $line }

Log '=== PL2303 driver fix start ==='
$inst = 'USB\VID_067B&PID_2303\5&4491077&0&5'
$dev = Get-PnpDevice -InstanceId $inst -ErrorAction SilentlyContinue
if (-not $dev) {
    $dev = Get-PnpDevice | Where-Object { $_.InstanceId -match 'VID_067B&PID_2303' } | Select-Object -First 1
    $inst = $dev.InstanceId
}
if (-not $dev) { Log 'ERROR: PL2303 device not found'; exit 1 }
Log "Device: $($dev.FriendlyName) [$inst]"

$work = 'C:\Users\chenx\Desktop\pl2303_driver'
New-Item -ItemType Directory -Force -Path $work | Out-Null

# Download legacy driver pack (3.3.2.102) if missing
$zip = Join-Path $work 'PL2303_64bit_Installer_v3.3.2.102.zip'
$infDir = Join-Path $work 'extracted'
if (-not (Test-Path (Join-Path $infDir 'ser2pl.inf'))) {
    Log 'Downloading legacy Prolific 3.3.2.102...'
    $urls = @(
        'https://github.com/semklim/PL2303-USB-Driver-Windows-10-11/releases/download/v1.0.0/PL2303_Prolific_DriverInstaller_v1_23.zip',
        'https://raw.githubusercontent.com/rubengr/PL2303HXA-Phased-Out/main/IO-Cable_PL-2303_Drivers-Generic_Windows_PL2303_Prolific.zip'
    )
    $ok = $false
    foreach ($u in $urls) {
        try {
            Invoke-WebRequest -Uri $u -OutFile $zip -UseBasicParsing -TimeoutSec 120
            Expand-Archive -Path $zip -DestinationPath $infDir -Force
            $ok = $true
            Log "Downloaded from $u"
            break
        } catch { Log "Download failed: $u — $($_.Exception.Message)" }
    }
    if (-not $ok) { Log 'WARN: could not download legacy pack; will try usbser only' }
}

# Find ser2pl.inf in extracted tree
$legacyInf = Get-ChildItem -Path $infDir -Recurse -Filter 'ser2pl.inf' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($legacyInf) {
    Log "Found legacy INF: $($legacyInf.FullName)"
    pnputil /add-driver $legacyInf.FullName /install 2>&1 | ForEach-Object { Log $_ }
}

function Test-ComOpen([string]$Com) {
    try {
        $p = New-Object System.IO.Ports.SerialPort($Com, 115200, 'None', 8, 'One')
        $p.Open(); $p.Close()
        return $true
    } catch { return $false }
}

function Try-UpdateDriver([string]$InfPath) {
    Log "Trying driver update via SetupAPI: $InfPath"
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class DrvUpd {
  [DllImport("newdev.dll", CharSet=CharSet.Auto, SetLastError=true)]
  public static extern bool UpdateDriverForPlugAndPlayDevices(
    IntPtr hwndParent, string HardwareId, string InfPath, uint InstallFlags, IntPtr bRebootRequired);
}
'@
    $hwid = 'USB\VID_067B&PID_2303'
    $reboot = [IntPtr]::Zero
    $r = [DrvUpd]::UpdateDriverForPlugAndPlayDevices([IntPtr]::Zero, $hwid, $InfPath, 0x00000002, $reboot)
    if (-not $r) {
        $err = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
        Log "UpdateDriverForPlugAndPlayDevices failed, win32=$err"
        return $false
    }
    Log 'UpdateDriverForPlugAndPlayDevices OK'
    return $true
}

# Attempt 1: legacy prolific
if ($legacyInf) {
    Try-UpdateDriver $legacyInf.FullName | Out-Null
    Start-Sleep -Seconds 2
    pnputil /restart-device $inst 2>&1 | ForEach-Object { Log $_ }
    Start-Sleep -Seconds 3
}

# Attempt 2: Microsoft usbser
$usbser = 'C:\Windows\INF\usbser.inf'
if (-not (Test-ComOpen 'COM7') -and (Test-Path $usbser)) {
    Log 'Trying Microsoft usbser.inf...'
    pnputil /add-driver $usbser /install 2>&1 | ForEach-Object { Log $_ }
    Try-UpdateDriver $usbser | Out-Null
    Start-Sleep -Seconds 2
    pnputil /restart-device $inst 2>&1 | ForEach-Object { Log $_ }
    Start-Sleep -Seconds 3
}

# Rescan
pnputil /scan-devices 2>&1 | ForEach-Object { Log $_ }
Start-Sleep -Seconds 2

Log '=== After fix ==='
Get-PnpDevice | Where-Object { $_.InstanceId -match 'VID_067B&PID_2303' } | ForEach-Object {
    Log "PnP: $($_.Status) $($_.FriendlyName)"
}
$ports = [System.IO.Ports.SerialPort]::GetPortNames()
Log "COM ports: $($ports -join ', ')"
foreach ($c in $ports) {
    if (Test-ComOpen $c) { Log "OPEN OK: $c" }
}
Log "Log saved: $Log"
