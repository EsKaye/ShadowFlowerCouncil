# Test Module Utils
# Verifies the core functionality of module_utils.ps1

# Import the module utilities
. "$PSScriptRoot\module_utils.ps1"

# Test 1: Find Lilith.Eve module path
Write-Host "Testing Find-ModulePath for 'Lilith'..." -ForegroundColor Yellow
$modulePath = Find-ModulePath -ModuleName "Lilith"

if ($null -ne $modulePath) {
    Write-Host "✅ Found module at: $modulePath" -ForegroundColor Green
    
    # Test 2: Get module response
    Write-Host "`nTesting Get-ModuleResponse..." -ForegroundColor Yellow
    $response = Get-ModuleResponse -ModulePath $modulePath
    
    if ($null -ne $response) {
        Write-Host "✅ Got response from module:" -ForegroundColor Green
        Write-Host $response -ForegroundColor White
    } else {
        Write-Host "❌ No response from module" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Could not find Lilith module" -ForegroundColor Red
}

Write-Host "`nTest completed!" -ForegroundColor Cyan
