# Packet Tracer Marking Guide

PowerShell based application designed to guide markers through student submitted Packet Tracer files. Attempts to help standardise the assessment process with detailed steps and generate a consistent feedback file.

## Features

* Uses the same framework for all student submissions based on assessment project requirements.

* Interactive guide walks each marker through submission process with inputs for student ID, command reference guides and star ratings.

* Rating system 1-5 helps for formative feedback that allows students helpful information for reflection.

* Context help by using ? can enable to marker to check hints/commands etc for each section of the file.

* Generates report with consistent feedback document named after the student ID. Could be used to upload a feedback document for each student.

## Usage

Still not 100% sure on how to use other PowerShell documents. But documentation suggests using the right execution policy.

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Workflow

1. Initialise new evaluation
2. Enter student details
3. Work through each assessment category
    * Review verification steps
    * Check implementation
    * Assign star rating (1-5)
    * Add feedback comments (optional, but recommended)

4. Repeat steps for next student.
5. Generate summary reports
6. Export reports - Creates file with student ID.

## Assessment Categories

1. Site Creation - Number of sites and PC implementation
2. Site Connectivity - Internal connectivity within sites
3. Data Center Configuration - Check server implementation and configuration
4. WAN Connectivity - Checks inter-site connections and appropriate technologies
5. Device Configuration - Check routing configuration and traffic forwarding
6. Web Server Access - Check web server access from sites
7. Overall Implementation - Evaluate design quality, scalability, and networking knowledge.

