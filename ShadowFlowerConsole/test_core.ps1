# Test Core Functionality
# This script tests the core functionality with proper PowerShell syntax

# Function to test module path resolution
function Test-ModulePath {
    param(
        [string]$ModuleName = "Lilith"
    )
    
    Write-Host "Testing module path resolution for: $ModuleName"
    
    # Handle Lilith -> Lilith.Eve mapping
    if ($ModuleName -eq "Lilith") {
        $ModuleName = "Lilith.Eve"
    }
    
    # Try exact match first
    $modulePath = Join-Path $PSScriptRoot $ModuleName
    if (Test-Path $modulePath) {
        Write-Host "✅ Module found at: $modulePath" -ForegroundColor Green
        return $modulePath
    }
    
    # Try case-insensitive match
    $module = Get-ChildItem -Path $PSScriptRoot -Directory | 
              Where-Object { $_.Name -like "*$ModuleName*" } | 
              Select-Object -First 1
    
    if ($module) {
        Write-Host "✅ Module found at: $($module.FullName)" -ForegroundColor Green
        return $module.FullName
    }
    
    Write-Host "❌ Module not found" -ForegroundColor Red
    return $null
}

# Test the function
$modulePath = Test-ModulePath -ModuleName "Lilith"

# If module found, try to read a file
if ($modulePath) {
    $memoriesFile = Join-Path $modulePath "@memories.md"
    if (Test-Path $memoriesFile) {
        Write-Host "✅ Found memories file: $memoriesFile" -ForegroundColor Green
        
        # Read and display the first few lines
        $firstLines = Get-Content -Path $memoriesFile -TotalCount 5
        Write-Host "`nFirst 5 lines of memories:" -ForegroundColor Cyan
        $firstLines | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
    } else {
        Write-Host "❌ Memories file not found in module" -ForegroundColor Red
    }
}
