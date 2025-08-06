# Simple Test Dispatcher
# A minimal version of test_dispatcher.ps1 to identify syntax issues

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Simple test function
function Test-Status {
    Write-Host "Testing Get-CouncilStatus..." -ForegroundColor Yellow
    
    try {
        $status = Get-CouncilStatus -ErrorAction Stop
        Write-Host "✅ Successfully retrieved council status" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "❌ Error getting council status: $_" -ForegroundColor Red
        return $false
    }
}

# Simple test function for Invoke-CouncilModule
function Test-InvokeModule {
    param([string]$ModuleName = "Lilith")
    
    Write-Host "Testing Invoke-CouncilModule for $ModuleName..." -ForegroundColor Yellow
    
    try {
        $result = Invoke-CouncilModule -ModuleName $ModuleName -ErrorAction Stop
        Write-Host "✅ Successfully invoked module: $($result.Module)" -ForegroundColor Green
        Write-Host ("- Response: {0}" -f $result.Message) -ForegroundColor White
        return $true
    } catch {
        Write-Host "❌ Error invoking $ModuleName module: $_" -ForegroundColor Red
        return $false
    }
}

# Run the tests
Write-Host "Starting simplified dispatcher tests..." -ForegroundColor Cyan

$statusTest = Test-Status
$invokeTest = Test-InvokeModule -ModuleName "Lilith"

# Display test results
Write-Host "`nTest Results:" -ForegroundColor Cyan
Write-Host ("- Status Test: {0}" -f $(if ($statusTest) { "✅ PASSED" } else { "❌ FAILED" })) -ForegroundColor White
Write-Host ("- Invoke Test: {0}" -f $(if ($invokeTest) { "✅ PASSED" } else { "❌ FAILED" })) -ForegroundColor White

Write-Host "`nTest completed!" -ForegroundColor Cyan
