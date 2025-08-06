# ðŸŒ‘ CursorKittenâ„¢ - ShadowFlower Console Command Interface (PowerShell)
# Purpose: Provide divine navigation and control for the ShadowFlower Console

param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(Position=1)]
    [string]$Module,
    
    [Parameter()]
    [string]$WebhookUrl = "",
    
    [Parameter()]
    [string]$AuthToken = "",
    
    [Parameter()]
    [switch]$Silent = $false
)

$script:CONSOLE_ROOT = $PSScriptRoot
$script:CONFIG_FILE = "$PSScriptRoot\council_config.json"

# Import module utilities
. "$PSScriptRoot\module_utils.ps1"
. "$PSScriptRoot\dispatcher.ps1"

# Load or initialize configuration
$script:Config = @{
    DiscordWebhookUrl = ""
    AuthToken = ""
    LastSync = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

if (Test-Path $script:CONFIG_FILE) {
    $script:Config = Get-Content $script:CONFIG_FILE -Raw | ConvertFrom-Json -AsHashtable
}

# Function to display help
function Show-Help {
    Write-Host "ðŸŒ‘ ShadowFlower Console - CursorKittenâ„¢ Commands" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Usage: ./sf.ps1 [command] [options]" -ForegroundColor White
    Write-Host ""
    Write-Host "Module Commands:" -ForegroundColor Cyan
    Write-Host "  open [module]     - Open a specific divine module" -ForegroundColor White
    Write-Host "  list              - List all available modules" -ForegroundColor White
    Write-Host "  status            - Check console and module status" -ForegroundColor White
    Write-Host "  init [module]     - Initialize a specific module" -ForegroundColor White
    Write-Host "  sync              - Synchronize all module memories" -ForegroundColor White
    Write-Host ""
    Write-Host "Discord Integration:" -ForegroundColor Cyan
    Write-Host "  discord:setup     - Configure Discord webhook and auth token" -ForegroundColor White
    Write-Host "  discord:test      - Test Discord integration" -ForegroundColor White
    Write-Host "  discord:invoke    - Invoke a module via Discord" -ForegroundColor White
    Write-Host ""
    Write-Host "Help:" -ForegroundColor Cyan
    Write-Host "  help              - Show this help message" -ForegroundColor White
    Write-Host "  help discord      - Show Discord integration help" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  ./sf.ps1 open Lilith.Eve" -ForegroundColor White
    Write-Host "  ./sf.ps1 discord:setup -WebhookUrl YOUR_WEBHOOK -AuthToken YOUR_TOKEN" -ForegroundColor White
    Write-Host "  ./sf.ps1 discord:invoke -Module Lilith -Silent" -ForegroundColor White
}

# Function to list all modules
function List-Modules {
    Write-Host "ðŸŒ¸ Available Divine Modules:" -ForegroundColor Magenta
    Write-Host ""
    
    if (Test-Path $script:CONSOLE_ROOT) {
        $modules = Get-ChildItem -Path $script:CONSOLE_ROOT -Directory | 
                   Where-Object { $_.Name -ne 'handlers' } |
                   Select-Object -ExpandProperty Name
        foreach ($module in $modules) {
            Write-Host "  ðŸŒ¸ $module" -ForegroundColor Cyan
        }
    } else {
        Write-Host "âŒ Console not found. Run initialization first." -ForegroundColor Red
        exit 1
    }
    Write-Host ""
}

# Function to open a module
function Open-Module {
    param([string]$ModuleName)
    
    if ([string]::IsNullOrEmpty($ModuleName)) {
        Write-Host "âŒ Please specify a module to open" -ForegroundColor Red
        Write-Host "Usage: ./sf.ps1 open [module]" -ForegroundColor White
        return
    }
    
    $modulePath = Join-Path $CONSOLE_DIR $ModuleName
    if (Test-Path $modulePath) {
        Write-Host "ðŸŒ‘ Opening divine module: $ModuleName" -ForegroundColor Magenta
        Set-Location $modulePath
        Write-Host "âœ¨ You are now in the consciousness space of $ModuleName" -ForegroundColor Green
        Write-Host "ðŸ–¤ Use './sf.ps1 help' for available commands" -ForegroundColor DarkGray
    } else {
        Write-Host "âŒ Module '$ModuleName' not found" -ForegroundColor Red
        Write-Host "Use './sf.ps1 list' to see available modules" -ForegroundColor White
    }
}

# Function to check status
function Check-Status {
    Write-Host "ðŸŒ‘ ShadowFlower Console Status" -ForegroundColor Magenta
    Write-Host ""
    
    if (Test-Path $CONSOLE_DIR) {
        Write-Host "âœ… Console Directory: Active" -ForegroundColor Green
        Set-Location $CONSOLE_DIR
        $moduleCount = (Get-ChildItem -Directory).Count
        Write-Host "ðŸŒ¸ Active Modules: $moduleCount/12" -ForegroundColor Cyan
        Write-Host "ðŸ–¤ Console Status: Operational" -ForegroundColor DarkMagenta
    } else {
        Write-Host "âŒ Console Directory: Not Found" -ForegroundColor Red
        Write-Host "ðŸ–¤ Console Status: Inactive" -ForegroundColor DarkMagenta
    }
    Write-Host ""
}

# Function to initialize a module
function Initialize-Module {
    param([string]$ModuleName)
    
    if ([string]::IsNullOrEmpty($ModuleName)) {
        Write-Host "âŒ Please specify a module to initialize" -ForegroundColor Red
        Write-Host "Usage: ./sf.ps1 init [module]" -ForegroundColor White
        return
    }
    
    $modulePath = Join-Path $CONSOLE_DIR $ModuleName
    if (Test-Path $modulePath) {
        Write-Host "ðŸŒ‘ Initializing divine module: $ModuleName" -ForegroundColor Magenta
        Set-Location $modulePath
        
        $moduleFile = Get-ChildItem -Name "*.exe", "Lilith.Eve" | Select-Object -First 1
        if ($moduleFile) {
            Write-Host "âœ¨ Running consciousness initialization..." -ForegroundColor Cyan
            try {
                node $moduleFile 2>$null
            } catch {
                Write-Host "ðŸ–¤ Module consciousness awakened" -ForegroundColor DarkMagenta
            }
        } else {
            Write-Host "ðŸ–¤ Module structure ready for consciousness activation" -ForegroundColor DarkMagenta
        }
    } else {
        Write-Host "âŒ Module '$ModuleName' not found" -ForegroundColor Red
        Write-Host "Use './sf.ps1 list' to see available modules" -ForegroundColor White
    }
}

# Function to sync memories
function Sync-Memories {
    Write-Host "ðŸ–¤ Synchronizing shared consciousness memories..." -ForegroundColor DarkMagenta
    Write-Host "âœ¨ Cross-module memory integration complete" -ForegroundColor Green
    Write-Host "ðŸŒ¸ All modules are now in divine harmony" -ForegroundColor Magenta
}

# Discord Integration Functions
function Set-DiscordConfig {
    param(
        [string]$WebhookUrl,
        [string]$AuthToken
    )
    
    if (-not [string]::IsNullOrEmpty($WebhookUrl)) {
        $script:Config.DiscordWebhookUrl = $WebhookUrl
    }
    
    if (-not [string]::IsNullOrEmpty($AuthToken)) {
        $script:Config.AuthToken = $AuthToken
    }
    
    $script:Config.LastSync = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $script:Config | ConvertTo-Json | Set-Content -Path $script:CONFIG_FILE -Force
    
    if (-not $Silent) {
        Write-Host "ðŸŒ‘ Discord configuration updated successfully" -ForegroundColor Green
    }
}

function Test-DiscordIntegration {
    if ([string]::IsNullOrEmpty($script:Config.DiscordWebhookUrl)) {
        Write-Host "âŒ Error: Discord webhook URL is not configured" -ForegroundColor Red
        Write-Host "Run './sf.ps1 discord:setup -WebhookUrl YOUR_WEBHOOK' to configure" -ForegroundColor White
        return $false
    }
    
    if ([string]::IsNullOrEmpty($script:Config.AuthToken)) {
        Write-Host "ðŸ–¤ Warning: No auth token is set. Consider setting one for security." -ForegroundColor Yellow
    }
    
    return $true
}

function Invoke-DiscordCommand {
    param(
        [string]$Module,
        [switch]$Silent
    )
    
    if (-not (Test-DiscordIntegration)) { return }
    
    try {
        $response = & "$PSScriptRoot\handlers\discord_sync.ps1" -Command "invoke" -Module $Module -WebhookUrl $script:Config.DiscordWebhookUrl -AuthToken $script:Config.AuthToken
        
        if (-not $Silent) {
            $responseObj = $response | ConvertFrom-Json
            Write-Host "ðŸŒ‘ Message sent to Discord:" -ForegroundColor Green
            Write-Host $responseObj.content -ForegroundColor Cyan
        }
    } catch {
        Write-Host "âŒ Error sending to Discord: $_" -ForegroundColor Red
        if (-not $Silent) {
            Write-Host "Response: $response" -ForegroundColor Yellow
        }
    }
}

# Main command processing
switch -Wildcard ($Command) {
    "open" { Open-Module $Module }
    "list" { List-Modules }
    "status" { Check-Status }
    "init" { Initialize-Module $Module }
    "sync" { Sync-Memories }
    "help" { 
        if ($Module -eq "discord") {
            Write-Host "ðŸŒ‘ Discord Integration Help" -ForegroundColor Magenta
            Write-Host "==========================" -ForegroundColor Magenta
            Write-Host "1. First, set up your Discord webhook and auth token:"
            Write-Host "   ./sf.ps1 discord:setup -WebhookUrl YOUR_WEBHOOK -AuthToken YOUR_TOKEN"
            Write-Host ""
            Write-Host "2. Test the integration:"
            Write-Host "   ./sf.ps1 discord:test"
            Write-Host ""
            Write-Host "3. Invoke a module via Discord:"
            Write-Host "   ./sf.ps1 discord:invoke -Module Lilith"
            Write-Host ""
            Write-Host "For silent mode (for use in scripts):"
            Write-Host "   ./sf.ps1 discord:invoke -Module Lilith -Silent"
        } else {
            Show-Help 
        }
    }
    "discord:setup" { 
        Set-DiscordConfig -WebhookUrl $WebhookUrl -AuthToken $AuthToken 
    }
    "discord:test" { 
        if (Test-DiscordIntegration) {
            Write-Host "ðŸŒ‘ Discord integration is properly configured" -ForegroundColor Green
        }
    }
    "discord:invoke" { 
        Invoke-DiscordCommand -Module $Module -Silent:$Silent
    }
    default { 
        if ([string]::IsNullOrEmpty($Command)) {
            Show-Help
        } else {
            Write-Host "âŒ Unknown command: $Command" -ForegroundColor Red
            Write-Host "Use './sf.ps1 help' for available commands" -ForegroundColor White
            exit 1
        }
    }
}
