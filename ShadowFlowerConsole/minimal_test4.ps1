# Minimal Test Script 4
# Testing basic PowerShell syntax

# Simple function definition and call
function Test-Function {
    param([string]$Name = "World")
    Write-Host "Hello, $Name"
}

# Call the function
Test-Function -Name "PowerShell"

# Test module path resolution
$modulePath = Join-Path $PSScriptRoot "Lilith.Eve"

if (Test-Path $modulePath) {
    Write-Host "✅ Module found at: $modulePath" -ForegroundColor Green
} else {
    Write-Host "❌ Module not found" -ForegroundColor Red
}

Write-Host "Test completed!" -ForegroundColor Cyan
