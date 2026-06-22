param(
    [string]$Port = "COM10",
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
$sp.Encoding = [System.Text.Encoding]::ASCII
$sp.Open()
Start-Sleep -Milliseconds 400
[void](Read-SerialFor $sp 1)

foreach ($cmd in @("hostname", "uname -a", "ip -4 addr show", "cat /etc/board_hostname 2>/dev/null || true")) {
    $sp.Write($cmd + "`n")
    Start-Sleep -Seconds 2
    Write-Host "=== $cmd ==="
    Write-Host (Read-SerialFor $sp 3)
}
$sp.Close()
