#requires -Version 5.0
. "$(Join-Path $PSScriptRoot 'logger.ps1')"

# Initialize logging
Initialize-Logger -LogPath "$(Join-Path $PSScriptRoot 'logs/log.txt')" -LogLevel "Info"

Write-Log -Level Info -Message "Starting script Get-EDR"

# Your script logic goes here

Write-Log -Level Info -Message "Finished script Get-EDR"
