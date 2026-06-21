# Atlas eth1 直连 — PC 与板子同网段 192.168.137.x，不破坏 WiFi 上网
# 本板 netplan: eth1=192.168.137.2  |  官方文档常见 eth1=192.168.137.100  |  PC=192.168.137.101

$AtlasIps = @("192.168.137.2", "192.168.137.100")
$PcIp     = "192.168.137.101"
$Prefix  = 24

$EthName = (Get-NetAdapter | Where-Object {
    $_.InterfaceDescription -match 'Realtek.*GbE' -and $_.Status -eq 'Up'
} | Select-Object -First 1).Name

if (-not $EthName) {
    Write-Host "未找到已 Up 的 Realtek 以太网。请插好 Atlas 网线。"
    exit 1
}

Write-Host "网卡: $EthName"
Write-Host "PC    -> $PcIp / $Prefix"
Write-Host "Atlas -> $($AtlasIps -join ' 或 ') (eth1; 本机实测 .2)"

Get-NetRoute -InterfaceAlias $EthName -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue |
    Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue

Get-NetIPAddress -InterfaceAlias $EthName -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue

New-NetIPAddress -InterfaceAlias $EthName -IPAddress $PcIp -PrefixLength $Prefix -ErrorAction Stop | Out-Null

Write-Host "`n--- ping Atlas ---"
foreach ($AtlasIp in $AtlasIps) {
    Write-Host "ping $AtlasIp ..."
    ping.exe -n 2 $AtlasIp
}
Write-Host "`n--- ping 外网 (应仍走 WiFi) ---"
ping.exe -n 2 8.8.8.8
