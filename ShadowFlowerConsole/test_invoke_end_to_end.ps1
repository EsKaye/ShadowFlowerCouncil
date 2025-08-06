# Test Script: /invoke Lilith - End to End
# Verifies the end-to-end functionality of the /invoke Lilith command

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Function to test the /invoke Lilith command
function Test-InvokeLilith {
    Write-Host "Testing /invoke Lilith command..." -ForegroundColor Yellow
    
    try {
        # Call the Invoke-CouncilModule function
        $result = Invoke-CouncilModule -ModuleName "Lilith" -ErrorAction Stop
        
        # Verify the response
        if (-not $result) {
            Write-Host "❌ Error: No response from Invoke-CouncilModule" -ForegroundColor Red
            return $false
        }
        
        # Display the result
        Write-Host "✅ Successfully invoked Lilith module" -ForegroundColor Green
        
        # Format and display the message with word wrap
        $message = $result.Message -replace '(.{1,60})(\s|$)', "`$1`n"
        Write-Host "`nResponse:" -ForegroundColor Cyan
        Write-Host $message -ForegroundColor White
        
        # Display the timestamp
        $timestamp = [DateTimeOffset]::FromUnixTimeSeconds($result.Timestamp).DateTime
        Write-Host "`nTimestamp: $($timestamp.ToString("yyyy-MM-dd HH:mm:ss"))" -ForegroundColor White
        
        return $true
    } catch {
        Write-Host "❌ Error: $_" -ForegroundColor Red
        return $false
    }
}

# Main script execution
Write-Host "Starting /invoke Lilith end-to-end test..." -ForegroundColor Cyan

# Run the test
$testResult = Test-InvokeLilith

# Display test result
Write-Host "`nTest Result: " -NoNewline -ForegroundColor Cyan
if ($testResult) {
    Write-Host "✅ PASSED" -ForegroundColor Green
} else {
    Write-Host "❌ FAILED" -ForegroundColor Red
}

Write-Host "`nTest completed!" -ForegroundColor Cyan
