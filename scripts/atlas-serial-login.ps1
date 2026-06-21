param([string]$Port = "COM7", [int]$Baud = 115200)

function Read-For($sp, [int]$Sec) {
    $sb = New-Object System.Text.StringBuilder
    $deadline = (Get-Date).AddSeconds($Sec)
    while ((Get-Date) -lt $deadline) {
        try { while ($sp.BytesToRead -gt 0) { [void]$sb.Append([char]$sp.ReadByte()) } } catch {}
        Start-Sleep -Milliseconds 40
    }
    return $sb.ToString()
}

function Send($sp, [string]$s) {
    $sp.Write($s)
    Start-Sleep -Milliseconds 400
}

$sp = New-Object System.IO.Ports.SerialPort $Port, $Baud, "None", 8, "One"
$sp.ReadTimeout = 500
$sp.Encoding = [System.Text.Encoding]::ASCII
$sp.Open()
try {
    Write-Host "=== Connected $Port @ $Baud ==="
    $sp.DiscardInBuffer()
    Send $sp "`r"
    $p = Read-For $sp 2
    Write-Host $p

    Send $sp "root`r"
    $p = Read-For $sp 2
    Write-Host $p

    Send $sp "Mind@123`r"
    $p = Read-For $sp 3
    Write-Host $p

    foreach ($cmd in @("hostname", "ip a", "ip route", "npu-smi info")) {
        Send $sp "$cmd`r"
        $out = Read-For $sp 4
        Write-Host "=== $cmd ==="
        Write-Host $out
    }
} finally {
    if ($sp.IsOpen) { $sp.Close() }
}
