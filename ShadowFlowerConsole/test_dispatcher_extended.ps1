# Test Dispatcher - Extended
# This script tests the dispatcher with extended functionality

# Import the dispatcher functions
. "$PSScriptRoot\dispatcher.ps1"

# Function to display test header
function ShowTestHeader {
    param([string]$Title)
    Write-Host "`n$('=' * 60)" -ForegroundColor Cyan
    Write-Host "🔍 $Title" -ForegroundColor Cyan
    Write-Host "$('=' * 60)" -ForegroundColor Cyan
}

# Test 1: Basic script execution
Write-Host "✅ Script loaded successfully" -ForegroundColor Green

# Test 2: Get Council Status
ShowTestHeader -Title "Testing Get-CouncilStatus"

try {
    $status = Get-CouncilStatus -ErrorAction Stop
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

# Test 3: Invoke Lilith Module
ShowTestHeader -Title "Testing Invoke-CouncilModule for Lilith"

try {
    $result = Invoke-CouncilModule -ModuleName "Lilith" -ErrorAction Stop
    Write-Host "✅ Successfully invoked module: $($result.Module)" -ForegroundColor Green
    Write-Host ("- Response: {0}" -f $result.Message) -ForegroundColor White
    
    $timestamp = [DateTimeOffset]::FromUnixTimeSeconds($result.Timestamp).DateTime
    Write-Host ("- Timestamp: {0}" -f ($timestamp.ToString("yyyy-MM-dd HH:mm:ss"))) -ForegroundColor White
} catch {
    Write-Host "❌ Error invoking Lilith module: $_" -ForegroundColor Red
}

Write-Host "`n🏁 Test completed!" -ForegroundColor Cyan
