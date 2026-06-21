# Scan baud rates on Atlas serial — look for readable boot/login text
param([string]$Port = "COM7")

$bauds = @(115200, 1500000, 921600, 460800, 230400, 57600, 38400, 19200, 9600)

function Read-Port([int]$Baud, [int]$Seconds = 4) {
    $sp = New-Object System.IO.Ports.SerialPort $Port, $Baud, "None", 8, "One"
    $sp.ReadTimeout = 500
    $sp.Encoding = [System.Text.Encoding]::GetEncoding(28591) # iso-8859-1 raw bytes as chars
    $sb = New-Object System.Text.StringBuilder
    try {
        $sp.Open()
        $sp.DiscardInBuffer()
        $sp.Write("`r")
        $deadline = (Get-Date).AddSeconds($Seconds)
        while ((Get-Date) -lt $deadline) {
            try {
                while ($sp.BytesToRead -gt 0) {
                    [void]$sb.Append([char]$sp.ReadByte())
                }
            } catch {}
            Start-Sleep -Milliseconds 40
        }
    } catch {
        return @{ Baud = $Baud; Error = $_.Exception.Message; Text = "" }
    } finally {
        if ($sp.IsOpen) { $sp.Close() }
    }
    $text = $sb.ToString()
    $printable = ($text.ToCharArray() | Where-Object { [int][char]$_ -ge 32 -or $_ -eq "`n" -or $_ -eq "`r" }).Count
    $ratio = if ($text.Length -gt 0) { [math]::Round(100 * $printable / $text.Length, 1) } else { 0 }
    $keywords = @('login', 'Login', 'root', 'Ubuntu', 'openEuler', 'Mind', 'localhost', 'Hit', 'kernel', 'Starting', 'U-Boot', 'DDR', 'Atlas')
    $hits = ($keywords | Where-Object { $text -match $_ }).Count
    return @{ Baud = $Baud; Len = $text.Length; PrintablePct = $ratio; KeywordHits = $hits; Text = $text }
}

Write-Host "=== Baud scan on $Port (send Atlas power-cycle for best results) ==="
$best = $null
foreach ($b in $bauds) {
    $r = Read-Port $b 4
    if ($r.Error) {
        Write-Host "[$b] ERROR: $($r.Error)"
        continue
    }
    $preview = ($r.Text -replace "[^\x20-\x7E\r\n]", ".")
    if ($preview.Length -gt 120) { $preview = $preview.Substring(0, 120) + "..." }
    Write-Host "[$b] len=$($r.Len) printable=$($r.PrintablePct)% keywords=$($r.KeywordHits)"
    if ($preview) { Write-Host "  preview: $preview" }
    if (-not $best -or $r.KeywordHits -gt $best.KeywordHits -or ($r.KeywordHits -eq $best.KeywordHits -and $r.PrintablePct -gt $best.PrintablePct)) {
        $best = $r
    }
}

if ($best -and $best.Len -gt 0) {
    Write-Host "`n=== Best guess: $($best.Baud) ==="
    Write-Host ($best.Text -replace "[^\x20-\x7E\r\n\t]", ".")
} else {
    Write-Host "`nNo data on any baud — try swapping green/white (TX/RX)."
}
