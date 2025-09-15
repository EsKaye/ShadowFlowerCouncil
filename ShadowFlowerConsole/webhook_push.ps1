<#
.SYNOPSIS
  Post a message to a Discord webhook.

.PARAMETER WebhookUrl
  Discord webhook URL. If not provided, falls back to the DISCORD_WEBHOOK_COUNCIL
  environment variable or the value in council_config.json (if present).

.PARAMETER Message
  Message content to send. Supports basic Markdown.

.PARAMETER AuthToken
  Optional token for upstream validation. Currently not enforced.
#>

param(
    [Parameter(Mandatory=$false)] [string]$WebhookUrl,
    [Parameter(Mandatory=$true)] [string]$Message,
    [Parameter(Mandatory=$false)] [string]$AuthToken
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-DiscordWebhook {
    param([string]$explicit)

    if ($explicit) { return $explicit }
    if ($env:DISCORD_WEBHOOK_COUNCIL) { return $env:DISCORD_WEBHOOK_COUNCIL }

    $cfg = Join-Path $PSScriptRoot 'council_config.json'
    if (Test-Path $cfg) {
        try {
            $json = Get-Content -Raw -Path $cfg | ConvertFrom-Json
            if ($json.DiscordWebhookUrl -and $json.DiscordWebhookUrl -notmatch 'REDACTED|PLACEHOLDER|^$') {
                return [string]$json.DiscordWebhookUrl
            }
        } catch { }
    }
    return $null
}

$url = Get-DiscordWebhook -explicit $WebhookUrl
if (-not $url) {
    Write-Output (@{ success = $false; error = 'No Discord webhook configured'; code = 'NO_WEBHOOK' } | ConvertTo-Json -Compress)
    exit 0
}

try {
    $payload = @{ content = $Message }
    $resp = Invoke-RestMethod -Method Post -Uri $url -ContentType 'application/json' -Body ($payload | ConvertTo-Json -Compress)
    Write-Output (@{ success = $true } | ConvertTo-Json -Compress)
} catch {
    Write-Output (@{ success = $false; error = $_.Exception.Message } | ConvertTo-Json -Compress)
}

