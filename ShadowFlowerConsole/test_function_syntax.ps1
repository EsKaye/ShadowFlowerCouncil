# Test script with correct PowerShell function syntax

# Correct function declaration in PowerShell
function TestFunction {
    param(
        [string]$Name = "World"
    )
    
    Write-Host "Hello, $Name"
}

# Call the function with named parameter
TestFunction -Name "PowerShell"

# Call the function with positional parameter
TestFunction "Universe"

# Simple module path check
$modulePath = Join-Path $PSScriptRoot "Lilith.Eve"

if (Test-Path $modulePath) {
    Write-Host "✅ Module found at: $modulePath" -ForegroundColor Green
} else {
    Write-Host "❌ Module not found" -ForegroundColor Red
}

Write-Host "`nTest completed!" -ForegroundColor Cyan
