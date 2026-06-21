param([string]$Port = "COM7")

function Read-For($sp, [int]$Sec) {
    $sb = New-Object System.Text.StringBuilder
    $deadline = (Get-Date).AddSeconds($Sec)
    while ((Get-Date) -lt $deadline) {
        try { while ($sp.BytesToRead -gt 0) { [void]$sb.Append([char]$sp.ReadByte()) } } catch {}
        Start-Sleep -Milliseconds 40
    }
    return $sb.ToString()
}

$sp = New-Object System.IO.Ports.SerialPort $Port, 115200, "None", 8, "One"
$sp.Encoding = [System.Text.Encoding]::ASCII
$sp.Open()
try {
    $sp.Write("`r"); Start-Sleep -Seconds 1
    $sp.Write("root`r"); Start-Sleep -Seconds 1
    $sp.Write("Mind@123`r"); Start-Sleep -Seconds 2
    foreach ($cmd in @(
        "ip link show eth0",
        "ip link show eth1",
        "ip addr show eth1",
        "ls /etc/netplan/*.yaml 2>/dev/null; cat /etc/netplan/*.yaml 2>/dev/null"
    )) {
        $sp.Write("$cmd`r"); Start-Sleep -Seconds 1
        Write-Host "=== $cmd ==="
        Write-Host (Read-For $sp 3)
    }
} finally {
    if ($sp.IsOpen) { $sp.Close() }
}
