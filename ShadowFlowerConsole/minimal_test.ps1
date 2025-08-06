# Minimal test script to identify PowerShell syntax issues

# Function to test module path resolution
function Test-ModulePath {
    param([string]$ModuleName = "Lilith")
    
    Write-Host "Testing module path resolution for: $ModuleName"
    
    # Try to find the module
    $modulePath = Join-Path $PSScriptRoot $ModuleName
    if (Test-Path $modulePath) {
        Write-Host "✅ Module found at: $modulePath" -ForegroundColor Green
        return $true
    } else {
        # Try case-insensitive match
        $module = Get-ChildItem -Path $PSScriptRoot -Directory | 
                  Where-Object { $_.Name -like "*$ModuleName*" } | 
                  Select-Object -First 1
        
        if ($module) {
            Write-Host "✅ Module found at: $($module.FullName)" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ Module not found" -ForegroundColor Red
            return $false
        }
    }
}

# Test the function
Test-ModulePath -ModuleName "Lilith"
