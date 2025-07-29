<#
.SYNOPSIS
    Simple reusable logging module for PowerShell scripts.

.DESCRIPTION
    Provides basic logging functionality including:
    - Console + file output
    - Log levels (DEBUG, INFO, WARNING, ERROR)
    - Optional log file path
    - Ability to disable logging entirely

.USAGE
    # Import the module
    Import-Module "$PSScriptRoot\Logging.psm1"

    # Initialize logging (default INFO level)
    Initialize-Logger -LogPath "my_log.log" -LogLevel "DEBUG"

    # Or disable logging completely
    Initialize-Logger -DisableLogging

    # Write messages
    Write-Log -Message "Something happened" -Level "INFO"
    Write-Log -Message "Debugging details..." -Level "DEBUG"
    Write-Log -Message "A warning" -Level "WARNING"
    Write-Log -Message "An error occurred" -Level "ERROR"
#>

# Script-level defaults
$script:LogEnabled = $true
$script:LogFile = "log.txt"
$script:LogLevelThreshold = 1  # Default to INFO

function Initialize-Logger {
    <#
    .SYNOPSIS
        Initializes the logger.

    .PARAMETER LogPath
        Path to the log file.

    .PARAMETER LogLevel
        Minimum level to log (DEBUG, INFO, WARNING, ERROR).

    .PARAMETER DisableLogging
        Disable all logging output.

    .EXAMPLE
        Initialize-Logger -LogPath "app.log" -LogLevel "DEBUG"

    .EXAMPLE
        Initialize-Logger -DisableLogging
    #>
    param (
        [string]$LogPath = "log.txt",
        [ValidateSet("DEBUG", "INFO", "WARNING", "ERROR")]
        [string]$LogLevel = "INFO",
        [switch]$DisableLogging
    )

    $script:LogEnabled = -not $DisableLogging
    $script:LogFile = $LogPath

    $script:LogLevelThreshold = @{
        DEBUG = 0
        INFO = 1
        WARNING = 2
        ERROR = 3
    }[$LogLevel]
}

function Write-Log {
    <#
    .SYNOPSIS
        Writes a message to console and/or log file based on level.

    .PARAMETER Message
        The message to log.

    .PARAMETER Level
        Log level: DEBUG, INFO, WARNING, or ERROR.

    .EXAMPLE
        Write-Log -Message "Starting up..." -Level "INFO"
    #>
    param (
        [string]$Message,
        [ValidateSet("DEBUG", "INFO", "WARNING", "ERROR")]
        [string]$Level = "INFO"
    )

    if (-not $script:LogEnabled) {
        return
    }

    $levelMap = @{
        DEBUG = 0
        INFO = 1
        WARNING = 2
        ERROR = 3
    }

    if ($levelMap[$Level] -lt $script:LogLevelThreshold) {
        return
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $formatted = "[${timestamp}] [$Level]`t$Message"

    Write-Host $formatted
    Add-Content -Path $script:LogFile -Value $formatted
}
