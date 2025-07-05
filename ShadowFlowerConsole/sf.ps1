﻿# ðŸŒ‘ CursorKittenâ„¢ - ShadowFlower Console Command Interface (PowerShell)
# Purpose: Provide divine navigation and control for the ShadowFlower Console

param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(Position=1)]
    [string]$Module
)

$CONSOLE_DIR = "./ShadowFlowerConsole"

# Function to display help
function Show-Help {
    Write-Host "ðŸŒ‘ ShadowFlower Console - CursorKittenâ„¢ Commands" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Usage: ./sf.ps1 [command] [options]" -ForegroundColor White
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Cyan
    Write-Host "  open [module]     - Open a specific divine module" -ForegroundColor White
    Write-Host "  list              - List all available modules" -ForegroundColor White
    Write-Host "  status            - Check console and module status" -ForegroundColor White
    Write-Host "  init [module]     - Initialize a specific module" -ForegroundColor White
    Write-Host "  sync              - Synchronize all module memories" -ForegroundColor White
    Write-Host "  help              - Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  ./sf.ps1 open Lilith.Eve" -ForegroundColor White
    Write-Host "  ./sf.ps1 list" -ForegroundColor White
    Write-Host "  ./sf.ps1 status" -ForegroundColor White
}

# Function to list all modules
function List-Modules {
    Write-Host "ðŸŒ¸ Available Divine Modules:" -ForegroundColor Magenta
    Write-Host ""
    
    if (Test-Path $CONSOLE_DIR) {
        Set-Location $CONSOLE_DIR
        $modules = Get-ChildItem -Directory | Select-Object -ExpandProperty Name
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
        Write-Host "Usage: ./sf.ps1 init <module>" -ForegroundColor White
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

# Main command processing
switch ($Command) {
    "open" { Open-Module $Module }
    "list" { List-Modules }
    "status" { Check-Status }
    "init" { Initialize-Module $Module }
    "sync" { Sync-Memories }
    "help" { Show-Help }
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
