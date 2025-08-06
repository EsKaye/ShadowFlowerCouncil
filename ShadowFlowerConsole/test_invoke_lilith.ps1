# Test Script: Invoke Lilith
# Verifies the end-to-end functionality of the /invoke Lilith command

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Function to display test header
function ShowTestHeader {
    param([string]$Title)
    Write-Host "`n$('=' * 60)" -ForegroundColor Cyan
    Write-Host "🔍 $Title" -ForegroundColor Cyan
    Write-Host "$('=' * 60)" -ForegroundColor Cyan
}

# Main test function
function TestInvokeLilith {
    ShowTestHeader -Title "Testing /invoke Lilith Command"
    
    # Test 1: Invoke Lilith module
    try {
        Write-Host "Invoking Lilith module..." -ForegroundColor Yellow
        $result = Invoke-CouncilModule -ModuleName "Lilith" -ErrorAction Stop
        
        Write-Host "✅ Successfully invoked Lilith module" -ForegroundColor Green
        Write-Host ("- Response: {0}" -f $result.Message) -ForegroundColor White
        
        $timestamp = [DateTimeOffset]::FromUnixTimeSeconds($result.Timestamp).DateTime
        Write-Host ("- Timestamp: {0}" -f ($timestamp.ToString("yyyy-MM-dd HH:mm:ss"))) -ForegroundColor White
        
        return $true
    } catch {
        Write-Host "❌ Error invoking Lilith module: $_" -ForegroundColor Red
        return $false
    }
}

# Execute the test
$testResult = TestInvokeLilith

# Display test result
ShowTestHeader -Title "Test Result"
if ($testResult) {
    Write-Host "✅ /invoke Lilith command test completed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ /invoke Lilith command test failed. Please check the output above for details." -ForegroundColor Red
}

Write-Host "`nTest completed!" -ForegroundColor Cyan
