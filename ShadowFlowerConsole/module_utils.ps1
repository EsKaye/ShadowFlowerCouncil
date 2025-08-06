# Module Utilities for ShadowFlower Council
# Handles module discovery and response generation

# Find the path to a module by name
function Find-ModulePath {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModuleName
    )
    
    # Handle special case for Lilith.Eve
    if ($ModuleName -eq "Lilith") {
        $ModuleName = "Lilith.Eve"
    }
    
    # First try exact match
    $modulePath = Join-Path $PSScriptRoot $ModuleName
    if (Test-Path $modulePath) {
        return $modulePath
    }
    
    # Try case-insensitive match
    $module = Get-ChildItem -Path $PSScriptRoot -Directory | 
              Where-Object { $_.Name -like "*$ModuleName*" } | 
              Select-Object -First 1
    
    if ($null -ne $module) {
        return $module.FullName
    }
    
    return $null
}

# Get a response from a module
function Get-ModuleResponse {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModulePath
    )
    
    $moduleName = (Get-Item $ModulePath).Name
    $memoriesFile = Join-Path $ModulePath "@memories.md"
    $lessonsFile = Join-Path $ModulePath "@lessons-learned.md"
    
    # Try to get a random line from memories or lessons
    $sourceFile = $null
    
    # Prefer lessons-learned if available
    if (Test-Path $lessonsFile) {
        $sourceFile = $lessonsFile
    } elseif (Test-Path $memoriesFile) {
        $sourceFile = $memoriesFile
    }
    
    if ($null -eq $sourceFile) {
        return "$moduleName is present but has no memories or lessons to share at this time."
    }
    
    # Get a random line that's not empty and not a header
    $lines = Get-Content $sourceFile | Where-Object { 
        $_ -notmatch '^#' -and 
        -not [string]::IsNullOrWhiteSpace($_) -and
        $_.Trim().Length -gt 20  # Prefer lines with some content
    }
    
    if ($null -eq $lines -or $lines.Count -eq 0) {
        return "$moduleName is listening but has no words to share right now."
    }
    
    $randomIndex = Get-Random -Minimum 0 -Maximum $lines.Count
    return $lines[$randomIndex].Trim()
}

# Functions are available in the caller's scope when dot-sourced
