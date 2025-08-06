# Simple Test Script
# This script tests basic functionality with minimal content

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Simple function call
Write-Host "Testing Invoke-CouncilModule for Lilith..." -ForegroundColor Yellow

# Call the function
try {
    $result = Invoke-CouncilModule -ModuleName "Lilith" -ErrorAction Stop
    Write-Host "✅ Successfully invoked Lilith module" -ForegroundColor Green
    Write-Host ("- Response: {0}" -f $result.Message) -ForegroundColor White
} catch {
    Write-Host ("❌ Error: {0}" -f $_) -ForegroundColor Red
}
