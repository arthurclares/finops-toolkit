<#
.SYNOPSIS
    Comprehensive validation script for Azure Cost Optimization Recommendations scripts.

.DESCRIPTION
    This script validates prerequisites, functions, and optionally runs integration tests
    for the CostRecommendations.ps1 and related scripts.

.PARAMETER IncludeIntegrationTests
    Include end-to-end integration tests that require Azure connectivity.

.PARAMETER Verbose
    Display detailed test output.

.EXAMPLE
    .\Test-CostRecommendations.ps1 -Verbose

.EXAMPLE
    .\Test-CostRecommendations.ps1 -IncludeIntegrationTests -Verbose

.NOTES
    Version: 1.0
    Author: FinOps Toolkit Team
#>

param (
    [switch]$IncludeIntegrationTests,
    [switch]$Verbose
)

# Test result tracking
$script:TestResults = @{
    Passed = 0
    Failed = 0
    Skipped = 0
    Details = @()
}

function Write-TestResult {
    param (
        [string]$Category,
        [string]$TestName,
        [string]$Status,
        [string]$Message = ""
    )
    
    $result = [PSCustomObject]@{
        Category = $Category
        TestName = $TestName
        Status = $Status
        Message = $Message
    }
    
    $script:TestResults.Details += $result
    
    switch ($Status) {
        "PASS" { 
            $script:TestResults.Passed++
            Write-Host "✓ [$Category] $TestName" -ForegroundColor Green
        }
        "FAIL" { 
            $script:TestResults.Failed++
            Write-Host "✗ [$Category] $TestName - $Message" -ForegroundColor Red
        }
        "SKIP" { 
            $script:TestResults.Skipped++
            Write-Host "○ [$Category] $TestName - $Message" -ForegroundColor Yellow
        }
    }
    
    if ($Verbose -and $Message) {
        Write-Host "  $Message" -ForegroundColor Gray
    }
}

function Test-Prerequisites {
    Write-Host "`n=== Testing Prerequisites ===" -ForegroundColor Cyan
    
    # Test 1: PowerShell version
    try {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            Write-TestResult -Category "Prerequisites" -TestName "PowerShell Version" -Status "PASS" -Message "Version $($PSVersionTable.PSVersion)"
        }
        else {
            Write-TestResult -Category "Prerequisites" -TestName "PowerShell Version" -Status "FAIL" -Message "PowerShell 7 or later required. Current: $($PSVersionTable.PSVersion)"
        }
    }
    catch {
        Write-TestResult -Category "Prerequisites" -TestName "PowerShell Version" -Status "FAIL" -Message $_.Exception.Message
    }
    
    # Test 2: Required files exist
    $requiredFiles = @(
        "CostRecommendations.ps1",
        "CostRecommendations-Prerequisites.ps1",
        "createPresentation.ps1",
        "settings.json"
    )
    
    foreach ($file in $requiredFiles) {
        $filePath = Join-Path $PSScriptRoot $file
        if (Test-Path $filePath) {
            Write-TestResult -Category "Prerequisites" -TestName "File: $file" -Status "PASS"
        }
        else {
            Write-TestResult -Category "Prerequisites" -TestName "File: $file" -Status "FAIL" -Message "File not found"
        }
    }
    
    # Test 3: settings.json validity
    try {
        $settingsPath = Join-Path $PSScriptRoot "settings.json"
        $settings = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json -ErrorAction Stop
        
        if ($settings.scriptVersion -and $settings.repositoryUrls -and $settings.paths) {
            Write-TestResult -Category "Prerequisites" -TestName "settings.json validity" -Status "PASS"
        }
        else {
            Write-TestResult -Category "Prerequisites" -TestName "settings.json validity" -Status "FAIL" -Message "Missing required properties"
        }
    }
    catch {
        Write-TestResult -Category "Prerequisites" -TestName "settings.json validity" -Status "FAIL" -Message $_.Exception.Message
    }
}

function Test-Modules {
    Write-Host "`n=== Testing Modules ===" -ForegroundColor Cyan
    
    $requiredModules = @(
        'Az.Accounts',
        'Az.ResourceGraph',
        'ImportExcel',
        'powershell-yaml'
    )
    
    foreach ($module in $requiredModules) {
        if (Get-Module -ListAvailable -Name $module) {
            Write-TestResult -Category "Modules" -TestName "Module: $module" -Status "PASS"
        }
        else {
            Write-TestResult -Category "Modules" -TestName "Module: $module" -Status "FAIL" -Message "Module not installed"
        }
    }
}

function Test-Functions {
    Write-Host "`n=== Testing Functions ===" -ForegroundColor Cyan
    
    # Load the prerequisites script
    try {
        $prerequisitesPath = Join-Path $PSScriptRoot "CostRecommendations-Prerequisites.ps1"
        . $prerequisitesPath
        Write-TestResult -Category "Functions" -TestName "Load Prerequisites Script" -Status "PASS"
    }
    catch {
        Write-TestResult -Category "Functions" -TestName "Load Prerequisites Script" -Status "FAIL" -Message $_.Exception.Message
        return
    }
    
    # Load the main script (just the functions, not execute)
    try {
        $mainScriptPath = Join-Path $PSScriptRoot "CostRecommendations.ps1"
        $scriptContent = Get-Content -Path $mainScriptPath -Raw
        
        # Extract function definitions
        $functionPattern = 'function\s+(\w+-\w+|\w+)'
        $matches = [regex]::Matches($scriptContent, $functionPattern)
        
        $expectedFunctions = @(
            'Update-Scripts',
            'Load-Settings',
            'Process-KQLFiles',
            'Process-CustomCostRecommendations',
            'Manual-Validations',
            'ConvertTo-FlatString',
            'Format-RecommendationDetails',
            'Export-ResultsToExcel',
            'Start-CostRecommendations'
        )
        
        foreach ($funcName in $expectedFunctions) {
            if ($scriptContent -match "function\s+$funcName") {
                Write-TestResult -Category "Functions" -TestName "Function defined: $funcName" -Status "PASS"
            }
            else {
                Write-TestResult -Category "Functions" -TestName "Function defined: $funcName" -Status "FAIL" -Message "Function not found"
            }
        }
    }
    catch {
        Write-TestResult -Category "Functions" -TestName "Parse Main Script" -Status "FAIL" -Message $_.Exception.Message
    }
    
    # Test prerequisite functions
    $prereqFunctions = @(
        'Write-Log',
        'Write-ParallelLog',
        'Get-SafeTempPath',
        'Check-ScriptVersion',
        'Install-AndImportModules',
        'Connect-ToAzure',
        'Download-GitHubFolder',
        'Get-Scope',
        'Get-FilePath'
    )
    
    foreach ($funcName in $prereqFunctions) {
        if (Get-Command -Name $funcName -ErrorAction SilentlyContinue) {
            Write-TestResult -Category "Functions" -TestName "Prerequisite function: $funcName" -Status "PASS"
        }
        else {
            Write-TestResult -Category "Functions" -TestName "Prerequisite function: $funcName" -Status "FAIL" -Message "Function not available"
        }
    }
}

function Test-DataTransformation {
    Write-Host "`n=== Testing Data Transformation ===" -ForegroundColor Cyan
    
    # Load the main script to get the functions
    try {
        $mainScriptPath = Join-Path $PSScriptRoot "CostRecommendations.ps1"
        . $mainScriptPath -ErrorAction SilentlyContinue
    }
    catch {
        Write-TestResult -Category "Data Transformation" -TestName "Load script for testing" -Status "FAIL" -Message $_.Exception.Message
        return
    }
    
    # Test ConvertTo-FlatString with simple string
    try {
        $result = ConvertTo-FlatString -InputObject "Simple string"
        if ($result -eq "Simple string") {
            Write-TestResult -Category "Data Transformation" -TestName "ConvertTo-FlatString: Simple string" -Status "PASS"
        }
        else {
            Write-TestResult -Category "Data Transformation" -TestName "ConvertTo-FlatString: Simple string" -Status "FAIL" -Message "Unexpected result: $result"
        }
    }
    catch {
        Write-TestResult -Category "Data Transformation" -TestName "ConvertTo-FlatString: Simple string" -Status "FAIL" -Message $_.Exception.Message
    }
    
    # Test ConvertTo-FlatString with JSON string
    try {
        $jsonString = '{"key1":"value1","key2":"value2"}'
        $result = ConvertTo-FlatString -InputObject $jsonString
        if ($result -like "*key1*" -and $result -like "*value1*") {
            Write-TestResult -Category "Data Transformation" -TestName "ConvertTo-FlatString: JSON string" -Status "PASS"
        }
        else {
            Write-TestResult -Category "Data Transformation" -TestName "ConvertTo-FlatString: JSON string" -Status "FAIL" -Message "JSON not parsed correctly"
        }
    }
    catch {
        Write-TestResult -Category "Data Transformation" -TestName "ConvertTo-FlatString: JSON string" -Status "FAIL" -Message $_.Exception.Message
    }
    
    # Test ConvertTo-FlatString with nested object
    try {
        $obj = [PSCustomObject]@{
            Level1 = "Value1"
            Level2 = @{
                Nested = "NestedValue"
            }
        }
        $result = ConvertTo-FlatString -InputObject $obj
        if ($result -like "*Level1*" -and $result -like "*Value1*") {
            Write-TestResult -Category "Data Transformation" -TestName "ConvertTo-FlatString: Nested object" -Status "PASS"
        }
        else {
            Write-TestResult -Category "Data Transformation" -TestName "ConvertTo-FlatString: Nested object" -Status "FAIL" -Message "Nested object not flattened"
        }
    }
    catch {
        Write-TestResult -Category "Data Transformation" -TestName "ConvertTo-FlatString: Nested object" -Status "FAIL" -Message $_.Exception.Message
    }
    
    # Test Format-RecommendationDetails with reservation JSON
    try {
        $reservationJson = '{"recommendationOfferingId":"07649cbd-2ee4-4992-898b-f5f16bad1b36","recommendationSubCategory":"Reservations","reservedResourceType":"virtualmachines","targetResourceCount":"6","annualSavingsAmount":"1591","savingsCurrency":"USD","lookbackPeriod":"60","savingsAmount":"132","region":"eastus2","displayQty":"6","displaySKU":"Standard_D2a_v4","location":"eastus2","vmSize":"Standard_D2a_v4","scope":"Single","subId":"1d57df7d-7b6d-48bf-bc08-cc534305288e","term":"P1Y","sku":"Standard_D2a_v4","qty":"6"}'
        $result = Format-RecommendationDetails -Details $reservationJson
        
        $expectedParts = @("Type:", "SKU:", "Location:", "Quantity:", "Term:", "Annual Savings:")
        $allFound = $true
        foreach ($part in $expectedParts) {
            if ($result -notlike "*$part*") {
                $allFound = $false
                break
            }
        }
        
        if ($allFound -and $result -notlike "*{*") {
            Write-TestResult -Category "Data Transformation" -TestName "Format-RecommendationDetails: Reservation JSON" -Status "PASS"
        }
        else {
            Write-TestResult -Category "Data Transformation" -TestName "Format-RecommendationDetails: Reservation JSON" -Status "FAIL" -Message "Expected format not found. Result: $result"
        }
    }
    catch {
        Write-TestResult -Category "Data Transformation" -TestName "Format-RecommendationDetails: Reservation JSON" -Status "FAIL" -Message $_.Exception.Message
    }
    
    # Test Format-RecommendationDetails with empty/null input
    try {
        $result1 = Format-RecommendationDetails -Details $null
        $result2 = Format-RecommendationDetails -Details ""
        
        if ($result1 -eq "" -and $result2 -eq "") {
            Write-TestResult -Category "Data Transformation" -TestName "Format-RecommendationDetails: Null/Empty handling" -Status "PASS"
        }
        else {
            Write-TestResult -Category "Data Transformation" -TestName "Format-RecommendationDetails: Null/Empty handling" -Status "FAIL" -Message "Should return empty string"
        }
    }
    catch {
        Write-TestResult -Category "Data Transformation" -TestName "Format-RecommendationDetails: Null/Empty handling" -Status "FAIL" -Message $_.Exception.Message
    }
}

function Test-AzureConnectivity {
    Write-Host "`n=== Testing Azure Connectivity ===" -ForegroundColor Cyan
    
    if (-not $IncludeIntegrationTests) {
        Write-TestResult -Category "Azure Connectivity" -TestName "Azure Connection" -Status "SKIP" -Message "Use -IncludeIntegrationTests to enable"
        Write-TestResult -Category "Azure Connectivity" -TestName "Context Validation" -Status "SKIP" -Message "Use -IncludeIntegrationTests to enable"
        return
    }
    
    # Test Azure connection
    try {
        $context = Get-AzContext -ErrorAction Stop
        if ($context) {
            Write-TestResult -Category "Azure Connectivity" -TestName "Azure Connection" -Status "PASS" -Message "Connected to: $($context.Subscription.Name)"
        }
        else {
            Write-TestResult -Category "Azure Connectivity" -TestName "Azure Connection" -Status "FAIL" -Message "Not connected to Azure"
        }
    }
    catch {
        Write-TestResult -Category "Azure Connectivity" -TestName "Azure Connection" -Status "FAIL" -Message $_.Exception.Message
    }
    
    # Test context validation
    try {
        $context = Get-AzContext -ErrorAction Stop
        if ($context.Subscription -and $context.Account) {
            Write-TestResult -Category "Azure Connectivity" -TestName "Context Validation" -Status "PASS"
        }
        else {
            Write-TestResult -Category "Azure Connectivity" -TestName "Context Validation" -Status "FAIL" -Message "Invalid context"
        }
    }
    catch {
        Write-TestResult -Category "Azure Connectivity" -TestName "Context Validation" -Status "FAIL" -Message $_.Exception.Message
    }
}

function Test-Integration {
    Write-Host "`n=== Testing Integration ===" -ForegroundColor Cyan
    
    if (-not $IncludeIntegrationTests) {
        Write-TestResult -Category "Integration" -TestName "End-to-End Workflow" -Status "SKIP" -Message "Use -IncludeIntegrationTests to enable"
        return
    }
    
    Write-Host "Integration tests require manual execution of the main script." -ForegroundColor Yellow
    Write-TestResult -Category "Integration" -TestName "End-to-End Workflow" -Status "SKIP" -Message "Manual test required"
}

function Show-Summary {
    Write-Host "`n=== Test Summary ===" -ForegroundColor Cyan
    Write-Host "Passed:  $($script:TestResults.Passed)" -ForegroundColor Green
    Write-Host "Failed:  $($script:TestResults.Failed)" -ForegroundColor Red
    Write-Host "Skipped: $($script:TestResults.Skipped)" -ForegroundColor Yellow
    Write-Host "Total:   $($script:TestResults.Details.Count)"
    
    if ($script:TestResults.Failed -gt 0) {
        Write-Host "`nFailed Tests:" -ForegroundColor Red
        $script:TestResults.Details | Where-Object { $_.Status -eq "FAIL" } | ForEach-Object {
            Write-Host "  [$($_.Category)] $($_.TestName): $($_.Message)" -ForegroundColor Red
        }
    }
    
    # Return exit code based on failures
    if ($script:TestResults.Failed -gt 0) {
        Write-Host "`n❌ Tests FAILED" -ForegroundColor Red
        exit 1
    }
    else {
        Write-Host "`n✓ All tests PASSED" -ForegroundColor Green
        exit 0
    }
}

# Main execution
Write-Host @"
╔════════════════════════════════════════════════════════════╗
║  Azure Cost Optimization Recommendations - Test Suite     ║
╚════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Test-Prerequisites
Test-Modules
Test-Functions
Test-DataTransformation
Test-AzureConnectivity
Test-Integration
Show-Summary
