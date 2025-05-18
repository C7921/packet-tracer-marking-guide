# Reporting Module
# Better separation for different assessment types and content needed for student feedback.

# Score calculation function
function Calculate-AssessmentScores {
    param(
        [hashtable]$EvaluationData
    )
    
    # Calculate percentage score
    $percentageScore = [math]::Round(($EvaluationData.OverallScore / $EvaluationData.MaxPossibleScore) * 100, 1)
    
    # Calculate average star rating (out of 5)
    $averageRating = [math]::Round($EvaluationData.OverallScore / $EvaluationData.Ratings.Count, 1)
    
    # Convert average rating to stars visual representation
    $starRating = ""
    $fullStars = [Math]::Round($averageRating)
    
    for ($i = 0; $i -lt $fullStars; $i++) {
        $starRating += "*"
    }
    
    for ($i = $fullStars; $i -lt 5; $i++) {
        $starRating += "-"
    }
    
    # Determine overall assessment text
    $overallAssessment = switch ($percentageScore) {
        {$_ -ge 90} { "Excellent"; break }
        {$_ -ge 80} { "Very Good"; break }
        {$_ -ge 70} { "Good"; break }
        {$_ -ge 60} { "Satisfactory"; break }
        {$_ -ge 50} { "Adequate"; break }
        default { "Needs Improvement" }
    }
    
    # Return calculation results
    return @{
        PercentageScore = $percentageScore
        AverageRating = $averageRating
        StarRating = $starRating
        OverallAssessment = $overallAssessment
    }
}

# Generate feedback recommendations
function Generate-FeedbackRecommendations {
    param(
        [hashtable]$EvaluationData,
        [scriptblock]$FormatCategoryName
    )
    
    $feedbackItems = @()
    
    foreach ($category in $EvaluationData.Ratings.Keys | Sort-Object) {
        $rating = $EvaluationData.Ratings[$category]
        $displayName = $FormatCategoryName.Invoke($category)
        
        if ($rating -le 2) {
            $feedbackItem = @{
                Type = "Improvement"
                Category = $displayName
                Recommendations = Get-ImprovementSuggestions -Category $category
            }
            $feedbackItems += $feedbackItem
        }
        elseif ($rating -ge 4) {
            $feedbackItem = @{
                Type = "Strength"
                Category = $displayName
                Recommendations = @()
            }
            $feedbackItems += $feedbackItem
        }
    }
    
    return $feedbackItems
}

# Helper function - Improvement Suggestions
function Get-ImprovementSuggestions {
    param(
        [string]$Category
    )
    
    $suggestions = @()
    
    switch ($Category) {
        "SiteCreation" {
            $suggestions += "Ensure correct number of sites are created as per requirements"
            $suggestions += "Follow the specified numbering scheme for PCs"
            $suggestions += "Use logical view instead of physical view"
        }
        "SiteConnectivity" {
            $suggestions += "Review internal connectivity within sites"
            $suggestions += "Ensure appropriate devices are used to connect PCs"
            $suggestions += "Verify IP addressing, subnet masks, and connectivity between devices"
        }
        # ... other categories
    }
    
    return $suggestions
}

# Display Report in Console - Optional but good for quick review (Should be separate from export)
function Display-SummaryReport {
    param(
        [hashtable]$EvaluationData,
        [hashtable]$ScoreData,
        [array]$FeedbackItems,
        [scriptblock]$FormatCategoryName,
        [scriptblock]$WriteHeader,
        [scriptblock]$WriteSubHeader,
        [scriptblock]$WriteInfo,
        [scriptblock]$WriteSuccess,
        [scriptblock]$WriteCustomError
    )
    
    Clear-Host
    $WriteHeader.Invoke("Evaluation Summary Report")
    
    # General information
    $endTime = Get-Date
    $duration = $endTime - $EvaluationData.StartTime
    
    $WriteInfo.Invoke("Student: $($EvaluationData.StudentName) ($($EvaluationData.StudentID))")
    $WriteInfo.Invoke("Submission: $($EvaluationData.SubmissionFile)")
    $WriteInfo.Invoke("Evaluation completed: $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))")
    $WriteInfo.Invoke("Evaluation duration: $($duration.ToString('hh\:mm\:ss'))")
    $WriteInfo.Invoke("Overall Rating: $($ScoreData.StarRating) ($($ScoreData.AverageRating)/5.0)")
    $WriteInfo.Invoke("Percentage Score: $($ScoreData.PercentageScore)%")
    $WriteInfo.Invoke("Overall Assessment: $($ScoreData.OverallAssessment)")
    
    # Category ratings
    $WriteSubHeader.Invoke("Category Ratings")
    
    foreach ($category in $EvaluationData.Ratings.Keys | Sort-Object) {
        $rating = $EvaluationData.Ratings[$category]
        
        # Create stars string for display
        $stars = ""
        $fullStars = [Math]::Round($rating)
        
        for ($i = 0; $i -lt $fullStars; $i++) {
            $stars += "*"
        }
        
        for ($i = $fullStars; $i -lt 5; $i++) {
            $stars += "-"
        }
        
        # Format category name for display
        $displayName = $FormatCategoryName.Invoke($category)
        
        Write-Host "  $displayName`: $stars ($rating/5)" -ForegroundColor White
        
        if ($EvaluationData.Comments.ContainsKey($category) -and 
            -not [string]::IsNullOrWhiteSpace($EvaluationData.Comments[$category])) {
            Write-Host "    Comment: $($EvaluationData.Comments[$category])" -ForegroundColor Gray
        }
    }
    
    # Display feedback recommendations
    $WriteSubHeader.Invoke("Feedback Recommendations")
    
    foreach ($item in $FeedbackItems) {
        if ($item.Type -eq "Improvement") {
            $WriteCustomError.Invoke("Areas for Improvement - $($item.Category):")
            
            foreach ($recommendation in $item.Recommendations) {
                $WriteInfo.Invoke("  - $recommendation")
            }
        }
        elseif ($item.Type -eq "Strength") {
            $WriteSuccess.Invoke("Strengths - $($item.Category)")
        }
    }
}

# Prepare report content
function Prepare-ReportContent {
    param(
        [hashtable]$EvaluationData,
        [hashtable]$ScoreData,
        [array]$FeedbackItems,
        [scriptblock]$FormatCategoryName
    )
    
    $endTime = Get-Date
    $duration = $endTime - $EvaluationData.StartTime
    
    # Prepare report content
    $reportContent = @"
========================================================
Packet Tracer Assignment Evaluation Report
========================================================

Student: $($EvaluationData.StudentName) ($($EvaluationData.StudentID))
Submission: $($EvaluationData.SubmissionFile)
Evaluation completed: $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))
Evaluation duration: $($duration.ToString('hh\:mm\:ss'))
Overall Rating: $($ScoreData.AverageRating)/5.0 ($($ScoreData.PercentageScore)%)
Overall Assessment: $($ScoreData.OverallAssessment)

--------------------------------------------------------
Category Ratings
--------------------------------------------------------
"@
    
    foreach ($category in $EvaluationData.Ratings.Keys | Sort-Object) {
        $rating = $EvaluationData.Ratings[$category]
        $displayName = $FormatCategoryName.Invoke($category)
        
        $reportContent += "`n$displayName`: $rating/5"
        
        if ($EvaluationData.Comments.ContainsKey($category) -and 
            -not [string]::IsNullOrWhiteSpace($EvaluationData.Comments[$category])) {
            $reportContent += "`n  Comment: $($EvaluationData.Comments[$category])"
        }
    }
    
    $reportContent += @"

--------------------------------------------------------
Feedback Recommendations
--------------------------------------------------------
"@
    
    # Add feedback recommendations
    foreach ($item in $FeedbackItems) {
        if ($item.Type -eq "Improvement") {
            $reportContent += "`nAreas for Improvement - $($item.Category):"
            
            foreach ($recommendation in $item.Recommendations) {
                $reportContent += "`n  - $recommendation"
            }
        }
        elseif ($item.Type -eq "Strength") {
            $reportContent += "`nStrengths - $($item.Category)"
        }
    }
    
    return $reportContent
}

# Export report
function Export-ReportToFile {
    param(
        [string]$StudentID,
        [string]$ReportContent
    )
    
    $filename = "$StudentID.txt"
    
    try {
        $ReportContent | Out-File -FilePath $filename -Encoding utf8 -Force
        return @{
            Success = $true
            FileName = $filename
            ErrorMessage = $null
        }
    }
    catch {
        return @{
            Success = $false
            FileName = $filename
            ErrorMessage = $_
        }
    }
}

# Main report generation function
function Generate-SummaryReport {
    param(
        [hashtable]$EvaluationData,
        [scriptblock]$FormatCategoryName,
        [scriptblock]$WriteHeader,
        [scriptblock]$WriteSubHeader,
        [scriptblock]$WriteInfo,
        [scriptblock]$WriteSuccess,
        [scriptblock]$WriteCustomError
    )
    
    # Calculate scores
    $scoreData = Calculate-AssessmentScores -EvaluationData $EvaluationData
    
    # Generate feedback recommendations
    $feedbackItems = Generate-FeedbackRecommendations -EvaluationData $EvaluationData -FormatCategoryName $FormatCategoryName
    
    # Display report on console
    Display-SummaryReport -EvaluationData $EvaluationData -ScoreData $scoreData -FeedbackItems $feedbackItems `
                          -FormatCategoryName $FormatCategoryName -WriteHeader $WriteHeader -WriteSubHeader $WriteSubHeader `
                          -WriteInfo $WriteInfo -WriteSuccess $WriteSuccess -WriteCustomError $WriteCustomError
    
    # Ask user if they want to export the report
    $WriteSubHeader.Invoke("Report Export Options")
    
    Write-Host "  Export report to a file? (y/n): " -NoNewline
    $exportChoice = Read-Host
    
    if ($exportChoice -eq "y") {
        # Prepare report content
        $reportContent = Prepare-ReportContent -EvaluationData $EvaluationData -ScoreData $scoreData `
                                              -FeedbackItems $feedbackItems -FormatCategoryName $FormatCategoryName
        
        # Set filename to student ID
        $filename = "$($EvaluationData.StudentID).txt"
        Write-Host "  Report will be saved as: $filename"
        
        # Export to file
        $exportResult = Export-ReportToFile -StudentID $EvaluationData.StudentID -ReportContent $reportContent
        
        if ($exportResult.Success) {
            $WriteSuccess.Invoke("Report exported to $($exportResult.FileName)")
        }
        else {
            $WriteCustomError.Invoke("Failed to export report: $($exportResult.ErrorMessage)")
        }
    }
}

# Export module members
Export-ModuleMember -Function Calculate-AssessmentScores, Generate-FeedbackRecommendations, Display-SummaryReport, Prepare-ReportContent, Export-ReportToFile, Generate-SummaryReport