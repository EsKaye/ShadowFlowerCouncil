# Minimal test script for dispatcher.ps1
# This script tests the dispatcher.ps1 file in small sections to identify syntax errors

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Test 1: Basic script execution
Write-Host "✅ Script loaded successfully" -ForegroundColor Green

# Test 2: Check if functions are available
$functions = @('Invoke-CouncilModule', 'Get-CouncilStatus', 'Sync-CouncilMemories')

foreach ($function in $functions) {
    if (Get-Command $function -ErrorAction SilentlyContinue) {
        Write-Host "✅ Function found: $function" -ForegroundColor Green
    } else {
        Write-Host "❌ Function not found: $function" -ForegroundColor Red
    }
}

# Test 3: Try to get council status
try {
    Write-Host "`nTesting Get-CouncilStatus..." -ForegroundColor Yellow
    $status = Get-CouncilStatus -ErrorAction Stop
    Write-Host "✅ Successfully retrieved council status" -ForegroundColor Green
    Write-Host ("- Total Modules: {0}" -f $status.TotalModules) -ForegroundColor White
} catch {
    Write-Host "❌ Error getting council status: $_" -ForegroundColor Red
}

Write-Host "`nTest completed!" -ForegroundColor Cyan
