#Requires -RunAsAdministrator
param(
    [string]$InterfaceAlias = "Ethernet",
    [string]$AliasIp = "192.168.2.1",
    [int]$Prefix = 24,
    [string]$BoardIp = "192.168.2.99"
)

$iface = Get-NetAdapter -Physical | Where-Object { $_.Status -eq 'Up' -and $_.InterfaceDescription -match 'Realtek' } | Select-Object -First 1
if ($iface) { $InterfaceAlias = $iface.Name }

$existing = Get-NetIPAddress -InterfaceAlias $InterfaceAlias -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object { $_.IPAddress -eq $AliasIp }
if (-not $existing) {
    New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $AliasIp -PrefixLength $Prefix
    Write-Host "Added $AliasIp on $InterfaceAlias"
} else {
    Write-Host "Already have $AliasIp on $InterfaceAlias"
}

Write-Host "Ping board $BoardIp ..."
if (Test-Connection -ComputerName $BoardIp -Count 2 -Quiet) {
    Write-Host "PASS ping $BoardIp"
    Write-Host "Jupyter: http://${BoardIp}:9090/lab"
    Write-Host "SSH: ssh xilinx@${BoardIp}  (password: xilinx)"
} else {
    Write-Host "FAIL ping $BoardIp - check cable / boot / SD image"
}
