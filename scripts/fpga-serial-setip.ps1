param(
    [string]$Port = "COM10",
    [string]$TargetIp = "192.168.137.3",
    [string]$Prefix = "24"
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

$sp = New-Object System.IO.Ports.SerialPort $Port, 115200, "None", 8, "One"
$sp.Encoding = [System.Text.Encoding]::ASCII
$sp.Open()
Start-Sleep -Milliseconds 400
[void](Read-SerialFor $sp 1)

$cmds = @(
    "echo xilinx | sudo -S ip addr flush dev eth0",
    "echo xilinx | sudo -S ip addr add ${TargetIp}/${Prefix} dev eth0",
    "echo xilinx | sudo -S ip link set eth0 up",
    "ip -4 addr show dev eth0",
    "ping -c 2 192.168.137.101"
)
foreach ($cmd in $cmds) {
    $sp.Write($cmd + "`n")
    Start-Sleep -Seconds 3
    Write-Host "=== $cmd ==="
    Write-Host (Read-SerialFor $sp 4)
}
$sp.Close()
