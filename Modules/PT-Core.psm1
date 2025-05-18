# PT-Core.psm1
# Loads templates and handles assessment data

# Script configuration hashtable
$script:config = @{
    TemplateName = "Default 2270 Packet Tracer Assessment"
    Template = "Static"
    Categories = @()
    StarRatingGuide = @{}
    CommandReferences = @{}
}

# # Evaluation data hashtable
# $script:evaluationData = @{
#     StudentName = ""
#     StudentID = ""
#     SubmissionFile = ""
#     Ratings = @{}
#     Comments = @{}
#     OverallScore = 0
#     MaxPossibleScore = 0
#     StartTime = Get-Date
# }

function Initialise-Evaluation {
    Clear-Host
    Write-Header "Packet Tracer Assignment Evaluation Tool"
    
    Write-Info "This tool will guide you through evaluating a student's Packet Tracer submission."
    Write-Info "For each section, you'll check specific requirements and assign a rating from 1-5."
    Write-Info "Enter '?' at any prompt to view the command reference guide."
    
    Write-SubHeader "Student Information"
    
    Write-Host "  Student Name: " -NoNewline
    $studentName = Read-Host
    
    Write-Host "  Student ID: " -NoNewline
    $studentID = Read-Host
    
    # Call the existing Initialise-Assessment function with collected parameters
    # $evaluationData = Initialise-Assessment -StudentName $studentName -StudentID $studentID
    
    # Write-Host "  Setting Submission file to: $($evaluationData.SubmissionFile)"
    
# Create a new evaluation data object
    $evaluationData = @{
        StudentName = $studentName
        StudentID = $studentID
        SubmissionFile = $studentID
        Ratings = @{}
        Comments = @{}
        OverallScore = 0
        MaxPossibleScore = 0
        StartTime = Get-Date
    }

    Write-Success "Evaluation initialised. Begin the assessment."
    
    return $evaluationData
}

# Function to load assessment template from JSON file
function Load-AssessmentTemplate {
    param(
        [string]$Path
    )
    
    Write-Host "Loading template from: $Path"
    
    if (Test-Path $Path) {
        try {
            $template = Get-Content -Path $Path -Raw | ConvertFrom-Json
            
            # Set global configuration from template
            $script:config.TemplateName = $template.TemplateName
            $script:config.Template = "Dynamic"
            $script:config.Categories = $template.Categories
            $script:config.StarRatingGuide = $template.StarRatingGuide
            $script:config.CommandReferences = $template.CommandReferences
            
            Write-Host "Loaded assessment template: $($template.TemplateName)" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "Error loading template: $_" -ForegroundColor Red
            return $false
        }
    }
    else {
        Write-Host "Template file not found: $Path" -ForegroundColor Red
        return $false
    }
}

# Initialise a new assessment
function Initialise-Assessment {
    param(
        [string]$StudentName,
        [string]$StudentID
    )
    
    $script:evaluationData.StudentName = $StudentName
    $script:evaluationData.StudentID = $StudentID
    $script:evaluationData.SubmissionFile = $StudentID
    $script:evaluationData.Ratings = @{}
    $script:evaluationData.Comments = @{}
    $script:evaluationData.OverallScore = 0
    $script:evaluationData.MaxPossibleScore = 0
    $script:evaluationData.StartTime = Get-Date
    
    Write-Host "$script:evaluationData.studentName"
    return $script:evaluationData
}

# Check if evaluation been initialised. Active evaluation
function Is-EvaluationInitialised {
    param(
        [Parameter(Mandatory=$false)]
        [hashtable]$EvaluationData = $null
    )
    
    # Check param if provided
    if ($null -ne $EvaluationData -and $null -ne $EvaluationData.StudentID) {
        return $true
    }
    
    # Fall back to old scope - backwards from older code.
    if ($script:activeEvaluation -and $script:activeEvaluation.StudentID) {
        return $true
    }
    return $false
}

# Save assessment data to a file
function Save-AssessmentData {
    param(
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [hashtable]$EvaluationData
    )
    
    try {
        $EvaluationData | ConvertTo-Json -Depth 5 | Out-File -FilePath $Path -Encoding utf8 -Force
        return $true
    }
    catch {
        return $false
    }
}

# Load assessment data from a file
function Load-AssessmentData {
    param([string]$Path)
    
    if (Test-Path $Path) {
        try {
            $savedData = Get-Content -Path $Path -Raw | ConvertFrom-Json
            
            # Create a new hashtable
            $evaluationData = @{
                StudentName = $savedData.StudentName
                StudentID = $savedData.StudentID
                SubmissionFile = $savedData.SubmissionFile
                Ratings = @{}
                Comments = @{}
                OverallScore = $savedData.OverallScore
                MaxPossibleScore = $savedData.MaxPossibleScore
                StartTime = [datetime]$savedData.StartTime
            }
            
            # Convert ratings and comments
            foreach ($key in $savedData.Ratings.PSObject.Properties.Name) {
                $evaluationData.Ratings[$key] = $savedData.Ratings.$key
            }
            
            foreach ($key in $savedData.Comments.PSObject.Properties.Name) {
                $evaluationData.Comments[$key] = $savedData.Comments.$key
            }
            
            return $evaluationData
        }
        catch {
            return $null
        }
    }
    else {
        return $null
    }
}

# Export module members
Export-ModuleMember -Variable config, evaluationData
Export-ModuleMember -Function Load-AssessmentTemplate, Initialise-Assessment, Is-EvaluationInitialised, Save-AssessmentData, Load-AssessmentData, Initialise-Evaluation
