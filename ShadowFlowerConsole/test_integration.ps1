# Test Integration Script for ShadowFlower Council
# This script tests the core functionality without relying on the main sf.ps1

# Configuration
$webhookUrl = "https://discord.com/api/webhooks/1402746967444160552/Mztx-jZI6DRB3Dp4xmBHOFaQn77jkEPiw9TutP3gfL0yqO07BAcUs9JtDk6Vq1P5iBlN"
$moduleName = "Lilith.Eve"

# Import required modules
. "$PSScriptRoot\module_utils.ps1"
. "$PSScriptRoot\dispatcher.ps1"

Write-Host "🔄 Testing ShadowFlower Council Integration" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Test 1: Check if module exists
Write-Host "🔍 Checking if module '$moduleName' exists..." -NoNewline
$modulePath = Find-ModulePath -ModuleName $moduleName
if ($modulePath) {
    Write-Host " ✅" -ForegroundColor Green
    Write-Host "   Module path: $modulePath" -ForegroundColor DarkGray
} else {
    Write-Host " ❌" -ForegroundColor Red
    Write-Host "Module '$moduleName' not found. Please check the module name and try again." -ForegroundColor Red
    exit 1
}

# Test 2: Get module response
Write-Host "📨 Getting response from module..." -NoNewline
try {
    $response = Invoke-CouncilModule -ModuleName $moduleName
    Write-Host " ✅" -ForegroundColor Green
    Write-Host "   Module: $($response.Module)" -ForegroundColor DarkGray
    Write-Host "   Message: $($response.Message)" -ForegroundColor DarkGray
} catch {
    Write-Host " ❌" -ForegroundColor Red
    Write-Host "   Error: $_" -ForegroundColor Red
    exit 1
}

# Test 3: Send message to Discord
Write-Host "📤 Sending message to Discord..." -NoNewline
try {
    $message = "✨ **$($response.Module) responds:**`n> *$($response.Message)*"
    $payload = @{
        content = $message
        username = "ShadowFlower Council"
        avatar_url = "https://i.imgur.com/6x5wJ9N.png"
    } | ConvertTo-Json -Depth 10

    $response = Invoke-RestMethod -Uri $webhookUrl `
        -Method Post `
        -Body $payload `
        -ContentType 'application/json; charset=utf-8' `
        -ErrorAction Stop
    
    Write-Host " ✅" -ForegroundColor Green
    Write-Host "✅ Integration test completed successfully!" -ForegroundColor Green
    Write-Host "   Check your Discord channel for the message from $moduleName" -ForegroundColor Cyan
} catch {
    Write-Host " ❌" -ForegroundColor Red
    Write-Host "   Error sending to Discord: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.ErrorDetails.Message) {
        Write-Host "   Details: $($_.ErrorDetails.Message)" -ForegroundColor DarkGray
    }
    exit 1
}
