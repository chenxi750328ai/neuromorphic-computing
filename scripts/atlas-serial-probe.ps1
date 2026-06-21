# Probe Atlas via USB-TTL serial (115200)
param(
    [string]$Port = "COM7",
    [int]$Baud = 115200
)

function Read-SerialFor {
    param($SerialPort, [int]$Seconds)
    $sb = New-Object System.Text.StringBuilder
    $deadline = (Get-Date).AddSeconds($Seconds)
    while ((Get-Date) -lt $deadline) {
        try {
            while ($SerialPort.BytesToRead -gt 0) {
                [void]$sb.Append([char]$SerialPort.ReadByte())
            }
        } catch {}
        Start-Sleep -Milliseconds 80
    }
    return $sb.ToString()
}

$sp = New-Object System.IO.Ports.SerialPort $Port, $Baud, "None", 8, "One"
$sp.ReadTimeout = 2000
$sp.WriteTimeout = 2000
$sp.Encoding = [System.Text.Encoding]::ASCII

try {
    $sp.Open()
    Write-Host "=== Opened $Port @ $Baud ==="
    Start-Sleep -Milliseconds 800

    $boot = Read-SerialFor $sp 5
    Write-Host "=== Boot buffer (5s) ==="
    Write-Host $boot

    $sp.Write("`r")
    Start-Sleep -Seconds 1
    $afterEnter = Read-SerialFor $sp 3
    Write-Host "=== After Enter ==="
    Write-Host $afterEnter

    if ($afterEnter -match "login:|Login:" -or $boot -match "login:|Login:") {
        $sp.Write("root`r")
        Start-Sleep -Seconds 1
        $afterUser = Read-SerialFor $sp 2
        Write-Host "=== After root ==="
        Write-Host $afterUser

        $sp.Write("Mind@123`r")
        Start-Sleep -Seconds 1
        $afterPass = Read-SerialFor $sp 2
        Write-Host "=== After password ==="
        Write-Host $afterPass

        $sp.Write("ip a`r")
        Start-Sleep -Seconds 2
        $ipOut = Read-SerialFor $sp 3
        Write-Host "=== ip a ==="
        Write-Host $ipOut
    }
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
    exit 1
} finally {
    if ($sp.IsOpen) { $sp.Close() }
}
