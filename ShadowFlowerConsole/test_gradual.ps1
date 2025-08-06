# Gradual Test Script
# This script tests functionality by gradually adding complexity

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Test 1: Basic function call
Write-Host "Test 1: Basic function call" -ForegroundColor Yellow
$result = Invoke-CouncilModule -ModuleName "Lilith" -ErrorAction Stop
Write-Host "✅ Test 1 passed" -ForegroundColor Green

# Test 2: Function with try-catch
try {
    Write-Host "`nTest 2: Function with try-catch" -ForegroundColor Yellow
    $result = Invoke-CouncilModule -ModuleName "Lilith" -ErrorAction Stop
    Write-Host "✅ Test 2 passed" -ForegroundColor Green
} catch {
    Write-Host "❌ Test 2 failed: $_" -ForegroundColor Red
}

# Test 3: Function with parameters and output
function Test-InvokeModule {
    param([string]$ModuleName = "Lilith")
    
    try {
        $result = Invoke-CouncilModule -ModuleName $ModuleName -ErrorAction Stop
        Write-Host ("✅ Successfully invoked module: {0}" -f $result.Module) -ForegroundColor Green
        return $true
    } catch {
        Write-Host ("❌ Error: {0}" -f $_) -ForegroundColor Red
        return $false
    }
}

Write-Host "`nTest 3: Function with parameters and output" -ForegroundColor Yellow
$testResult = Test-InvokeModule -ModuleName "Lilith"
Write-Host ("Test 3 result: {0}" -f $(if ($testResult) { "✅ PASSED" } else { "❌ FAILED" })) -ForegroundColor $(if ($testResult) { "Green" } else { "Red" })

Write-Host "`n🏁 All tests completed!" -ForegroundColor Cyan
