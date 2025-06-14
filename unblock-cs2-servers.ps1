#Requires -RunAsAdministrator

$RuleGroupName = "CS2 Server Blocklist"
$ErrorActionPreference = "Stop"

Write-Host "Removing all CS2 Server Blocklist firewall rules..." -ForegroundColor Cyan

try {
    $rulesToRemove = Get-NetFirewallRule -Group $RuleGroupName -ErrorAction SilentlyContinue

    if ($rulesToRemove) {
        Write-Host "Found $(@($rulesToRemove).Count) rule(s) to remove." -ForegroundColor Yellow
        $rulesToRemove | Remove-NetFirewallRule
        Write-Host "All firewall rules for '$RuleGroupName' have been removed." -ForegroundColor Green
    }
    else {
        Write-Host "No firewall rules found for '$RuleGroupName'. No action needed." -ForegroundColor Green
    }
}
catch {
    Write-Error "An unexpected error occurred: $_"
    exit 1
}
