# Simple Dispatcher Test
# A minimal version of the dispatcher to test core functionality

# Function to find a module path
function Find-SimpleModulePath {
    param([string]$ModuleName)
    
    # Handle Lilith -> Lilith.Eve mapping
    if ($ModuleName -eq "Lilith") {
        $ModuleName = "Lilith.Eve"
    }
    
    # Try exact match first
    $modulePath = Join-Path $PSScriptRoot $ModuleName
    if (Test-Path $modulePath) {
        return $modulePath
    }
    
    # Try case-insensitive match
    $module = Get-ChildItem -Path $PSScriptRoot -Directory | 
              Where-Object { $_.Name -like "*$ModuleName*" } | 
              Select-Object -First 1
    
    if ($module) {
        return $module.FullName
    }
    
    return $null
}

# Function to get a random response from a module
function Get-SimpleModuleResponse {
    param([string]$ModulePath)
    
    $memoriesFile = Join-Path $ModulePath "@memories.md"
    $lessonsFile = Join-Path $ModulePath "@lessons-learned.md"
    
    # Try to read from lessons first, then memories
    $sourceFile = if (Test-Path $lessonsFile) { $lessonsFile } 
                 elseif (Test-Path $memoriesFile) { $memoriesFile }
                 else { return $null }
    
    # Get non-empty lines that aren't headers
    $lines = Get-Content $sourceFile | Where-Object { 
        $_ -notmatch '^#' -and 
        -not [string]::IsNullOrWhiteSpace($_) -and
        $_.Trim().Length -gt 20
    }
    
    if ($lines.Count -eq 0) { return $null }
    
    # Return a random line
    return $lines[(Get-Random -Maximum $lines.Count)].Trim()
}

# Main function to invoke a module
function Invoke-SimpleModule {
    param([string]$ModuleName = "Lilith")
    
    Write-Host "🔍 Looking for module: $ModuleName" -ForegroundColor Cyan
    
    $modulePath = Find-SimpleModulePath -ModuleName $ModuleName
    
    if (-not $modulePath) {
        Write-Host "❌ Module '$ModuleName' not found" -ForegroundColor Red
        return
    }
    
    Write-Host "✅ Found module at: $modulePath" -ForegroundColor Green
    
    $response = Get-SimpleModuleResponse -ModulePath $modulePath
    
    if ($response) {
        Write-Host "📜 Module response:" -ForegroundColor Cyan
        Write-Host "   $response" -ForegroundColor White
        return $response
    } else {
        Write-Host "ℹ️  No response generated from module" -ForegroundColor Yellow
        return "$ModuleName is listening but has no response at this time."
    }
}

# If script is run directly, test with default module
if ($MyInvocation.InvocationName -eq '.\simple_dispatcher.ps1') {
    Invoke-SimpleModule -ModuleName "Lilith"
}
