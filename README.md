# Steam Counter Strike 2 Game Server Blocklist (NA, MA Region <50ms ATM)

Blocks malicious/undesired game servers in Massachusetts region for Counter Strike 2 via Windows Defender Firewall. These game servers are known for faking their ping, player count, and more.

## IP List
```
166.88.182.63
79.127.206.85
212.193.6.245
207.90.238.68
```

## Installation & Usage
1. Run PowerShell script as Administrator:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
.\block-cs2-servers.ps1
```

2. Verify rules exist in:
`Windows Defender Firewall with Advanced Security > Inbound/Outbound Rules`

## Uninstallation
To remove all blocklist rules:
```powershell
.\unblock-cs2-servers.ps1
```

## Maintenance
1. Update `ips-to-block.txt` with new IP addresses
2. Re-run `block-cs2-servers.ps1` to sync firewall rules
3. Old rules are automatically removed during each sync

## Troubleshooting
- Ensure PowerShell is running as Administrator
- Verify the `ips-to-block.txt` file exists in the same directory
- Check Windows Defender Firewall logs if rules aren't applying
- Use `Get-NetFirewallRule -Group "CS2 Server Blocklist"` to verify rules

## Disclaimer
This script modifies Windows Firewall settings. Use at your own risk. Always review the IP list before applying. The script requires administrative privileges to modify firewall rules.