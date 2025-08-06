# Test Dispatcher - Part 1
# Testing the Show-TestHeader function and basic structure

# Function to display test header
function Show-TestHeader {
    param([string]$Title)
    
    Write-Host "`n$('=' * 60)" -ForegroundColor Cyan
    Write-Host "🔍 $Title" -ForegroundColor Cyan
    Write-Host "$('=' * 60)" -ForegroundColor Cyan
}

# Test the function
Show-TestHeader -Title "Test Header Function"
Write-Host "✅ Test completed successfully!" -ForegroundColor Green
