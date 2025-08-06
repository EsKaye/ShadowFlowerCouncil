# Test script for Discord webhook

$webhookUrl = "https://discord.com/api/webhooks/1402746967444160552/Mztx-jZI6DRB3Dp4xmBHOFaQn77jkEPiw9TutP3gfL0yqO07BAcUs9JtDk6Vq1P5iBlN"
$message = "✨ **Lilith.Eve responds:**`n> *Testing Discord webhook integration. The Council is watching...*"

# Prepare the message payload
$payload = @{
    content = $message
    username = "ShadowFlower Council"
    avatar_url = "https://i.imgur.com/6x5wJ9N.png"
    tts = $false
} | ConvertTo-Json -Depth 10

try {
    # Send the webhook
    $response = Invoke-RestMethod -Uri $webhookUrl `
        -Method Post `
        -Body $payload `
        -ContentType 'application/json; charset=utf-8' `
        -ErrorAction Stop
    
    Write-Host "✅ Message sent successfully!" -ForegroundColor Green
    Write-Host "Response: $($response | ConvertTo-Json -Compress)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Error sending message:" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    Write-Host "Status Description: $($_.Exception.Response.StatusDescription)" -ForegroundColor Red
    
    if ($_.ErrorDetails.Message) {
        try {
            $errorDetails = $_.ErrorDetails.Message | ConvertFrom-Json
            Write-Host "Error Details:" -ForegroundColor Yellow
            $errorDetails | Format-List | Out-String | Write-Host -ForegroundColor Yellow
        } catch {
            Write-Host "Raw Error Details:" -ForegroundColor Yellow
            Write-Host $_.ErrorDetails.Message -ForegroundColor Yellow
        }
    }
    
    Write-Host "`nFull Exception:" -ForegroundColor Red
    Write-Host $_.Exception -ForegroundColor Red
}
