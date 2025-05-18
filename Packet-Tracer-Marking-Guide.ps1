<#
.SYNOPSIS
    Packet Tracer Assignment Evaluation Tool - With Command Reference
.DESCRIPTION
    Script guides markers through evaluating student Packet Tracer submissions.
    Expanded details for instructions and command references for Packet Tracer.
.NOTES
    Version: 3.0
#>

$script:activeEvaluation = $null 


# Import all modules in the Modules directory
function Import-PTModule{
    param([string]$moduleName)

    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath "Modules\$ModuleName.psm1"

    Write-Host "Importing module: $modulePath" -ForegroundColor Green

    if(Test-Path $modulePath) {
       try {
         Microsoft.PowerShell.Core\Import-Module $modulePath -Force -DisableNameChecking -Global # -Verbose
        # Import-Module $modulePath -Force -DisableNameChecking -Global -Verbose
        
        # Check module successfully imported
        $loadedModule =  Get-Module | Where-Object { $_.Path -eq $modulePath }
        if($loadedModule) {
            Write-Host "Successfully imported module: $modulePath" -ForegroundColor Green
                # Debug - List Export Functions
                # $exportedCommands = Get-Command -Module $loadedModule.Name
                # $exportedCommands = Get-Command -Module $loadedModule.Name
                # Write-Host "Exported functions: $($exportedCommands | ForEach-Object { $_.Name })" -ForegroundColor Green 
            return $true
            } else {
                Write-Host "Failed to import module: $modulePath" -ForegroundColor Red
                return $false
            }
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
$modulesLoaded = $modulesLoaded -and (Import-PTModule -ModuleName "PT-Core")
$modulesLoaded = $modulesLoaded -and (Import-PTModule -ModuleName "PT-UI")
$modulesLoaded = $modulesLoaded -and (Import-PTModule -ModuleName "PT-Evaluation")
$modulesLoaded = $modulesLoaded -and (Import-PTModule -ModuleName "PT-Reference")
$modulesLoaded = $modulesLoaded -and (Import-PTModule -ModuleName "PT-Reporting")

# Final check - make sure loaded correctly
if(-not $modulesLoaded) {
    Write-Host "One or more modules failed to load. Exiting..." -ForegroundColor Red
    Exit 1
} 

function Show-MainMenu {
    Initialise-Template
    
    do {
        # Clear-Host
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

# Initialise templates
function Initialise-Template {
   if(-not $script:config -or -not $script:config.TemplateName){
    # check if exists
    $defaultTemplatePath = Join-Path -Path $PSScriptRoot -ChildPath "Templates\Default(2270).json"
    Write-Host "Looking for template at: $defaultTemplatePath" -ForegroundColor Yellow
    if (Test-Path $defaultTemplatePath) {
        try {
            Load-AssessmentTemplate -Path $defaultTemplatePath
        } catch {
            Write-Host "Error loading template: $_" -ForegroundColor Red
            Write-Host "Please check the template file and try again. Make sure function is exported." -ForegroundColor Red
        } 
        # Check if function is available
        if (Get-Command -Name "Load-AssessmentTemplate" -ErrorAction SilentlyContinue) {
            Write-Host "Function Exists but cannot be called. Module Scope issues?" -ForegroundColor Yellow
        } else {
            Write-Host "Load-AssessmentTemplate not found. Ensure properly exported from PT-Core.psm1 " -ForegroundColor Red
        }
    } else {
        Write-Host "Template file not found: $defaultTemplatePath" -ForegroundColor Red
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
        "1" { $script:activeEvaluation = Initialise-Evaluation}
        "2" { Invoke-CategoryEvaluation -CategoryID "SiteCreation" -EvaluationData $script:activeEvaluation }
        "3" { Invoke-CategoryEvaluation -CategoryID "SiteConnectivity" -EvaluationData $script:activeEvaluation }
        "4" { Invoke-CategoryEvaluation -CategoryID "DataCentre" -EvaluationData $script:activeEvaluation }
        "5" { Invoke-CategoryEvaluation -CategoryID "WANConnectivity" -EvaluationData $script:activeEvaluation }
        "6" { Invoke-CategoryEvaluation -CategoryID "DeviceConfiguration" -EvaluationData $script:activeEvaluation }
        "7" { Invoke-CategoryEvaluation -CategoryID "WebServerAccess" -EvaluationData $script:activeEvaluation }
        "8" { Invoke-CategoryEvaluation -CategoryID "OverallImplementation" -EvaluationData $script:activeEvaluation }

        # Reporting - Pass evluation data
        "9" { Invoke-ReportAction -Action "Generate" -EvaluationData $script:activeEvaluation; $showContinuePrompt = $false }
        "10" { Invoke-ReportAction -Action "Export" -EvaluationData $script:activeEvaluation; $showContinuePrompt = $false }
        "11" { Invoke-ReportAction -Action "Preview" -EvaluationData $script:activeEvaluation; $showContinuePrompt = $false }
        
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
# This function redirects evaluation to the appropriate category handler
# and passes the global activeEvaluation data to each function
function Invoke-CategoryEvaluation {
    param([string]$CategoryID)
    
    # Check if evaluation is initialised without requiring a parameter
    if (-not $script:activeEvaluation -or -not $script:activeEvaluation.StudentID) {
        Write-CustomError "Please initialise an evaluation first (option 1)"
        return
    }
    
    # Handle different template types
    if ($script:config.Template -eq "Dynamic") {
        # For dynamic templates, pass the category ID and evaluation data
        Evaluate-Category -CategoryID $CategoryID -EvaluationData $script:activeEvaluation
    } else {
        # For static templates, call the specific evaluation function
        # Pass activeEvaluation to each evaluation function
        switch ($CategoryID) {
            "SiteCreation" { Evaluate-SiteCreation -EvaluationData $script:activeEvaluation }
            "SiteConnectivity" { Evaluate-SiteConnectivity -EvaluationData $script:activeEvaluation }
            "DataCentre" { Evaluate-DataCentre -EvaluationData $script:activeEvaluation }
            "WANConnectivity" { Evaluate-WANConnectivity -EvaluationData $script:activeEvaluation }
            "DeviceConfiguration" { Evaluate-DeviceConfiguration -EvaluationData $script:activeEvaluation }
            "WebServerAccess" { Evaluate-WebServerAccess -EvaluationData $script:activeEvaluation }
            "OverallImplementation" { Evaluate-OverallImplementation -EvaluationData $script:activeEvaluation }
        }
    }
}

# Invoke report action
function Invoke-ReportAction {
   param(
        [string]$Action,
        [Parameter(Mandatory=$false)]
        [hashtable]$EvaluationData = $script:activeEvaluation
    )

    # Pass the evaluation data explicitly
    if (-not (Is-EvaluationInitialised -EvaluationData $EvaluationData)) {
        Write-CustomError "Please initialise and complete an evaluation first"
        return
    }
    
    # common parameters
      $commonParams = @{
        EvaluationData = $EvaluationData
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
            $exportResult = Export-ReportToFile -StudentID $EvaluationData.StudentID -ReportContent $reportContent
            
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