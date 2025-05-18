# UI Functions for Console Output

function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-SubHeader {
    param([string]$Text)
    Write-Host ""
    Write-Host "------------------------------------------------" -ForegroundColor Yellow
    Write-Host "  $Text" -ForegroundColor Yellow
    Write-Host "------------------------------------------------" -ForegroundColor Yellow
    Write-Host ""
}

function Write-Info {
    param([string]$Text)
    Write-Host "  $Text" -ForegroundColor White
}

function Write-Success {
    param([string]$Text)
    Write-Host "  [SUCCESS] $Text" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Text)
    Write-Host "  [WARNING] $Text" -ForegroundColor Yellow
}

function Write-CustomError {
    param([string]$Text)
    Write-Host "  [ERROR] $Text" -ForegroundColor Red
}

function Write-Hint {
    param([string]$Text)
    Write-Host "  [HINT] $Text" -ForegroundColor Magenta
}

function Write-Command {
    param([string]$Text)
    Write-Host "  [COMMAND] $Text" -ForegroundColor Cyan
}

function Write-Stars {
    param([int]$Count)
    $stars = ""
    
    for ($i = 0; $i -lt $Count; $i++) {
        $stars += "*"
    }
    
    for ($i = $Count; $i -lt 5; $i++) {
        $stars += "-"
    }
    
    Write-Host "  Rating: $stars ($Count/5)" -ForegroundColor Yellow
}

function Get-Rating {
    param(
        [string]$Category,
        [string]$Prompt,
        [Parameter(Mandatory=$true)] #debug
        [hashtable]$evaluationData # New Parameter instead of global
    )
    
    Write-Host ""
    Write-Host "  $Prompt (1-5): " -ForegroundColor Yellow -NoNewline
    $rating = Read-Host
    
    try {
        $ratingNum = [int]$rating
        if ($ratingNum -ge 1 -and $ratingNum -le 5) {
            $EvaluationData.Ratings[$Category] = $ratingNum
            $EvaluationData.MaxPossibleScore += 5
            $EvaluationData.OverallScore += $ratingNum
            Write-Stars -Count $ratingNum
            # return $ratingNum # Prevents return printing on new line.
        }
        else {
            Write-CustomError "Please enter a whole number between 1 and 5."
            return Get-Rating -Category $Category -Prompt $Prompt -EvaluationData $EvaluationData
        }
    }
    catch {
        Write-CustomError "Please enter a valid whole number."
        return Get-Rating -Category $Category -Prompt $Prompt -EvaluationData $EvaluationData
    }
}

function Get-Comment {
    param(
        [string]$Category,
        [string]$Prompt,
         [Parameter(Mandatory=$true)]
        [hashtable]$EvaluationData # New Parameter instead of global
    )
    
    Write-Host ""
    Write-Host "  $Prompt (press Enter to skip): " -ForegroundColor White -NoNewline
    $comment = Read-Host
    
     if (-not [string]::IsNullOrWhiteSpace($comment)) {
        if ($null -eq $EvaluationData.Comments) {
            $EvaluationData.Comments = @{}
        }
        $EvaluationData.Comments[$Category] = $comment
    }
    return $comment
}

# Export Modules
Export-ModuleMember -Function Get-Rating, Get-Comment, Write-Header, Write-SubHeader, Write-Info, Write-Success, Write-Warning, Write-CustomError, Write-Hint, Write-Command, Write-Stars
