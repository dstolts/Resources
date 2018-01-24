
# 
Get-NetFirewallRule –DisplayName “Allow Ping”
New-NetFirewallRule –DisplayName “Allow Ping” –Direction inbound –Action Allow –Protocol icmpv4 –Enabled True
Set-NetFirewallRule –DisplayName “Allow Ping” –Direction inbound –Action Allow –Protocol icmpv4 –Enabled True
Get-NetFirewallRule –DisplayName “Allow Ping”