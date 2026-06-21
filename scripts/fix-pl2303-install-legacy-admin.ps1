# Install legacy PL2303 via official 2009 installer + force device driver
$ErrorActionPreference = 'Continue'
$Log = "$env:TEMP\pl2303-fix2.log"
function Log($m) { $line = "$(Get-Date -Format 'HH:mm:ss') $m"; Add-Content $Log $line; Write-Host $line }

Log '=== PL2303 legacy install (admin) ==='
$exe = 'C:\Users\chenx\Desktop\pl2303_driver\extracted\PL2303_Prolific_GPS_1013_20090319.exe'
if (-not (Test-Path $exe)) { Log "Missing $exe"; exit 1 }

Log "Running installer: $exe"
$p = Start-Process -FilePath $exe -ArgumentList '/S' -Wait -PassThru
Log "Installer exit code: $($p.ExitCode)"

Start-Sleep -Seconds 3

# List all ser2pl*.inf in driver store
$infs = Get-ChildItem 'C:\Windows\INF' -Filter 'ser2pl*.inf' -ErrorAction SilentlyContinue
Get-ChildItem 'C:\Windows\System32\DriverStore\FileRepository' -Recurse -Filter 'ser2pl*.inf' -ErrorAction SilentlyContinue | ForEach-Object { $infs += $_ }
$infs = $infs | Sort-Object LastWriteTime -Unique
Log "Found INF files:"
$infs | ForEach-Object { Log "  $($_.FullName) [$($_.LastWriteTime)]" }

$inst = (Get-PnpDevice | Where-Object { $_.InstanceId -match 'VID_067B&PID_2303' } | Select-Object -First 1).InstanceId
Log "Device instance: $inst"

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class DrvUpd2 {
  [DllImport("newdev.dll", CharSet=CharSet.Auto, SetLastError=true)]
  public static extern bool UpdateDriverForPlugAndPlayDevices(
    IntPtr hwndParent, string HardwareId, string InfPath, uint InstallFlags, IntPtr bRebootRequired);
}
'@

foreach ($inf in ($infs | Sort-Object LastWriteTime)) {
    Log "Trying INF: $($inf.FullName)"
    pnputil /add-driver $inf.FullName /install 2>&1 | ForEach-Object { Log "  $_" }
    $reboot = [IntPtr]::Zero
    $r = [DrvUpd2]::UpdateDriverForPlugAndPlayDevices([IntPtr]::Zero, 'USB\VID_067B&PID_2303', $inf.FullName, 0x00000002, $reboot)
    Log "  UpdateDriver result: $r err=$([Runtime.InteropServices.Marshal]::GetLastWin32Error())"
    if ($inst) { pnputil /restart-device $inst 2>&1 | ForEach-Object { Log "  $_" } }
    Start-Sleep -Seconds 2
    try {
        $sp = New-Object System.IO.Ports.SerialPort('COM7',115200)
        $sp.Open(); $sp.Close()
        Log 'SUCCESS: COM7 opens!'
        break
    } catch {
        Log "  COM7 still fail: $($_.Exception.Message)"
    }
}

Log '=== Final state ==='
Get-PnpDevice | Where-Object { $_.InstanceId -match 'VID_067B&PID_2303' } | ForEach-Object {
    Log "PnP: $($_.Status) $($_.FriendlyName)"
}
[System.IO.Ports.SerialPort]::GetPortNames() | ForEach-Object { Log "Port: $_" }
Log "Done. Log: $Log"
