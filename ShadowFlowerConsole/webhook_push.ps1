# Webhook Push Module for ShadowFlower Council
# Handles sending messages to Discord webhooks

param(
    [Parameter(Mandatory=$true)]
    [string]$WebhookUrl,
    
    [Parameter(Mandatory=$true)]
    [string]$Message,
    
    [string]$Username = "ShadowFlower Council",
    
    [string]$AvatarUrl = "https://i.imgur.com/6x5wJ9N.png",
    
    [switch]$TTS = $false,
    
    [string]$AuthToken = ""
)

# Prepare the message payload
$payload = @{
    content = $Message
    username = $Username
    avatar_url = $AvatarUrl
    tts = $TTS
}

# Add auth token if provided
if (-not [string]::IsNullOrEmpty($AuthToken)) {
    $payload['auth_token'] = $AuthToken
}

try {
    # Convert to JSON with proper formatting
    $jsonBody = $payload | ConvertTo-Json -Compress -Depth 10 -EscapeHandling Default
    
    # Send the webhook
    $response = Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $jsonBody -ContentType 'application/json' -ErrorAction Stop
    
    # Log success
    return @{
        success = $true
        message = "Message sent successfully"
        response = $response
    }
} catch {
    # Log error
    return @{
        success = $false
        error = $_.Exception.Message
        response = $_.ErrorDetails.Message
    }
}
