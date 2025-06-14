#Requires -RunAsAdministrator

$RuleGroupName = "CS2 Server Blocklist"
$InboundRuleName = "CS2 Server Blocklist (Inbound)"
$OutboundRuleName = "CS2 Server Blocklist (Outbound)"
$IpListFile = "$PSScriptRoot\ips-to-block.txt"
$ErrorActionPreference = "Stop"

Write-Host "Starting CS2 server blocklist sync..." -ForegroundColor Cyan

try {
    if (-not (Test-Path $IpListFile)) {
        Write-Error "'$IpListFile' not found in the script directory!"
        return
    }

    # Get all IPs to block, ensuring we have a clean list
    $ipsToBlock = Get-Content -Path $IpListFile | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() }

    # Clean slate: Remove the old rules every time for simplicity and consistency.
    Write-Host "Removing existing CS2 blocklist rules..."
    Get-NetFirewallRule -Group $RuleGroupName -ErrorAction SilentlyContinue | Remove-NetFirewallRule

    # If there are IPs in the list, create the new consolidated rules.
    if ($ipsToBlock.Count -gt 0) {
        Write-Host "Creating firewall rules for $($ipsToBlock.Count) IP(s)..." -ForegroundColor Yellow
        
        # Create one rule for Inbound traffic
        New-NetFirewallRule -DisplayName $InboundRuleName `
            -Group $RuleGroupName `
            -Direction Inbound `
            -Action Block `
            -Protocol Any `
            -RemoteAddress $ipsToBlock `
            -ErrorAction Stop

        # Create one rule for Outbound traffic
        New-NetFirewallRule -DisplayName $OutboundRuleName `
            -Group $RuleGroupName `
            -Direction Outbound `
            -Action Block `
            -Protocol Any `
            -RemoteAddress $ipsToBlock `
            -ErrorAction Stop
            
        Write-Host "Script completed. Total IPs blocked: $($ipsToBlock.Count)" -ForegroundColor Green
    }
    else {
        Write-Host "Blocklist is empty. All associated firewall rules have been removed." -ForegroundColor Green
    }
}
catch {
    Write-Error "An unexpected error occurred: $_"
    exit 1
}
