# Extended Atlas serial probe — longer listen + login attempt
param([string]$Port = "COM7", [int]$Baud = 115200)

function Read-SerialFor($sp, [int]$Seconds) {
    $sb = New-Object System.Text.StringBuilder
    $deadline = (Get-Date).AddSeconds($Seconds)
    while ((Get-Date) -lt $deadline) {
        try {
            while ($sp.BytesToRead -gt 0) {
                [void]$sb.Append([char]$sp.ReadByte())
            }
        } catch {}
        Start-Sleep -Milliseconds 50
    }
    return $sb.ToString()
}

$sp = New-Object System.IO.Ports.SerialPort $Port, $Baud, "None", 8, "One"
$sp.ReadTimeout = 1000
$sp.Encoding = [System.Text.Encoding]::UTF8

try {
    $sp.Open()
    Write-Host "=== $Port opened ==="

    # flush + listen 15s (Atlas may still booting)
    $sp.DiscardInBuffer()
    Write-Host "=== Listening 15s (ensure Atlas powered) ==="
    $listen = Read-SerialFor $sp 15
    if ($listen) { Write-Host $listen } else { Write-Host "(no data yet)" }

    foreach ($cmd in @("`r", "`r`n", "root`r", "Mind@123`r", "`r", "ip a`r", "ifconfig`r", "uname -a`r")) {
        $sp.Write($cmd)
        Start-Sleep -Milliseconds 800
        $out = Read-SerialFor $sp 2
        if ($out) {
            Write-Host "=== After [$cmd repr] ==="
            Write-Host $out
        }
    }

    Write-Host "=== Final 5s listen ==="
    $final = Read-SerialFor $sp 5
    if ($final) { Write-Host $final } else { Write-Host "(still no data — check wiring/power)" }

} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
    exit 1
} finally {
    if ($sp.IsOpen) { $sp.Close() }
}
