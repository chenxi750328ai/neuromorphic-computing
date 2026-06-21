# Switch PL2303 to legacy driver 3.3.2.105 (already in driver store)
$ErrorActionPreference = 'Continue'
$Log = "$env:TEMP\pl2303-switch.log"
function Log($m) { $line = "$(Get-Date -Format 'HH:mm:ss') $m"; Add-Content $Log $line; Write-Host $line }

Log '=== Switch PL2303 to 3.3.2.105 ==='
$inst = (Get-PnpDevice | Where-Object { $_.InstanceId -match 'VID_067B&PID_2303' } | Select-Object -First 1).InstanceId
if (-not $inst) { Log 'Device not found'; exit 1 }
Log "Instance: $inst"

$legacyInf = Get-ChildItem 'C:\Windows\System32\DriverStore\FileRepository\ser2pl.inf_amd64_*' -Recurse -Filter 'ser2pl.inf' -ErrorAction SilentlyContinue |
    Where-Object { (Select-String -Path $_.FullName -Pattern '3\.3\.2\.105' -Quiet) } |
    Select-Object -First 1
if (-not $legacyInf) { $legacyInf = Get-Item 'C:\Windows\INF\oem56.inf' -ErrorAction SilentlyContinue }
if (-not $legacyInf) { Log 'Legacy 3.3.2.105 INF not found'; exit 1 }
Log "Using INF: $($legacyInf.FullName)"

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class DrvSw {
  [DllImport("newdev.dll", CharSet=CharSet.Auto, SetLastError=true)]
  public static extern bool UpdateDriverForPlugAndPlayDevices(
    IntPtr hwndParent, string HardwareId, string InfPath, uint InstallFlags, IntPtr bRebootRequired);
}
'@

pnputil /add-driver $legacyInf.FullName /install 2>&1 | ForEach-Object { Log $_ }
$reboot = [IntPtr]::Zero
$ok = [DrvSw]::UpdateDriverForPlugAndPlayDevices([IntPtr]::Zero, 'USB\VID_067B&PID_2303', $legacyInf.FullName, 0x00000002, $reboot)
Log "UpdateDriver: $ok err=$([Runtime.InteropServices.Marshal]::GetLastWin32Error())"
pnputil /restart-device $inst 2>&1 | ForEach-Object { Log $_ }
Start-Sleep -Seconds 3

Get-PnpDeviceProperty -InstanceId $inst | Where-Object { $_.KeyName -match 'DriverVersion|DriverDesc|ProblemCode' } | ForEach-Object {
    Log "$($_.KeyName) = $($_.Data)"
}
Get-PnpDevice -InstanceId $inst | ForEach-Object { Log "FriendlyName: $($_.FriendlyName)" }

foreach ($c in [System.IO.Ports.SerialPort]::GetPortNames()) {
    try {
        $p = New-Object System.IO.Ports.SerialPort($c, 115200)
        $p.Open(); $p.Close()
        Log "OPEN OK: $c"
    } catch {
        Log "OPEN FAIL $c : $($_.Exception.Message)"
    }
}
Log "Log: $Log"
