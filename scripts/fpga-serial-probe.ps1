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

function Send-Cmd {
    param($SerialPort, [string]$Cmd, [int]$WaitSec = 2)
    $SerialPort.Write($Cmd + "`r")
    Start-Sleep -Seconds $WaitSec
    return Read-SerialFor $SerialPort $WaitSec
}

$sp = New-Object System.IO.Ports.SerialPort $Port, $Baud, "None", 8, "One"
$sp.ReadTimeout = 2000
$sp.WriteTimeout = 2000
$sp.Encoding = [System.Text.Encoding]::ASCII

try {
    $sp.Open()
    Write-Host "=== Opened $Port @ $Baud ==="
    Start-Sleep -Milliseconds 500
    $buf = Read-SerialFor $sp 3
    if ($buf) { Write-Host "=== Buffer ==="; Write-Host $buf }

    $sp.Write("`r")
    Start-Sleep -Seconds 1
    $prompt = Read-SerialFor $sp 2
    Write-Host "=== Prompt ==="; Write-Host $prompt

    foreach ($cred in @(
        @{ user = "xilinx"; pass = "xilinx" },
        @{ user = "root"; pass = "root" },
        @{ user = "pynq"; pass = "pynq" }
    )) {
        if ($prompt -notmatch "login:|Login:|password:|Password:") {
            $sp.Write("`r")
            Start-Sleep -Seconds 1
            $prompt = Read-SerialFor $sp 2
        }
        if ($prompt -match "login:|Login:") {
            Write-Host "=== Try user $($cred.user) ==="
            $sp.Write($cred.user + "`r")
            Start-Sleep -Seconds 1
            $p2 = Read-SerialFor $sp 2
            Write-Host $p2
            if ($p2 -match "password:|Password:") {
                $sp.Write($cred.pass + "`r")
                Start-Sleep -Seconds 2
                $p3 = Read-SerialFor $sp 3
                Write-Host $p3
                if ($p3 -match "#|\$") {
                    foreach ($cmd in @("hostname", "uname -a", "ip -4 addr")) {
                        Write-Host "=== $cmd ==="
                        Write-Host (Send-Cmd $sp $cmd 3)
                    }
                    break
                }
            }
        }
    }
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
    Write-Host "Close other apps using $Port (PuTTY/Cursor/TeraTerm) and retry."
    exit 1
} finally {
    if ($sp.IsOpen) { $sp.Close() }
}
