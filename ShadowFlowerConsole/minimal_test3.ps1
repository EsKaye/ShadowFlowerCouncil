# Minimal Test Script
# Testing basic PowerShell syntax

# Simple function
test-function {
    param($name)
    Write-Host "Hello, $name"
}

# Call the function
test-function -name "World"

# Simple module path check
$modulePath = Join-Path $PSScriptRoot "Lilith.Eve"

if (Test-Path $modulePath) {
    Write-Host "✅ Module found at: $modulePath" -ForegroundColor Green
} else {
    Write-Host "❌ Module not found" -ForegroundColor Red
}
