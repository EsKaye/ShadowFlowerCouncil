# Verbose Test Script for Invoke-CouncilModule
# This script tests the Invoke-CouncilModule function with detailed output

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Function to display a header
function Write-Header {
    param([string]$Title)
    $line = "=" * 60
    Write-Host "`n$line" -ForegroundColor Cyan
    Write-Host "🔍 $Title" -ForegroundColor Cyan
    Write-Host $line -ForegroundColor Cyan
}

# Main test function
function Test-InvokeModule {
    param([string]$ModuleName = "Lilith")
    
    Write-Header -Title "Testing Invoke-CouncilModule for $ModuleName"
    
    try {
        # Call the function with detailed output
        Write-Host "Invoking module '$ModuleName'..." -ForegroundColor Yellow
        $result = Invoke-CouncilModule -ModuleName $ModuleName -ErrorAction Stop -Verbose
        
        # Display the result
        Write-Host "✅ Successfully invoked module: $($result.Module)" -ForegroundColor Green
        
        # Format and display the response with word wrap
        $message = $result.Message -replace '(.{1,80})(\s|$)', "`$1`n"
        Write-Host "`nResponse:" -ForegroundColor Cyan
        Write-Host $message -ForegroundColor White
        
        # Display the timestamp
        $timestamp = [DateTimeOffset]::FromUnixTimeSeconds($result.Timestamp).DateTime
        Write-Host "`nTimestamp: $($timestamp.ToString("yyyy-MM-dd HH:mm:ss"))" -ForegroundColor White
        
        return $true
    } catch {
        Write-Host "❌ Error invoking module '$ModuleName': $_" -ForegroundColor Red
        return $false
    }
}

# Execute the test
$testResult = Test-InvokeModule -ModuleName "Lilith"

# Display test result
Write-Header -Title "Test Result"
if ($testResult) {
    Write-Host "✅ Test completed successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Test failed. Please check the output above for details." -ForegroundColor Red
}

Write-Host "`nTest completed!" -ForegroundColor Cyan
