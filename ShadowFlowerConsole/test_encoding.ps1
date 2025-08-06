# Test script with explicit UTF-8 encoding
# This script tests basic PowerShell functionality with explicit encoding

# Simple function
test-function {
    param($name)
    Write-Host "Hello, $name"
}

# Call the function
test-function -name "PowerShell"

# Simple module path check
$modulePath = Join-Path $PSScriptRoot "Lilith.Eve"

if (Test-Path $modulePath) {
    Write-Host "Module found at: $modulePath" -ForegroundColor Green
} else {
    Write-Host "Module not found" -ForegroundColor Red
}

Write-Host "Test completed!" -ForegroundColor Cyan
