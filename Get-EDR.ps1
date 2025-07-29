#requires -Version 5.0
. "$(Join-Path $PSScriptRoot 'logger.psm1')"

# Initialize logging
Initialize-Logger -LogPath "$(Join-Path $PSScriptRoot 'logs/log.txt')" -LogLevel "Info"

Write-Log -Level Info -Message "Starting script Get-EDR"
<#
.SYNOPSIS
Opens the Chrome browser with two FortiEDR URLs for the specified event number.

.DESCRIPTION
This script launches Google Chrome and navigates to two FortiEDR-related URLs:
1. A detailed event process viewer
2. The event's investigation page

It accepts one argument: the event number to include in the URLs.

.PARAMETER eventNumber
The ID number of the FortiEDR event to investigate.

.EXAMPLE
.\Get-EDR.ps1 123456

This command opens Chrome with URLs related to event 123456 in FortiEDR.

.NOTES
Ensure Google Chrome is installed in the default path, or modify $chromePath accordingly.
#>

$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

$eventNumber = $args[0]

if (-not $eventNumber) {
    Write-Host "Usage: Get-EDR.ps1 <event_number>"
    exit 1
}

$url_base = "https://fortixdrconnectna11.fortiedr.com/___/event-viewer/All/process/$eventNumber"
$url_investigation = "https://fortixdrconnectna11.fortiedr.com/investigation?&eventId=$eventNumber"

Start-Process -FilePath $chromePath -ArgumentList $url_base, $url_investigation
# Your script logic goes here

Write-Log -Level Info -Message "Finished script Get-EDR"
