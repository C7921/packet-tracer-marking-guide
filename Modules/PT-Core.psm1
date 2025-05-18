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

# Evaluation data hashtable
$script:evaluationData = @{
    StudentName = ""
    StudentID = ""
    SubmissionFile = ""
    Ratings = @{}
    Comments = @{}
    OverallScore = 0
    MaxPossibleScore = 0
    StartTime = Get-Date
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
    
    return $script:evaluationData
}

# Check if evaluation been initialised
function Is-EvaluationInitialised {
    if (-not $script:evaluationData -or -not $script:evaluationData.StudentID) {
        return $false
    }
    return $true
}

# Save assessment data to a file
function Save-AssessmentData {
    param(
        [string]$Path
    )
    
    try {
        $script:evaluationData | ConvertTo-Json -Depth 5 | Out-File -FilePath $Path -Encoding utf8 -Force
        return $true
    }
    catch {
        return $false
    }
}

# Load assessment data from a file
function Load-AssessmentData {
    param(
        [string]$Path
    )
    
    if (Test-Path $Path) {
        try {
            $savedData = Get-Content -Path $Path -Raw | ConvertFrom-Json
            
            # Convert from JSON to hashtable
            $script:evaluationData.StudentName = $savedData.StudentName
            $script:evaluationData.StudentID = $savedData.StudentID
            $script:evaluationData.SubmissionFile = $savedData.SubmissionFile
            $script:evaluationData.Ratings = @{}
            $script:evaluationData.Comments = @{}
            $script:evaluationData.OverallScore = $savedData.OverallScore
            $script:evaluationData.MaxPossibleScore = $savedData.MaxPossibleScore
            $script:evaluationData.StartTime = [datetime]$savedData.StartTime
            
            # Convert ratings and comments
            foreach ($key in $savedData.Ratings.PSObject.Properties.Name) {
                $script:evaluationData.Ratings[$key] = $savedData.Ratings.$key
            }
            
            foreach ($key in $savedData.Comments.PSObject.Properties.Name) {
                $script:evaluationData.Comments[$key] = $savedData.Comments.$key
            }
            
            return $true
        }
        catch {
            return $false
        }
    }
    else {
        return $false
    }
}

# Export module members
Export-ModuleMember -Variable config, evaluationData
Export-ModuleMember -Function Load-AssessmentTemplate, Initialise-Assessment, Is-EvaluationInitialised, Save-AssessmentData, Load-AssessmentData