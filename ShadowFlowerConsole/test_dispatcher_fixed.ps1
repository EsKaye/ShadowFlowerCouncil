# Test Script for Dispatcher - Fixed
# Verifies the core functionality of the dispatcher.ps1 script with correct PowerShell syntax

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

# Function to test Get-CouncilStatus
function TestGetCouncilStatus {
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
        return $true
    } catch {
        Write-Host "❌ Error getting council status: $_" -ForegroundColor Red
        return $false
    }
}

# Function to test Invoke-CouncilModule
function TestInvokeCouncilModule {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ModuleName
    )
    
    ShowTestHeader -Title ("Testing Invoke-CouncilModule for {0}" -f $ModuleName)
    
    try {
        $result = Invoke-CouncilModule -ModuleName $ModuleName -Verbose -ErrorAction Stop
        
        Write-Host "✅ Successfully invoked module: $($result.Module)" -ForegroundColor Green
        Write-Host ("- Response: {0}" -f $result.Message) -ForegroundColor White
        
        $timestamp = [DateTimeOffset]::FromUnixTimeSeconds($result.Timestamp).DateTime
        Write-Host ("- Timestamp: {0}" -f ($timestamp.ToString("yyyy-MM-dd HH:mm:ss"))) -ForegroundColor White
        
        return $true
    } catch {
        Write-Host "❌ Error invoking $ModuleName module: $_" -ForegroundColor Red
        return $false
    }
}

# Function to test Sync-CouncilMemories
function TestSyncCouncilMemories {
    ShowTestHeader -Title "Testing Sync-CouncilMemories"
    
    try {
        $result = Sync-CouncilMemories -Verbose -ErrorAction Stop
        Write-Host "✅ $result" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "❌ Error syncing memories: $_" -ForegroundColor Red
        return $false
    }
}

# Main test function
function RunAllTests {
    ShowTestHeader -Title "Testing ShadowFlower Council Dispatcher"
    
    $testResults = @{
        Status = TestGetCouncilStatus
        Invoke = TestInvokeCouncilModule -ModuleName "Lilith"
        Sync = TestSyncCouncilMemories
    }
    
    # Display test summary
    ShowTestHeader -Title "Test Summary"
    
    $totalTests = $testResults.Count
    $passedTests = ($testResults.Values | Where-Object { $_ -eq $true }).Count
    $failedTests = $totalTests - $passedTests
    
    Write-Host ("✅ {0}/{1} tests passed" -f $passedTests, $totalTests) -ForegroundColor Green
    
    if ($failedTests -gt 0) {
        Write-Host ("❌ {0} tests failed" -f $failedTests) -ForegroundColor Red
    }
    
    Write-Host "`n🏁 Dispatcher test completed!" -ForegroundColor Cyan
}

# Execute all tests
RunAllTests
