<#
.SYNOPSIS
  Utilities for ShadowFlower Console dispatcher.

.DESCRIPTION
  Provides helpers to locate module paths and produce a simple response
  from a module folder by sampling its local content.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Find-ModulePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModuleName
    )

    # Normalize names: allow e.g. "Lilith" or "Lilith.Eve" or "Aphrodite" -> directory match
    $root = $PSScriptRoot
    $targetNames = @($ModuleName, ($ModuleName -replace '\.exe$', ''), ("$ModuleName" -replace '\.exe$', ''))

    foreach ($dir in Get-ChildItem -Path $root -Directory) {
        foreach ($cand in $targetNames) {
            if ($dir.Name -ieq $cand) {
                return $dir.FullName
            }
        }
    }
    return $null
}

function Get-ModuleResponse {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModulePath
    )

    # Prefer an invocation summary from @memories.md, else README.md, else a default line
    $mem = Join-Path $ModulePath '@memories.md'
    $readme = Join-Path $ModulePath 'README.md'

    if (Test-Path $mem) {
        $lines = Get-Content -Path $mem -ErrorAction SilentlyContinue | Select-Object -First 3
        if ($lines) { return ($lines -join " ").Trim() }
    }

    if (Test-Path $readme) {
        $lines = Get-Content -Path $readme -ErrorAction SilentlyContinue | Select-Object -First 3
        if ($lines) { return ($lines -join " ").Trim() }
    }

    return "The temple is quiet, but the presence is felt."
}

Export-ModuleMember -Function Find-ModulePath, Get-ModuleResponse

