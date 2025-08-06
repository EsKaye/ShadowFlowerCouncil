# Minimal test script
# This script tests the most basic functionality

Write-Host "✅ Script loaded successfully" -ForegroundColor Green

# Try to import the dispatcher
Write-Host "`nTesting dispatcher import..." -ForegroundColor Yellow
try {
    . "$PSScriptRoot\dispatcher.ps1"
    Write-Host "✅ Successfully imported dispatcher.ps1" -ForegroundColor Green
} catch {
    Write-Host "❌ Error importing dispatcher.ps1: $_" -ForegroundColor Red
    exit 1
}

# Test if functions are available
$functions = @('Invoke-CouncilModule', 'Get-CouncilStatus', 'Sync-CouncilMemories')
$allFunctionsFound = $true

foreach ($function in $functions) {
    if (Get-Command $function -ErrorAction SilentlyContinue) {
        Write-Host "✅ Function found: $function" -ForegroundColor Green
    } else {
        Write-Host "❌ Function not found: $function" -ForegroundColor Red
        $allFunctionsFound = $false
    }
}

if ($allFunctionsFound) {
    Write-Host "`n✅ All required functions are available" -ForegroundColor Green
} else {
    Write-Host "`n❌ Some required functions are missing" -ForegroundColor Red
    exit 1
}

Write-Host "`n🏁 Test completed!" -ForegroundColor Cyan
