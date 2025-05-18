# Setup-Assessment-Tool.ps1
# Checks setup when running new template/directories - DEBUG

# Check and create directories
$directories = @("Modules", "Templates")

foreach ($dir in $directories) {
    $dirPath = Join-Path -Path $PSScriptRoot -ChildPath $dir
    if (-not (Test-Path -Path $dirPath)) {
        Write-Host "Creating directory: $dirPath" -ForegroundColor Yellow
        New-Item -Path $dirPath -ItemType Directory | Out-Null
    }
}

# Check for required modules
$modules = @("PT-Core", "PT-UI", "PT-Evaluation", "PT-Reference", "PT-Reporting")

foreach ($module in $modules) {
    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath "Modules\$module.psm1"
    if (-not (Test-Path -Path $modulePath)) {
        Write-Host "Module file missing: $modulePath" -ForegroundColor Red
        Write-Host "Please ensure all module files are created before running the assessment tool."
    }
}

# Check for template file
$templatePath = Join-Path -Path $PSScriptRoot -ChildPath "Templates\Default.json"
if (-not (Test-Path -Path $templatePath)) {
    Write-Host "Default template missing: $templatePath" -ForegroundColor Yellow
    Write-Host "The assessment tool will use built-in configuration until a template is loaded."
}

Write-Host "Setup complete. Run Packet-Tracer-Assessment.ps1 to start." -ForegroundColor Green