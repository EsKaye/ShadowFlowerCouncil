# Minimal test script to identify PowerShell syntax issues

# Test 1: Basic string output
Write-Host "✅ Test 1: Basic string output works" -ForegroundColor Green

# Test 2: Simple function
test-function {
    param($name)
    Write-Host "Hello, $name"
}

# Test 3: Call the function
test-function -name "World"

# Test 4: Simple module path check
$modulePath = Join-Path $PSScriptRoot "Lilith.Eve"
if (Test-Path $modulePath) {
    Write-Host "✅ Test 4: Module path check works" -ForegroundColor Green
} else {
    Write-Host "❌ Test 4: Module path not found" -ForegroundColor Red
}
