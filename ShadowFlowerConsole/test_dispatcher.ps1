# Test Script for Dispatcher
# Verifies the core functionality of the dispatcher.ps1 script

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Function to display test header
function ShowTestHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title
    )
    
    Write-Host "`n$('=' * 60)" -ForegroundColor Cyan
    Write-Host "🔍 $Title" -ForegroundColor Cyan
    Write-Host "$('=' * 60)" -ForegroundColor Cyan
}

# Main test function
function TestDispatcher {
    [CmdletBinding()]
    param()
    
    ShowTestHeader -Title "Testing ShadowFlower Council Dispatcher"
    
    # Test 1: Get Council Status
    ShowTestHeader -Title "Testing Get-CouncilStatus"
    
    try {
        $status = Get-CouncilStatus -Verbose -ErrorAction Stop
        
        Write-Host "✅ Successfully retrieved council status" -ForegroundColor Green
        Write-Host ("- Total Modules: {0}" -f $status.TotalModules) -ForegroundColor White
        Write-Host ("- Active Modules: {0}" -f $status.ActiveModules) -ForegroundColor White
        Write-Host ("- Last Sync: {0}" -f $status.LastSync) -ForegroundColor White
        
        if ($status.Modules.Count -gt 0) {
            Write-Host "`n📋 Module Status:" -ForegroundColor Cyan
            foreach ($module in $status.Modules) {
                $memories = if ($module.HasMemories) { "✅" } else { "❌" }
                $lessons = if ($module.HasLessons) { "✅" } else { "❌" }
                
                Write-Host ("- {0,-15} Memories: {1,-3} Lessons: {2,-3} Last Modified: {3}" -f 
                    $module.Name, $memories, $lessons, $module.LastModified) -ForegroundColor White
            }
        }
    } catch {
        Write-Host "❌ Error getting council status: $_" -ForegroundColor Red
    }

    # Test 2: Invoke Lilith Module
    ShowTestHeader -Title "Testing Invoke-CouncilModule for Lilith"
    
    try {
        $result = Invoke-CouncilModule -ModuleName "Lilith" -Verbose -ErrorAction Stop
        
        Write-Host "✅ Successfully invoked module: $($result.Module)" -ForegroundColor Green
        Write-Host ("- Response: {0}" -f $result.Message) -ForegroundColor White
        
        $timestamp = [DateTimeOffset]::FromUnixTimeSeconds($result.Timestamp).DateTime
        Write-Host ("- Timestamp: {0}" -f ($timestamp.ToString("yyyy-MM-dd HH:mm:ss"))) -ForegroundColor White
    } catch {
        Write-Host "❌ Error invoking Lilith module: $_" -ForegroundColor Red
    }

    # Test 3: Sync Memories (placeholder)
    ShowTestHeader -Title "Testing Sync-CouncilMemories"
    
    try {
        $result = Sync-CouncilMemories -Verbose -ErrorAction Stop
        Write-Host "✅ $result" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error syncing memories: $_" -ForegroundColor Red
    }
    
    Write-Host "`n🏁 Dispatcher test completed!" -ForegroundColor Cyan
}

# Execute the tests
TestDispatcher
