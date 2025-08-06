# Dispatcher for ShadowFlower Council
# Routes invocations to the appropriate module and handles responses

# Import module utilities
. "$PSScriptRoot\module_utils.ps1"

<#
.SYNOPSIS
    Invokes a specific council module and returns its response.
.DESCRIPTION
    This function locates the specified module, retrieves a response from it,
    and returns the result in a structured format.
.PARAMETER ModuleName
    The name of the module to invoke (e.g., "Lilith" or "Lilith.Eve").
#>
function Invoke-CouncilModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$ModuleName
    )
    
    try {
        Write-Verbose "Invoking module: $ModuleName"
        
        # Normalize module name (handle Lilith.Eve case)
        $modulePath = Find-ModulePath -ModuleName $ModuleName
        
        if (-not $modulePath) {
            $errorMsg = "The requested module '$ModuleName' was not found in the Council."
            Write-Warning $errorMsg
            
            return @{
                Module = "ShadowFlower Council"
                Message = $errorMsg
                Timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
            }
        }
        
        Write-Verbose "Found module at path: $modulePath"
        
        # Get module response
        $response = Get-ModuleResponse -ModulePath $modulePath
        
        $result = @{
            Module = (Get-Item $modulePath).BaseName
            Message = $response
            Timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
        }
        
        Write-Verbose ("Module response: {0}" -f ($result | ConvertTo-Json -Compress))
        return $result
        
    } catch {
        $errorMsg = "Error in Invoke-CouncilModule: $_"
        Write-Error $errorMsg
        
        return @{
            Module = "ShadowFlower Council"
            Message = "An error occurred while processing your request: $_"
            Timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
            Error = $errorMsg
        }
    }
}

<#
.SYNOPSIS
    Gets the status of all council modules.
.DESCRIPTION
    This function retrieves status information about all available council modules,
    including their last modified times and whether they have memories or lessons.
#>
function Get-CouncilStatus {
    [CmdletBinding()]
    param()
    
    try {
        Write-Verbose "Getting status of all council modules"
        
        $modules = Get-ChildItem -Path $PSScriptRoot -Directory | 
                   Where-Object { $_.Name -ne 'handlers' -and $_.Name -ne '__pycache__' }
        
        $status = @{
            TotalModules = $modules.Count
            ActiveModules = 0
            LastSync = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            Modules = @()
        }
        
        foreach ($module in $modules) {
            $moduleStatus = @{
                Name = $module.Name
                LastModified = (Get-ChildItem -Path $module.FullName -File | 
                              Sort-Object LastWriteTime -Descending | 
                              Select-Object -First 1).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                HasMemories = Test-Path "$($module.FullName)\@memories.md"
                HasLessons = Test-Path "$($module.FullName)\@lessons-learned.md"
            }
            
            if ($moduleStatus.HasMemories -or $moduleStatus.HasLessons) {
                $status.ActiveModules++
            }
            
            $status.Modules += $moduleStatus
        }
        
        Write-Verbose ("Council status: {0} modules total, {1} active" -f $status.TotalModules, $status.ActiveModules)
        return $status
        
    } catch {
        $errorMsg = "Error in Get-CouncilStatus: $_"
        Write-Error $errorMsg
        
        return @{
            TotalModules = 0
            ActiveModules = 0
            LastSync = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            Error = $errorMsg
        }
    }
}

<#
.SYNOPSIS
    Synchronizes memories across all council modules.
.DESCRIPTION
    This function will eventually implement logic to synchronize memories
    across all council modules, but currently returns a placeholder message.
#>
function Sync-CouncilMemories {
    [CmdletBinding()]
    param()
    
    try {
        Write-Verbose "Synchronizing council memories"
        
        # TODO: Implement memory synchronization logic
        $result = "Memories synchronized across all Council modules."
        Write-Verbose $result
        
        return $result
        
    } catch {
        $errorMsg = "Error in Sync-CouncilMemories: $_"
        Write-Error $errorMsg
        
        return "Failed to synchronize memories: $_"
    }
}

# Only export functions if this is being run as a module
if ($MyInvocation.MyCommand.CommandType -eq 'ExternalScript') {
    # This script is being dot-sourced, don't export functions
    Write-Verbose "Script is being dot-sourced, not exporting functions"
} else {
    # This script is being imported as a module, export the functions
    $functionsToExport = @(
        'Invoke-CouncilModule',
        'Get-CouncilStatus',
        'Sync-CouncilMemories'
    )
    Export-ModuleMember -Function $functionsToExport
}
