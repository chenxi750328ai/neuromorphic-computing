# Force PL2303 onto driver 3.3.2.105 by removing blocked 3.9.6.2 binding
$ErrorActionPreference = 'Continue'
$Log = "$env:TEMP\pl2303-force.log"
function Log($m) { $line = "$(Get-Date -Format 'HH:mm:ss') $m"; Add-Content $Log $line; Write-Host $line }

Log '=== Force PL2303 legacy driver ==='
$inst = (Get-PnpDevice | Where-Object { $_.InstanceId -match 'VID_067B&PID_2303' } | Select-Object -First 1).InstanceId
$legacyInf = 'C:\Windows\System32\DriverStore\FileRepository\ser2pl.inf_amd64_e0e24ed5af01cfc3\ser2pl.inf'
if (-not (Test-Path $legacyInf)) {
    $legacyInf = (Get-ChildItem 'C:\Windows\System32\DriverStore\FileRepository\ser2pl.inf_amd64_*' -Recurse -Filter ser2pl.inf | Select-Object -First 1).FullName
}
Log "Device: $inst"
Log "Legacy INF: $legacyInf"

# Step 1: disable device
Disable-PnpDevice -InstanceId $inst -Confirm:$false -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# Step 2: remove device (will re-enumerate on enable/replug)
pnputil /remove-device $inst 2>&1 | ForEach-Object { Log $_ }
Start-Sleep -Seconds 2

# Step 3: delete blocked driver package (optional, may need force)
pnputil /delete-driver oem59.inf /uninstall /force 2>&1 | ForEach-Object { Log $_ }
Start-Sleep -Seconds 1

# Step 4: ensure legacy driver present
pnputil /add-driver $legacyInf /install 2>&1 | ForEach-Object { Log $_ }

# Step 5: rescan USB
pnputil /scan-devices 2>&1 | ForEach-Object { Log $_ }
Start-Sleep -Seconds 4

$dev = Get-PnpDevice | Where-Object { $_.InstanceId -match 'VID_067B&PID_2303' } | Select-Object -First 1
if ($dev) {
    $inst = $dev.InstanceId
    Log "Re-found: $inst $($dev.FriendlyName)"
    Add-Type -TypeDefinition @'
using System; using System.Runtime.InteropServices;
public class DrvF {
  [DllImport("newdev.dll", CharSet=CharSet.Auto, SetLastError=true)]
  public static extern bool UpdateDriverForPlugAndPlayDevices(
    IntPtr h, string id, string inf, uint flags, IntPtr reboot);
}
'@
    $rb = [IntPtr]::Zero
    $r = [DrvF]::UpdateDriverForPlugAndPlayDevices([IntPtr]::Zero, 'USB\VID_067B&PID_2303', $legacyInf, 2, $rb)
    Log "UpdateDriver legacy: $r err=$([Runtime.InteropServices.Marshal]::GetLastWin32Error())"
    pnputil /restart-device $inst 2>&1 | ForEach-Object { Log $_ }
    Start-Sleep -Seconds 3
    Get-PnpDeviceProperty -InstanceId $inst | Where-Object { $_.KeyName -match 'DriverVersion|ProblemCode' } | ForEach-Object { Log "$($_.KeyName)=$($_.Data)" }
    Get-PnpDevice -InstanceId $inst | ForEach-Object { Log "Name: $($_.FriendlyName)" }
} else {
    Log 'WARN: device not re-enumerated — please unplug/replug USB-TTL'
}

foreach ($c in [System.IO.Ports.SerialPort]::GetPortNames()) {
    try { $p = New-Object System.IO.Ports.SerialPort($c,115200); $p.Open(); $p.Close(); Log "OPEN OK $c" } catch { Log "OPEN FAIL $c" }
}
Log "Done $Log"
