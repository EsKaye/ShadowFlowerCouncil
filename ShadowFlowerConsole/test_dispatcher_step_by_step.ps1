# Test Dispatcher - Step by Step
# This script tests the dispatcher with minimal functionality

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Simple test function for Get-CouncilStatus
function TestGetStatus {
    Write-Host "Testing Get-CouncilStatus..." -ForegroundColor Yellow
    try {
        $status = Get-CouncilStatus -ErrorAction Stop
        Write-Host "✅ Successfully retrieved council status" -ForegroundColor Green
        Write-Host ("- Total Modules: {0}" -f $status.TotalModules) -ForegroundColor White
        return $true
    } catch {
        Write-Host "❌ Error getting council status: $_" -ForegroundColor Red
        return $false
    }
}

# Test function for Invoke-CouncilModule
function TestInvokeModule {
    param([string]$ModuleName = "Lilith")
    
    Write-Host ("`nTesting Invoke-CouncilModule for {0}..." -f $ModuleName) -ForegroundColor Yellow
    try {
        $result = Invoke-CouncilModule -ModuleName $ModuleName -ErrorAction Stop
        Write-Host "✅ Successfully invoked module: $($result.Module)" -ForegroundColor Green
        Write-Host ("- Response: {0}" -f $result.Message) -ForegroundColor White
        
        $timestamp = [DateTimeOffset]::FromUnixTimeSeconds($result.Timestamp).DateTime
        Write-Host ("- Timestamp: {0}" -f ($timestamp.ToString("yyyy-MM-dd HH:mm:ss"))) -ForegroundColor White
        
        return $true
    } catch {
        Write-Host ("❌ Error invoking {0} module: {1}" -f $ModuleName, $_) -ForegroundColor Red
        return $false
    }
}

# Test function for Sync-CouncilMemories
function TestSyncMemories {
    Write-Host "`nTesting Sync-CouncilMemories..." -ForegroundColor Yellow
    try {
        $result = Sync-CouncilMemories -ErrorAction Stop
        Write-Host ("✅ {0}" -f $result) -ForegroundColor Green
        return $true
    } catch {
        Write-Host ("❌ Error syncing memories: {0}" -f $_) -ForegroundColor Red
        return $false
    }
}

# Main script execution
Write-Host "Starting test..." -ForegroundColor Cyan

# Run tests
$testResults = @{
    Status = TestGetStatus
    Invoke = TestInvokeModule -ModuleName "Lilith"
    Sync = TestSyncMemories
}

# Display test results
Write-Host "`nTest Results:" -ForegroundColor Cyan
foreach ($test in $testResults.GetEnumerator()) {
    Write-Host ("- {0,-20} {1}" -f $test.Key, $(if ($test.Value) { "✅ PASSED" } else { "❌ FAILED" })) -ForegroundColor White
}

# Calculate and display summary
$totalTests = $testResults.Count
$passedTests = ($testResults.Values | Where-Object { $_ -eq $true }).Count
$successRate = [math]::Round(($passedTests / $totalTests) * 100, 2)

Write-Host ("`nTest Summary: {0}/{1} tests passed ({2}%)" -f $passedTests, $totalTests, $successRate) -ForegroundColor Cyan

if ($passedTests -eq $totalTests) {
    Write-Host "✅ All tests completed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Some tests failed. Please check the output above for details." -ForegroundColor Red
}

Write-Host "`nTest completed!" -ForegroundColor Cyan
