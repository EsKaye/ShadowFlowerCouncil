# Discord Sync Handler for ShadowFlower Council
# Handles incoming Discord webhook commands and dispatches to appropriate modules

param(
    [Parameter(Mandatory=$true)]
    [string]$Command,
    
    [string]$Module = "",
    [string]$WebhookUrl = "",
    [string]$AuthToken = ""
)

# Import core configuration and utilities
$script:CONSOLE_ROOT = Split-Path -Parent $PSScriptRoot
. "$PSScriptRoot\..\dispatcher.ps1"
. "$PSScriptRoot\..\webhook_push.ps1"

# Validate authentication token
function Test-AuthToken {
    param([string]$token)
    # TODO: Implement proper token validation
    return $true
}

# Main handler for Discord commands
function Invoke-DiscordCommand {
    param(
        [string]$command,
        [string]$module,
        [string]$webhookUrl,
        [string]$authToken
    )

    # Verify authentication
    if (-not (Test-AuthToken -token $authToken)) {
        return @{
            content = "🔒 *Authentication failed. Your token is invalid or expired.*"
            ephemeral = $true
        }
    }

    # Process the command
    switch ($command.ToLower()) {
        "invoke" {
            if ([string]::IsNullOrEmpty($module)) {
                return @{
                    content = "❌ *Please specify a module to invoke. Example: `/invoke Lilith`*"
                    ephemeral = $true
                }
            }
            
            $response = Invoke-CouncilModule -ModuleName $module
            $message = "✨ **$($response.Module) responds:**`n> *$($response.Message)*"
            
            # Send the message via webhook
            $webhookResult = & "$PSScriptRoot\..\webhook_push.ps1" -WebhookUrl $webhookUrl -Message $message -AuthToken $authToken
            
            return @{
                success = $webhookResult.success
                content = if ($webhookResult.success) { $message } else { "Failed to send message to Discord: $($webhookResult.error)" }
                ephemeral = $false
            }
        }
        
        "status" {
            if ($module -eq "council") {
                $status = Get-CouncilStatus
                return @{
                    content = "🌙 **Council Status**`n$($status | Format-List -Property * | Out-String)"
                    ephemeral = $false
                }
            }
        }
        
        "sync" {
            if ($module -eq "memories") {
                $result = Sync-CouncilMemories
                return @{
                    content = "🔄 *$result*"
                    ephemeral = $false
                }
            }
        }
        
        default {
            return @{
                content = "❓ *Unknown command. Available commands: `/invoke [module]`, `/status council`, `/sync memories`*"
                ephemeral = $true
            }
        }
    }
}

# Process the command
$response = Invoke-DiscordCommand -command $Command -module $Module -webhookUrl $WebhookUrl -authToken $AuthToken

# Return the response as JSON
$response | ConvertTo-Json -Compress
