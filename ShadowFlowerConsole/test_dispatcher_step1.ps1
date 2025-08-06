# Test Dispatcher - Step 1
# Minimal script to test basic functionality

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Simple function to display test header
function ShowTestHeader {
    param([string]$Title)
    Write-Host "`n$('=' * 60)" -ForegroundColor Cyan
    Write-Host "🔍 $Title" -ForegroundColor Cyan
    Write-Host "$('=' * 60)" -ForegroundColor Cyan
}

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
    ShowTestHeader -Title "Testing Get-CouncilStatus"
    $status = Get-CouncilStatus -ErrorAction Stop
    Write-Host "✅ Successfully retrieved council status" -ForegroundColor Green
    Write-Host ("- Total Modules: {0}" -f $status.TotalModules) -ForegroundColor White
} catch {
    Write-Host "❌ Error getting council status: $_" -ForegroundColor Red
}

Write-Host "`n🏁 Test completed!" -ForegroundColor Cyan
