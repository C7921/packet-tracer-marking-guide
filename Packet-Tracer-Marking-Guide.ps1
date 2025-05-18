<#
.SYNOPSIS
    Packet Tracer Assignment Evaluation Tool - With Command Reference
.DESCRIPTION
    Script guides markers through evaluating student Packet Tracer submissions.
    Expanded details for instructions and command references for Packet Tracer.
.NOTES
    Version: 2.0
#>

# Import Modules
# Import-Module .\PT-Core.psm1
# Import-Module .\PT-UI.psm1
# Import-Module .\PT-Evaluation.psm1
# Import-Module .\PT-Reference.psm1
# Import-Module .\PT-Reporting.psm1

# $modulePath = Join-Path -Path $PSScriptRoot -ChildPath "Modules" 

# Import all modules in the Modules directory
function Import-Module{
    param([string]$moduleName)

    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath "Modules\$ModuleName.psm1"

    Write-Host "Importing module: $modulePath" -ForegroundColor Green

    if(Test-Path $modulePath) {
       try {
        Import-Module $modulePath -Force -DisableNameChecking
        Write-Host "Successfully imported module: $modulePath" -ForegroundColor Green
        return $true
       } catch {
        Write-Host "Error importing module: $modulePath" -ForegroundColor Red
        return $false
       }
    } else {
        Write-Host "Module not found: $modulePath" -ForegroundColor Red
        return $false
    }
}

# Load Modules
$modulesLoaded  = $true
$modulesLoaded = $modulesLoaded -and (Import-Module -ModuleName "PT-Core")
$modulesLoaded = $modulesLoaded -and (Import-Module -ModuleName "PT-UI")
$modulesLoaded = $modulesLoaded -and (Import-Module -ModuleName "PT-Evaluation")
$modulesLoaded = $modulesLoaded -and (Import-Module -ModuleName "PT-Reference")
$modulesLoaded = $modulesLoaded -and (Import-Module -ModuleName "PT-Reporting")

# Final check - make sure loaded correctly
if(-not $modulesLoaded) {
    Write-Host "One or more modules failed to load. Exiting..." -ForegroundColor Red
    Exit 1
}


function Show-MainMenu {
    Initialise-Template
    
    do {
        Clear-Host
        Write-Header "Packet Tracer Evaluation Menu"
        Write-Info "Current Template: $($script:config.TemplateName)"
        
        # Display menu sections
        Show-AssessmentOptions
        Show-ReportingOptions  
        Show-ReferenceOptions
        
        # Get choice
        Write-Host ""
        Write-Host "  Select an option (0-14): " -ForegroundColor Yellow -NoNewline
        $choice = Read-Host
        
        # Process choice
        $continuePrompt = Process-MenuChoice -Choice $choice
        
        # Show continue
        if ($continuePrompt) {
            Write-Host ""
            Write-Host "  Press any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    } while ($choice -ne "0")
}

# Display assessment options
function Show-AssessmentOptions {
    Write-SubHeader "Assessment Options"
    Write-Info "1. Initialise new evaluation"
    Write-Info "2. Site Creation and Structure"
    Write-Info "3. Internal Site Connectivity"
    Write-Info "4. Data Centre Configuration"
    Write-Info "5. WAN Connectivity"
    Write-Info "6. Intermediate Device Configuration"
    Write-Info "7. Web Server Access"
    Write-Info "8. Overall Implementation and Design"
}

# Display reporting options
function Show-ReportingOptions {
    Write-SubHeader "Reporting Options"
    Write-Info "9. Generate Summary Report"
    Write-Info "10. Export Report to File"
    Write-Info "11. Preview Report"
}

# Display reference options
function Show-ReferenceOptions {
    Write-SubHeader "Reference & Help"
    Write-Info "12. Show Command Reference"
    Write-Info "13. Show Star Rating Guide"
    Write-Info "14. Load Different Template"
    Write-Info "0. Exit"
}

# Initialise template
function Initialise-Template {
    if (-not $script:config -or -not $script:config.TemplateName) {
        $defaultTemplatePath = Join-Path -Path $PSScriptRoot -ChildPath "Templates\Default(2270).json"
        if (Test-Path $defaultTemplatePath) {
            Load-AssessmentTemplate -Path $defaultTemplatePath
        }
    }
}

# Process menu choice
function Process-MenuChoice {
    param([string]$Choice)
    
    # Default to continue prompt
    $showContinuePrompt = $true
    
    switch ($Choice) {
        # Assessment
        "1" { Initialise-Evaluation }
        "2" { Invoke-CategoryEvaluation -CategoryID "SiteCreation" }
        "3" { Invoke-CategoryEvaluation -CategoryID "SiteConnectivity" }
        "4" { Invoke-CategoryEvaluation -CategoryID "DataCentre" }
        "5" { Invoke-CategoryEvaluation -CategoryID "WANConnectivity" }
        "6" { Invoke-CategoryEvaluation -CategoryID "DeviceConfiguration" }
        "7" { Invoke-CategoryEvaluation -CategoryID "WebServerAccess" }
        "8" { Invoke-CategoryEvaluation -CategoryID "OverallImplementation" }
        
        # Reporting
        "9" { Invoke-ReportAction -Action "Generate"; $showContinuePrompt = $false }
        "10" { Invoke-ReportAction -Action "Export"; $showContinuePrompt = $false }
        "11" { Invoke-ReportAction -Action "Preview"; $showContinuePrompt = $false }
        
        # Reference
        "12" { Show-AppropriateCommandReference }
        "13" { Show-AppropriateStarRatingGuide }
        "14" { Show-TemplateSelectionMenu }
        
        # Exit
        "0" { return $false }
        
        # Help shortcut
        "?" { Show-AppropriateCommandReference }
        
        # Invalid
        default { 
            Write-CustomError "Invalid option. Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
    
    return $showContinuePrompt
}

# Invoke evaluation function
function Invoke-CategoryEvaluation {
    param([string]$CategoryID)
    
    if (-not (Is-EvaluationInitialised)) {
        Write-CustomError "Please initialise an evaluation first (option 1)"
        return
    }
    
    if ($script:config.Template -eq "Dynamic") {
        Evaluate-Category -CategoryID $CategoryID
    } else {
        # Call static evaluation function
        switch ($CategoryID) {
            "SiteCreation" { Evaluate-SiteCreation }
            "SiteConnectivity" { Evaluate-SiteConnectivity }
            "DataCentre" { Evaluate-DataCentre }
            "WANConnectivity" { Evaluate-WANConnectivity }
            "DeviceConfiguration" { Evaluate-DeviceConfiguration }
            "WebServerAccess" { Evaluate-WebServerAccess }
            "OverallImplementation" { Evaluate-OverallImplementation }
        }
    }
}

# Invoke report action
function Invoke-ReportAction {
    param([string]$Action)
    
    if (-not (Is-EvaluationInitialised)) {
        Write-CustomError "Please initialise and complete an evaluation first"
        return
    }
    
    # common parameters
    $commonParams = @{
        EvaluationData = $script:evaluationData
        FormatCategoryName = ${function:Format-CategoryName}
    }
    
    # UI functions for actions
    $displayParams = $commonParams.Clone()
    $displayParams.Add("WriteHeader", ${function:Write-Header})
    $displayParams.Add("WriteSubHeader", ${function:Write-SubHeader})
    $displayParams.Add("WriteInfo", ${function:Write-Info})
    $displayParams.Add("WriteSuccess", ${function:Write-Success})
    $displayParams.Add("WriteCustomError", ${function:Write-CustomError})
    
    # action, do
    switch ($Action) {
        "Generate" {
            Generate-SummaryReport @displayParams
        }
        "Export" {
            $scoreData = Calculate-AssessmentScores @commonParams
            $feedbackItems = Generate-FeedbackRecommendations @commonParams
            $reportContent = Prepare-ReportContent -ScoreData $scoreData -FeedbackItems $feedbackItems @commonParams
            $exportResult = Export-ReportToFile -StudentID $script:evaluationData.StudentID -ReportContent $reportContent
            
            if ($exportResult.Success) {
                Write-Success "Report exported to $($exportResult.FileName)"
            } else {
                Write-CustomError "Failed to export report: $($exportResult.ErrorMessage)"
            }
        }
        "Preview" {
            $scoreData = Calculate-AssessmentScores @commonParams
            $feedbackItems = Generate-FeedbackRecommendations @commonParams
            Display-SummaryReport -ScoreData $scoreData -FeedbackItems $feedbackItems @displayParams
        }
    }
}

# Show command reference
function Show-AppropriateCommandReference {
    if ($script:config.Template -eq "Dynamic") {
        Show-TemplateCommandReference -CommandReferences $script:config.CommandReferences
    } else {
        Show-CommandReference
    }
}

# Show star rating guide
function Show-AppropriateStarRatingGuide {
    if ($script:config.Template -eq "Dynamic") {
        Show-TemplateStarRatingGuide -StarRatingGuide $script:config.StarRatingGuide
    } else {
        Show-StarRatingGuide
    }
}

# Main Execution
try {
    Show-MainMenu
}
catch {
    Write-CustomError "An error occurred: $_"
    Write-Host "Press any key to exit..." -ForegroundColor Red
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
finally {
    Write-Host ""
    Write-Host "Thank you." -ForegroundColor Cyan
}