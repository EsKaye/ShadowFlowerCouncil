# Minimal Test Script for Invoke-CouncilModule

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Test Invoke-CouncilModule
Write-Host "Testing Invoke-CouncilModule for Lilith..." -ForegroundColor Yellow

try {
    $result = Invoke-CouncilModule -ModuleName "Lilith" -ErrorAction Stop
    Write-Host "✅ Successfully invoked Lilith module" -ForegroundColor Green
    Write-Host ("- Response: {0}" -f $result.Message) -ForegroundColor White
} catch {
    Write-Host ("❌ Error: {0}" -f $_) -ForegroundColor Red
}
