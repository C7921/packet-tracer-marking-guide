<#
.SYNOPSIS
    Packet Tracer Assignment Evaluation Tool - With Command Reference
.DESCRIPTION
    Script guides markers through evaluating student Packet Tracer submissions.
    Expanded details for instructions and command references for Packet Tracer.
.NOTES
    Version: 2.0
#>

# Script configuration
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

# Rich console output functions
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
        [string]$Prompt
    )
    
    Write-Host ""
    Write-Host "  $Prompt (1-5): " -ForegroundColor Yellow -NoNewline
    $rating = Read-Host
    
    try {
        $ratingNum = [int]$rating
        if ($ratingNum -ge 1 -and $ratingNum -le 5) {
            $script:evaluationData.Ratings[$Category] = $ratingNum
            $script:evaluationData.MaxPossibleScore += 5
            $script:evaluationData.OverallScore += $ratingNum
            Write-Stars -Count $ratingNum
            # return $ratingNum # Prevents return printing on new line.
        }
        else {
            Write-CustomError "Please enter a whole number between 1 and 5."
            return Get-Rating -Category $Category -Prompt $Prompt
        }
    }
    catch {
        Write-CustomError "Please enter a valid whole number."
        return Get-Rating -Category $Category -Prompt $Prompt
    }
}

function Get-Comment {
    param(
        [string]$Category,
        [string]$Prompt
    )
    
    Write-Host ""
    Write-Host "  $Prompt (press Enter to skip): " -ForegroundColor White -NoNewline
    $comment = Read-Host
    
    if (-not [string]::IsNullOrWhiteSpace($comment)) {
        $script:evaluationData.Comments[$Category] = $comment
    }
    
    return $comment
}

function Format-CategoryName {
    param([string]$Name)
    
    # Manually handle categories - Based on assessment requirements.
    switch ($Name) {
        "SiteCreation" { return "Site Creation" }
        "SiteConnectivity" { return "Site Connectivity" }
        "DataCentre" { return "Data Centre" }
        "WANConnectivity" { return "WAN Connectivity" }
        "DeviceConfiguration" { return "Device Configuration" }
        "WebServerAccess" { return "Web Server Access" }
        "OverallImplementation" { return "Overall Implementation" }
        default { return $Name }
    }
}

function Show-CommandReference {
    Write-SubHeader "Packet Tracer Command Reference"
    
    Write-Info "Basic Router Commands:"
    Write-Command "Router> enable                           # Enter privileged mode"
    Write-Command "Router# show running-config              # View current configuration"
    Write-Command "Router# show ip interface brief          # Quick view of interfaces and status"
    Write-Command "Router# show ip route                    # View routing table"
    Write-Command "Router# show ip protocols                # View active routing protocols"
    
    Write-Info ""
    Write-Info "Interface Commands:"
    Write-Command "Router# show interfaces                  # Detailed interface information"
    Write-Command "Router# show interface Serial0/0/0        # Specific interface details"
    Write-Command "Router# show running-config interface Serial0/0/0  # Configuration for specific interface"
    
    Write-Info ""
    Write-Info "Routing Protocol Commands:"
    Write-Command "# RIP"
    Write-Command "Router# show ip rip database             # View RIP route database"
    Write-Command "Router# show running-config | section router rip  # View RIP configuration"
    Write-Command ""
    Write-Command "# OSPF"
    Write-Command "Router# show ip ospf neighbor            # View OSPF neighbors"
    Write-Command "Router# show ip ospf interface           # View OSPF interface details"
    Write-Command "Router# show running-config | section router ospf  # View OSPF configuration"
    Write-Command ""
    Write-Command "# EIGRP"
    Write-Command "Router# show ip eigrp neighbors          # View EIGRP neighbors"
    Write-Command "Router# show ip eigrp topology           # View EIGRP topology table"
    Write-Command "Router# show running-config | section router eigrp  # View EIGRP configuration"
    
    Write-Info ""
    Write-Info "PC Commands:"
    Write-Command "C:\> ipconfig                            # View IP configuration"
    Write-Command "C:\> ping [ip-address]                   # Test connectivity to another device"
    Write-Command "C:\> tracert [ip-address]                # Trace route to destination"
    
    Write-Host ""
    Write-Host "  Press any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Initialise-Evaluation {
    Clear-Host
    Write-Header "Packet Tracer Assignment Evaluation Tool"
    
    Write-Info "This tool will guide you through evaluating a student's Packet Tracer submission."
    Write-Info "For each section, you'll check specific requirements and assign a rating from 1-5."
    Write-Info "Enter '?' at any prompt to view the command reference guide."
    
    Write-SubHeader "Student Information"
    
    Write-Host "  Student Name: " -NoNewline
    $script:evaluationData.StudentName = Read-Host
    
    Write-Host "  Student ID: " -NoNewline
    $script:evaluationData.StudentID = Read-Host
    
    # Set submission filename to be student ID.
    $script:evaluationData.SubmissionFile = "$($script:evaluationData.StudentID)"

    Write-Host " Setting Submission file to: $($script:evaluationData.SubmissionFile)"
    
    Write-Success "Evaluation initialised. Let's begin the assessment."
}

function Evaluate-SiteCreation {
    Write-SubHeader "1. Site Creation and Structure"
    
    Write-Info "VERIFICATION STEPS:"
    Write-Info "1. Open the student's .pka file in Packet Tracer"
    Write-Info "2. Switch to Logical View if not already active (View menu → Logical)"
    Write-Info "3. Count the separate network segments visible in the topology"
    Write-Info "4. Verify each site has a switch connecting multiple PCs"
    Write-Info "5. Check for labels or naming conventions that identify sites"
    Write-Info ""
    Write-Info "CHECK FOR: Clients sites plus 1 data center site"
    Write-Info ""
    
    Write-Host "  Has the student created the correct number of sites? (y/n/? for help): " -NoNewline
    $hasCorrectSites = Read-Host
    
    if ($hasCorrectSites -eq "?") {
        Write-Info ""
        Write-Info "Count all separate network segments. Look for:"
        Write-Info "- Clear separation between sites (usually indicated by routers connecting segments)"
        Write-Info "- Each site should have a switch connecting multiple PCs"
        Write-Info "- The data center should have a server device connected to its switch"
        Write-Info ""
        Write-Host "  Has the student created the correct number of sites? (y/n): " -NoNewline
        $hasCorrectSites = Read-Host
    }
    
    if ($hasCorrectSites -eq "y") {
        Write-Success "Student has created the correct number of sites."
    }
    else {
        Write-CustomError "Student has not created the required number of sites."
        Write-Hint "Check for client sites plus 1 data center site."
        Write-Hint "Some students may have also added more data centers/servers than required."
    }
    
    Write-Host ""
    Write-Host "  Does the student follow the correct PC naming/numbering convention? (y/n/? for help): " -NoNewline
    $hasCorrectNaming = Read-Host
    
    if ($hasCorrectNaming -eq "?") {
        Write-Info ""
        Write-Info "For sites with >3 users, only PC1, PC2, and PCn should be created where n is max PC number."
        Write-Info "Example: If site 4 has 7 users, only 'Site4-PC1', 'Site4-PC2', and 'Site4-PC7' should exist."
        Write-Info "To check PC names in Packet Tracer:"
        Write-Info "1. Click on each PC device"
        Write-Info "2. Look at the device name in the bottom left corner or Config tab → Global Settings"
        Write-Info ""
        Write-Host "  Does the student follow the correct PC naming/numbering convention? (y/n): " -NoNewline
        $hasCorrectNaming = Read-Host
    }
    
    if ($hasCorrectNaming -eq "y") {
        Write-Success "Sites follow the correct PC naming/numbering convention."
    }
    else {
        Write-CustomError "Sites do not follow the correct PC naming/numbering convention."
        Write-Hint "For sites with >3 users, only PC1, PC2, and PCn should be created."
    }
    
    Write-Host ""
    Write-Host "  Have the PCs been placed in the logical view (not physical)? (y/n/? for help): " -NoNewline
    $isLogicalView = Read-Host
    
    if ($isLogicalView -eq "?") {
        Write-Info ""
        Write-Info "The assignment requires using logical view rather than physical view."
        Write-Info "To verify:"
        Write-Info "1. Check if the current view is logical (View menu → check if Logical is selected)"
        Write-Info "2. If in physical view, switch to logical view and verify all devices are properly arranged"
        Write-Info ""
        Write-Host "  Have the PCs been placed in the logical view (not physical)? (y/n): " -NoNewline
        $isLogicalView = Read-Host
    }
    
    if ($isLogicalView -eq "y") {
        Write-Success "Student has used the logical view as required."
    }
    else {
        Write-CustomError "Student has not used the logical view."
        Write-Hint "The assignment specifically requires using logical view, not physical view."
    }
    
    Get-Rating -Category "SiteCreation" -Prompt "Rate the site creation and structure"
    Get-Comment -Category "SiteCreation" -Prompt "Enter any comments for this section"
}

function Evaluate-SiteConnectivity {
    Write-SubHeader "2. Internal Site Connectivity"
    
    Write-Info "VERIFICATION STEPS:"
    Write-Info "1. For each site, check that PCs are connected to switches"
    Write-Info "2. Verify appropriate devices (switches) are used within each site"
    Write-Info "3. Test if PCs within the same site can communicate with each other"
    Write-Info ""
    
    Write-Host "  Are the PCs within each site connected using appropriate devices? (y/n/? for help): " -NoNewline
    $hasAppropriateSiteConnections = Read-Host
    
    if ($hasAppropriateSiteConnections -eq "?") {
        Write-Info ""
        Write-Info "Verify that within each site:"
        Write-Info "1. All PCs are connected to switch(es)"
        Write-Info "2. Switches are used for LAN connectivity (not hubs or routers)"
        Write-Info "3. Connections use appropriate media (typically FastEthernet)"
        Write-Info ""
        Write-Host "  Are the PCs within each site connected using appropriate devices? (y/n): " -NoNewline
        $hasAppropriateSiteConnections = Read-Host
    }
    
    if ($hasAppropriateSiteConnections -eq "y") {
        Write-Success "PCs within sites are connected using appropriate devices."
    }
    else {
        Write-CustomError "PCs within sites are not connected using appropriate devices."
        Write-Hint "Check if switches or other appropriate layer 2 devices are used within each site."
    }
    
    Write-Host ""
    Write-Host "  Can PCs within the same site communicate with each other? (y/n/? for help): " -NoNewline
    $canCommunicateInternally = Read-Host
    
    if ($canCommunicateInternally -eq "?") {
        Write-Info ""
        Write-Info "To test internal site connectivity in Packet Tracer:"
        Write-Info "1. Click on a PC within a site"
        Write-Info "2. Open Command Prompt (Desktop tab → Command Prompt)"
        Write-Info "3. Use the ping command to test connectivity to another PC in the same site:"
        Write-Command "C:\> ping [IP address of another PC in the same site]"
        Write-Info "4. Successful pings will show 'Reply from [IP]...'"
        Write-Info "5. Test at least one site to confirm internal connectivity"
        Write-Info ""
        Write-Host "  Can PCs within the same site communicate with each other? (y/n): " -NoNewline
        $canCommunicateInternally = Read-Host
    }
    
    if ($canCommunicateInternally -eq "y") {
        Write-Success "PCs within the same site can communicate with each other."
    }
    else {
        Write-CustomError "PCs within the same site cannot communicate with each other."
        Write-Hint "Check IP addressing, subnet masks, and connectivity between devices."
    }
    
    Get-Rating -Category "SiteConnectivity" -Prompt "Rate the internal site connectivity"
    Get-Comment -Category "SiteConnectivity" -Prompt "Enter any comments for this section"
}

function Evaluate-DataCentre {
    Write-SubHeader "3. Data Centre Configuration"
    
    Write-Info "VERIFICATION STEPS:"
    Write-Info "1. Locate the data center site in the topology"
    Write-Info "2. Verify that at least one server device is present"
    Write-Info "3. Check if HTTP service is enabled on the server"
    Write-Info "4. Verify appropriate intermediate devices connect the server"
    Write-Info ""
    
    Write-Host "  Has a data centre site been created? (y/n/? for help): " -NoNewline
    $hasDataCentre = Read-Host
    
    if ($hasDataCentre -eq "?") {
        Write-Info ""
        Write-Info "To identify the data center:"
        Write-Info "1. Look for a network segment containing server device(s)"
        Write-Info "2. May be labeled as 'Data Center' or similar"
        Write-Info "3. Should be separated from other sites, connected via a router"
        Write-Info ""
        Write-Host "  Has a data centre site been created? (y/n): " -NoNewline
        $hasDataCentre = Read-Host
    }
    
    if ($hasDataCentre -eq "y") {
        Write-Success "Data centre site has been created."
    }
    else {
        Write-CustomError "Data centre site has not been created."
        Write-Hint "The requirement specifies a site for the company data centre."
    }
    
    Write-Host ""
    Write-Host "  Is there a server in the data centre? (y/n/? for help): " -NoNewline
    $hasServer = Read-Host
    
    if ($hasServer -eq "?") {
        Write-Info ""
        Write-Info "To verify server presence:"
        Write-Info "1. Look for 'Server-PT' device in the data center"
        Write-Info "2. Click on the device to confirm it's a server"
        Write-Info ""
        Write-Host "  Is there a server in the data centre? (y/n): " -NoNewline
        $hasServer = Read-Host
    }
    
    if ($hasServer -eq "y") {
        Write-Success "Server has been added to the data centre."
    }
    else {
        Write-CustomError "Server has not been added to the data centre."
        Write-Hint "A server should be added using Packet Tracer's server objects."
    }
    
    Write-Host ""
    Write-Host "  Is the server correctly configured for HTTP service? (y/n/? for help): " -NoNewline
    $hasCorrectConfig = Read-Host
    
    if ($hasCorrectConfig -eq "?") {
        Write-Info ""
        Write-Info "To check HTTP service configuration:"
        Write-Info "1. Click on the server device to select it"
        Write-Info "2. Click on the 'Config' tab in the right panel"
        Write-Info "3. Navigate to the 'Services' section"
        Write-Info "4. Check if HTTP service is enabled (should be 'On')"
        Write-Info "5. If not enabled, it should show HTTP with an 'Off' status"
        Write-Info ""
        Write-Host "  Is the server correctly configured for HTTP service? (y/n): " -NoNewline
        $hasCorrectConfig = Read-Host
    }
    
    if ($hasCorrectConfig -eq "y") {
        Write-Success "Server is correctly configured for HTTP service."
    }
    else {
        Write-CustomError "Server is not correctly configured for HTTP service."
        Write-Hint "HTTP should be enabled in the Services menu of the server."
    }
    
    Write-Host ""
    Write-Host "  Are appropriate intermediate devices used to connect the server? (y/n/? for help): " -NoNewline
    $hasAppropriateDCConnections = Read-Host
    
    if ($hasAppropriateDCConnections -eq "?") {
        Write-Info ""
        Write-Info "To verify intermediate devices:"
        Write-Info "1. Check if the server is connected to a switch (not directly to a router)"
        Write-Info "2. Verify the data center switch is connected to a router for WAN connectivity"
        Write-Info "3. Check if appropriate cabling is used (typically FastEthernet or GigabitEthernet)"
        Write-Info ""
        Write-Host "  Are appropriate intermediate devices used to connect the server? (y/n): " -NoNewline
        $hasAppropriateDCConnections = Read-Host
    }
    
    if ($hasAppropriateDCConnections -eq "y") {
        Write-Success "Appropriate intermediate devices are used in the data centre."
    }
    else {
        Write-CustomError "Appropriate intermediate devices are not used in the data centre."
        Write-Hint "Check if the server is connected using appropriate network devices."
    }
    
    Get-Rating -Category "DataCentre" -Prompt "Rate the data centre configuration"
    Get-Comment -Category "DataCentre" -Prompt "Enter any comments for this section"
}

function Evaluate-WANConnectivity {
    Write-SubHeader "4. WAN Connectivity"
    
    Write-Info "VERIFICATION STEPS:"
    Write-Info "1. Examine connections between sites (router-to-router connections)"
    Write-Info "2. Verify connection types are either Fiber or Serial (per requirements)"
    Write-Info "3. Check interface configurations on routers"
    Write-Info "4. Verify complete connectivity between all sites"
    Write-Info "5. Check for redundant WAN links or fault tolerance features"
    Write-Info ""
    
    Write-Host "  Are the sites connected using WAN connections? (y/n/? for help): " -NoNewline
    $hasWANConnections = Read-Host
    
    if ($hasWANConnections -eq "?") {
        Write-Info ""
        Write-Info "To check WAN connections:"
        Write-Info "1. Look for router-to-router connections between sites"
        Write-Info "2. Verify each site has at least one connection to another site"
        Write-Info "3. Ensure there are no isolated sites"
        Write-Info ""
        Write-Host "  Are the sites connected using WAN connections? (y/n): " -NoNewline
        $hasWANConnections = Read-Host
    }
    
    if ($hasWANConnections -eq "y") {
        Write-Success "Sites are connected using WAN connections."
    }
    else {
        Write-CustomError "Sites are not connected using WAN connections."
        Write-Hint "Check if the sites are connected through WAN links."
    }
    
    Write-Host ""
    Write-Host "  Are the WAN connections using Fiber or Serial as specified? (y/n/? for help): " -NoNewline
    $hasCorrectWANType = Read-Host
    
    if ($hasCorrectWANType -eq "?") {
        Write-Info ""
        Write-Info "To verify connection types:"
        Write-Info "1. Click on a connection line between routers"
        Write-Info "2. A popup will appear showing the connection type"
        Write-Info "3. Verify it's either Fiber or Serial (acceptable types per requirements)"
        Write-Info "4. Copper connections between sites are NOT acceptable per requirements"
        Write-Info ""
        Write-Info "Alternatively, check router interfaces:"
        Write-Command "Router> enable"
        Write-Command "Router# show ip interface brief"
        Write-Command "# Look for Serial0/x/x or GigabitEthernet0/x interfaces"
        Write-Info ""
        Write-Host "  Are the WAN connections using Fiber or Serial as specified? (y/n): " -NoNewline
        $hasCorrectWANType = Read-Host
    }
    
    if ($hasCorrectWANType -eq "y") {
        Write-Success "WAN connections use the correct technologies (Fiber or Serial)."
    }
    else {
        Write-CustomError "WAN connections do not use the correct technologies."
        Write-Hint "The specification requires either Fiber or synchronous serial connections."
    }
    
    Write-Host ""
    Write-Host "  Are appropriate intermediate devices used for WAN connections? (y/n/? for help): " -NoNewline
    $hasWANDevices = Read-Host
    
    if ($hasWANDevices -eq "?") {
        Write-Info ""
        Write-Info "Appropriate WAN devices include:"
        Write-Info "1. Routers at each site connecting to other sites"
        Write-Info "2. The right interface modules for the connection type (serial/fiber)"
        Write-Info ""
        Write-Info "To check router interface configuration:"
        Write-Command "Router> enable"
        Write-Command "Router# show ip interface brief"
        Write-Command "# Check if interfaces are 'up' and have IP addresses assigned"
        Write-Info ""
        Write-Host "  Are appropriate intermediate devices used for WAN connections? (y/n): " -NoNewline
        $hasWANDevices = Read-Host
    }
    
    if ($hasWANDevices -eq "y") {
        Write-Success "Appropriate intermediate devices are used for WAN connections."
    }
    else {
        Write-CustomError "Appropriate intermediate devices are not used for WAN connections."
        Write-Hint "Check if routers or other appropriate devices are used for WAN connectivity."
    }
    
    Get-Rating -Category "WANConnectivity" -Prompt "Rate the WAN connectivity implementation"
    Get-Comment -Category "WANConnectivity" -Prompt "Enter any comments for this section"
}

function Evaluate-DeviceConfiguration {
    Write-SubHeader "5. Intermediate Device Configuration"
    
    Write-Info "VERIFICATION STEPS:"
    Write-Info "1. Check routing protocol configuration on routers"
    Write-Info "2. Verify interface configurations for proper traffic forwarding"
    Write-Info "3. Check routing tables to confirm all networks are reachable"
    Write-Info "4. Test inter-site connectivity"
    Write-Info ""
    
    Write-Host "  Are the intermediate devices properly configured for traffic forwarding? (y/n/? for help): " -NoNewline
    $hasProperConfig = Read-Host
    
    if ($hasProperConfig -eq "?") {
        Write-Info ""
        Write-Info "To check routing configuration:"
        Write-Info "1. Click on a router and select CLI tab"
        Write-Info "2. Enter these commands to check routing configuration:"
        Write-Command "Router> enable"
        Write-Command "Router# show ip protocols"
        Write-Info "   (Shows if RIP, OSPF, EIGRP, etc. is configured)"
        Write-Command "Router# show ip route"
        Write-Info "   (Shows routing table with routes to all networks)"
        Write-Info ""
        Write-Host "  Are the intermediate devices properly configured for traffic forwarding? (y/n): " -NoNewline
        $hasProperConfig = Read-Host
    }
    
    if ($hasProperConfig -eq "y") {
        Write-Success "Intermediate devices are properly configured for traffic forwarding."
    }
    else {
        Write-CustomError "Intermediate devices are not properly configured for traffic forwarding."
        Write-Hint "Check routing tables, interface configurations, and network addressing."
    }
    
    Write-Host ""
    Write-Host "  Can traffic flow between different sites? (y/n/? for help): " -NoNewline
    $canRouteTraffic = Read-Host
    
    if ($canRouteTraffic -eq "?") {
        Write-Info ""
        Write-Info "To test inter-site connectivity:"
        Write-Info "1. Select a PC in one site"
        Write-Info "2. Open Command Prompt (Desktop tab → Command Prompt)"
        Write-Info "3. Ping a device in another site:"
        Write-Command "C:\> ping [IP address of device in another site]"
        Write-Info ""
        Write-Info "Alternative method using Simulation mode:"
        Write-Info "1. Click on the 'Simulation' tab at the bottom right"
        Write-Info "2. Click on a source device"
        Write-Info "3. Select 'Simple PDU' from the right panel"
        Write-Info "4. Click on a destination device in another site"
        Write-Info "5. Click 'Capture/Forward' to see if the packet reaches its destination"
        Write-Info ""
        Write-Host "  Can traffic flow between different sites? (y/n): " -NoNewline
        $canRouteTraffic = Read-Host
    }
    
    if ($canRouteTraffic -eq "y") {
        Write-Success "Traffic can flow between different sites."
    }
    else {
        Write-CustomError "Traffic cannot flow between different sites."
        Write-Hint "Test connectivity between devices in different sites."
    }
    
    Write-Host ""
    Write-Host "  Are there any routing or switching issues? (y/n/? for help): " -NoNewline
    $hasRoutingIssues = Read-Host
    
    if ($hasRoutingIssues -eq "?") {
        Write-Info ""
        Write-Info "Common routing/switching issues to check for:"
        Write-Info "1. Missing routes in routing tables (check with 'show ip route')"
        Write-Info "2. Inconsistent routing protocols across routers"
        Write-Info "3. Interface status issues (down/down or administratively down)"
        Write-Info "4. Mismatched IP addressing on WAN links"
        Write-Info "5. Incorrect subnet masks"
        Write-Info ""
        Write-Host "  Are there any routing or switching issues? (y/n): " -NoNewline
        $hasRoutingIssues = Read-Host
    }
    
    if ($hasRoutingIssues -eq "n") {
        Write-Success "No routing or switching issues detected."
    }
    else {
        Write-CustomError "Routing or switching issues detected."
        Write-Hint "Identify specific issues in the routing or switching configuration."
    }
    
    Get-Rating -Category "DeviceConfiguration" -Prompt "Rate the intermediate device configuration"
    Get-Comment -Category "DeviceConfiguration" -Prompt "Enter any comments for this section"
}

function Evaluate-WebServerAccess {
    Write-SubHeader "6. Web Server Access"
    
    Write-Info "VERIFICATION STEPS:"
    Write-Info "1. Identify the web server's IP address in the data center"
    Write-Info "2. Test access to the web server from PCs in different sites"
    Write-Info "3. Verify that web pages load successfully"
    Write-Info ""
    
    Write-Host "  Can all PCs across all sites access the web server? (y/n/? for help): " -NoNewline
    $canAccessServer = Read-Host
    
    if ($canAccessServer -eq "?") {
        Write-Info ""
        Write-Info "To test web server access:"
        Write-Info "1. Identify the web server's IP address (click on server → Config tab)"
        Write-Info "2. From a client PC in any site:"
        Write-Info "   a. Click on the PC"
        Write-Info "   b. Click on the 'Desktop' tab"
        Write-Info "   c. Click on the 'Web Browser' icon"
        Write-Info "   d. Enter the URL: http://[server-IP-address]"
        Write-Info "   e. Click 'Go' or press Enter"
        Write-Info "3. A successful connection will display a web page"
        Write-Info "4. Test from at least one PC in each site"
        Write-Info ""
        Write-Info "Alternative test using ping:"
        Write-Command "C:\> ping [server-IP-address]"
        Write-Info ""
        Write-Host "  Can all PCs across all sites access the web server? (y/n): " -NoNewline
        $canAccessServer = Read-Host
    }
    
    if ($canAccessServer -eq "y") {
        Write-Success "All PCs can access the web server."
    }
    else {
        Write-CustomError "Not all PCs can access the web server."
        Write-Hint "Test HTTP connectivity from each site to the data centre server."
    }
    
    Write-Host ""
    Write-Host "  Is the server accessibility correctly configured as an intranet server? (y/n/? for help): " -NoNewline
    $isCorrectAccess = Read-Host
    
    if ($isCorrectAccess -eq "?") {
        Write-Info ""
        Write-Info "The web server should be configured as an intranet server, meaning:"
        Write-Info "1. It should be accessible from all internal sites"
        Write-Info "2. It should NOT be accessible from outside the company network"
        Write-Info "   (Note: In Packet Tracer, this is generally implied if there's no"
        Write-Info "    external connection to the internet in the topology)"
        Write-Info ""
        Write-Host "  Is the server accessibility correctly configured as an intranet server? (y/n): " -NoNewline
        $isCorrectAccess = Read-Host
    }
    
    if ($isCorrectAccess -eq "y") {
        Write-Success "Server accessibility is correctly configured as an intranet server."
    }
    else {
        Write-CustomError "Server accessibility is not correctly configured as an intranet server."
        Write-Hint "The server should not be accessible from outside the client's network."
    }
    
    Get-Rating -Category "WebServerAccess" -Prompt "Rate the server access implementation"
    Get-Comment -Category "WebServerAccess" -Prompt "Enter any comments for this section"
}

function Evaluate-OverallImplementation {
    Write-SubHeader "7. Overall Implementation and Design"
    
    Write-Info "VERIFICATION STEPS:"
    Write-Info "1. Evaluate the overall network topology design (efficiency, organisation)"
    Write-Info "2. Check for redundant links and scalability features"
    Write-Info "3. Assess the implementation of networking best practices"
    Write-Info ""
    
    Write-Host "  Is the network design efficient and well-organised? (y/n/? for help): " -NoNewline
    $isEfficient = Read-Host
    
    if ($isEfficient -eq "?") {
        Write-Info ""
        Write-Info "Efficient network design characteristics:"
        Write-Info "1. Logical topology layout (easy to identify sites and connections)"
        Write-Info "2. Appropriate network hierarchy (core, distribution, access layers)"
        Write-Info "3. Efficient use of IP address space"
        Write-Info "4. Well-organised device placement and labeling"
        Write-Info "5. No unnecessary devices or connections"
        Write-Info ""
        Write-Host "  Is the network design efficient and well-organised? (y/n): " -NoNewline
        $isEfficient = Read-Host
    }
    
    if ($isEfficient -eq "y") {
        Write-Success "Network design is efficient and well-organised."
    }
    else {
        Write-Warning "Network design could be more efficient and better organised."
        Write-Hint "Consider how the network topology and  could be improved."
    }
    
    Write-Host ""
    Write-Host "  Is the implementation scalable for future growth? (y/n/? for help): " -NoNewline
    $isScalable = Read-Host
    
    if ($isScalable -eq "?") {
        Write-Info ""
        Write-Info "Scalability features to look for:"
        Write-Info "1. Subnet sizing that allows for 20% growth at each site"
        Write-Info "2. Topology that allows adding new sites (e.g., hierarchical design)"
        Write-Info "3. Routing protocol that can adapt to network changes"
        Write-Info "4. Space for additional servers in the data center subnet"
        Write-Info "5. Consideration for two additional future sites"
        Write-Info ""
        Write-Host "  Is the implementation scalable for future growth? (y/n): " -NoNewline
        $isScalable = Read-Host
    }
    
    if ($isScalable -eq "y") {
        Write-Success "Implementation is scalable for future growth."
    }
    else {
        Write-Warning "Implementation may not be sufficiently scalable."
        Write-Hint "Consider how additional sites or users could be added to the network."
    }
    
    Write-Host ""
    Write-Host "  Does the implementation demonstrate understanding of networking concepts? (y/n/? for help): " -NoNewline
    $showsUnderstanding = Read-Host
    
    if ($showsUnderstanding -eq "?") {
        Write-Info ""
        Write-Info "Look for evidence of networking knowledge such as:"
        Write-Info "1. Proper use of routing protocols (RIP, OSPF, EIGRP)"
        Write-Info "2. Appropriate device selection for different network functions"
        Write-Info "3. Correct subnetting and addressing scheme"
        Write-Info "4. Logical network topology design"
        Write-Info "5. Separation of network functions (LAN vs WAN)"
        Write-Info "6. Implementation of redundancy where appropriate"
        Write-Info ""
        Write-Host "  Does the implementation demonstrate understanding of networking concepts? (y/n): " -NoNewline
        $showsUnderstanding = Read-Host
    }
    
    if ($showsUnderstanding -eq "y") {
        Write-Success "Implementation demonstrates understanding of networking concepts."
    }
    else {
        Write-Warning "Implementation shows limited understanding of networking concepts."
        Write-Hint "Consider whether the design shows proper application of networking principles."
    }
    
    Get-Rating -Category "OverallImplementation" -Prompt "Rate the overall implementation and design"
    Get-Comment -Category "OverallImplementation" -Prompt "Enter any comments for this section"
}

function Show-StarRatingGuide {
    Write-SubHeader "Star Rating Criteria Guide"
    
    Write-Info "5 STARS: Excellent implementation meeting all requirements"
    Write-Info "- All 6 sites + data center properly created and configured"
    Write-Info "- Correct PC implementation (PC1, PC2, PCn only)"
    Write-Info "- Dynamic routing protocol properly implemented"
    Write-Info "- Redundant WAN links for fault tolerance"
    Write-Info "- Web server accessible from all sites"
    Write-Info "- WAN subnets properly sized and documented"
    Write-Info "- Full connectivity between all sites"
    Write-Info ""
    
    Write-Info "4 STARS: Good implementation with minor issues"
    Write-Info "- All sites created and configured"
    Write-Info "- Dynamic routing implemented but may not be optimised"
    Write-Info "- May lack redundant links OR have PC implementation issues"
    Write-Info "- Web server accessible from all sites"
    Write-Info "- Full connectivity between all sites"
    Write-Info ""
    
    Write-Info "3 STARS: Functional implementation with significant issues"
    Write-Info "- All sites created"
    Write-Info "- Basic routing implemented (static or dynamic)"
    Write-Info "- Multiple shortcomings in design (PC issues, lack of redundancy)"
    Write-Info "- Web server accessible but may have issues from some sites"
    Write-Info "- Basic connectivity works between most sites"
    Write-Info ""
    
    Write-Info "2 STARS: Basic implementation with major issues"
    Write-Info "- Sites created but may be missing some"
    Write-Info "- Basic connectivity established but significant issues"
    Write-Info "- Static routing only or problematic dynamic routing"
    Write-Info "- Limited functionality"
    Write-Info ""
    
    Write-Info "1 STAR: Minimal implementation"
    Write-Info "- Few changes from the template"
    Write-Info "- Major elements missing or non-functional"
    Write-Info "- Basic structure only"
    
    Write-Host ""
    Write-Host "  Press any key to continue..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Generate-SummaryReport {
    $endTime = Get-Date
    $duration = $endTime - $script:evaluationData.StartTime
    
    # Calculate percentage score
    $percentageScore = [math]::Round(($script:evaluationData.OverallScore / $script:evaluationData.MaxPossibleScore) * 100, 1)
    
    # Calculate average star rating (out of 5)
    $averageRating = [math]::Round($script:evaluationData.OverallScore / $script:evaluationData.Ratings.Count, 1)
    
    # Convert average rating to stars
    $starRating = ""
    $fullStars = [Math]::Round($averageRating)
    
    for ($i = 0; $i -lt $fullStars; $i++) {
        $starRating += "*"
    }
    
    for ($i = $fullStars; $i -lt 5; $i++) {
        $starRating += "-"
    }
    
    # Determine overall assessment
    $overallAssessment = switch ($percentageScore) {
        {$_ -ge 90} { "Excellent"; break }
        {$_ -ge 80} { "Very Good"; break }
        {$_ -ge 70} { "Good"; break }
        {$_ -ge 60} { "Satisfactory"; break }
        {$_ -ge 50} { "Adequate"; break }
        default { "Needs Improvement" }
    }
    
    # Generate report
    Clear-Host
    Write-Header "Evaluation Summary Report"
    
    Write-Info "Student: $($script:evaluationData.StudentName) ($($script:evaluationData.StudentID))"
    Write-Info "Submission: $($script:evaluationData.SubmissionFile)"
    Write-Info "Evaluation completed: $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))"
    Write-Info "Evaluation duration: $($duration.ToString('hh\:mm\:ss'))"
    Write-Info "Overall Rating: $starRating ($averageRating/5.0)"
    Write-Info "Percentage Score: $percentageScore%"
    Write-Info "Overall Assessment: $overallAssessment"
    
    Write-SubHeader "Category Ratings"
    
    foreach ($category in $script:evaluationData.Ratings.Keys | Sort-Object) {
        $rating = $script:evaluationData.Ratings[$category]
        
        # Create stars string
        $stars = ""
        $fullStars = [Math]::Round($rating)
        
        for ($i = 0; $i -lt $fullStars; $i++) {
            $stars += "*"
        }
        
        for ($i = $fullStars; $i -lt 5; $i++) {
            $stars += "-"
        }
        
        # Format category name for display
        $displayName = Format-CategoryName -Name $category
        
        Write-Host "  $displayName`: $stars ($rating/5)" -ForegroundColor White
        
        if ($script:evaluationData.Comments.ContainsKey($category) -and 
            -not [string]::IsNullOrWhiteSpace($script:evaluationData.Comments[$category])) {
            Write-Host "    Comment: $($script:evaluationData.Comments[$category])" -ForegroundColor Gray
        }
    }
    
    Write-SubHeader "Feedback Recommendations"
    
    # Generate automatic feedback suggestions based on ratings
    foreach ($category in $script:evaluationData.Ratings.Keys | Sort-Object) {
        $rating = $script:evaluationData.Ratings[$category]
        $displayName = Format-CategoryName -Name $category
        
        if ($rating -le 2) {
            Write-CustomError "Areas for Improvement - $displayName`:"
            
            switch ($category) {
                "SiteCreation" {
                    Write-Info "  - Ensure correct number of sites are created as per requirements"
                    Write-Info "  - Follow the specified numbering scheme for PCs"
                    Write-Info "  - Use logical view instead of physical view"
                }
                "SiteConnectivity" {
                    Write-Info "  - Review internal connectivity within sites"
                    Write-Info "  - Ensure appropriate devices are used to connect PCs"
                    Write-Info "  - Verify IP addressing, subnet masks, and connectivity between devices"
                }
                "DataCentre" {
                    Write-Info "  - Create an appropriate data centre site with required server(s)"
                    Write-Info "  - Configure the server(s) for the required services"
                    Write-Info "  - Use appropriate intermediate devices"
                }
                "WANConnectivity" {
                    Write-Info "  - Implement WAN connections using the required technologies"
                    Write-Info "  - Ensure all sites are properly connected"
                    Write-Info "  - Use appropriate WAN devices"
                }
                "DeviceConfiguration" {
                    Write-Info "  - Configure intermediate devices for proper traffic forwarding"
                    Write-Info "  - Review routing tables and interface configurations"
                    Write-Info "  - Ensure traffic can flow between sites"
                }
                "WebServerAccess" {
                    Write-Info "  - Ensure all PCs can access the required server(s)"
                    Write-Info "  - Configure server accessibility according to requirements"
                    Write-Info "  - Test connectivity from all sites"
                }
                "OverallImplementation" {
                    Write-Info "  - Improve efficiency and organisation of network design"
                    Write-Info "  - Consider scalability for future growth"
                    Write-Info "  - Demonstrate better understanding of networking concepts"
                }
            }
        }
        elseif ($rating -ge 4) {
            Write-Success "Strengths - $displayName"
        }
    }
    
    Write-SubHeader "Report Export Options"
    
    Write-Host "  Export report to a file? (y/n): " -NoNewline
    $exportChoice = Read-Host
    
    if ($exportChoice -eq "y") {
        # Set filename to student ID
        $filename = "$($script:evaluationData.StudentID).txt"
        Write-Host "  Report will be saved as: $filename"
        
        # Prepare report content
        $reportContent = @"
========================================================
Packet Tracer Assignment Evaluation Report
========================================================

Student: $($script:evaluationData.StudentName) ($($script:evaluationData.StudentID))
Submission: $($script:evaluationData.SubmissionFile)
Evaluation completed: $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))
Evaluation duration: $($duration.ToString('hh\:mm\:ss'))
Overall Rating: $averageRating/5.0 ($percentageScore%)
Overall Assessment: $overallAssessment

--------------------------------------------------------
Category Ratings
--------------------------------------------------------
"@
        
        foreach ($category in $script:evaluationData.Ratings.Keys | Sort-Object) {
            $rating = $script:evaluationData.Ratings[$category]
            $displayName = Format-CategoryName -Name $category
            
            $reportContent += "`n$displayName`: $rating/5"
            
            if ($script:evaluationData.Comments.ContainsKey($category) -and 
                -not [string]::IsNullOrWhiteSpace($script:evaluationData.Comments[$category])) {
                $reportContent += "`n  Comment: $($script:evaluationData.Comments[$category])"
            }
        }
        
        $reportContent += @"

--------------------------------------------------------
Feedback Recommendations
--------------------------------------------------------
"@
        
        # Add feedback recommendations
        foreach ($category in $script:evaluationData.Ratings.Keys | Sort-Object) {
            $rating = $script:evaluationData.Ratings[$category]
            $displayName = Format-CategoryName -Name $category
            
            if ($rating -le 2) {
                $reportContent += "`nAreas for Improvement - $displayName`:"
                
                switch ($category) {
                    "SiteCreation" {
                        $reportContent += "`n  - Ensure correct number of sites are created as per requirements"
                        $reportContent += "`n  - Follow the specified numbering scheme for PCs"
                        $reportContent += "`n  - Use logical view instead of physical view"
                    }
                    "SiteConnectivity" {
                        $reportContent += "`n  - Review internal connectivity within sites"
                        $reportContent += "`n  - Ensure appropriate devices are used to connect PCs"
                        $reportContent += "`n  - Verify IP addressing, subnet masks, and connectivity between devices"
                    }
                    "DataCentre" {
                        $reportContent += "`n  - Create an appropriate data centre site with required server(s)"
                        $reportContent += "`n  - Configure the server(s) for the required services"
                        $reportContent += "`n  - Use appropriate intermediate devices"
                    }
                    "WANConnectivity" {
                        $reportContent += "`n  - Implement WAN connections using the required technologies"
                        $reportContent += "`n  - Ensure all sites are properly connected"
                        $reportContent += "`n  - Use appropriate WAN devices"
                    }
                    "DeviceConfiguration" {
                        $reportContent += "`n  - Configure intermediate devices for proper traffic forwarding"
                        $reportContent += "`n  - Review routing tables and interface configurations"
                        $reportContent += "`n  - Ensure traffic can flow between sites"
                    }
                    "WebServerAccess" {
                        $reportContent += "`n  - Ensure all PCs can access the required server(s)"
                        $reportContent += "`n  - Configure server accessibility according to requirements"
                        $reportContent += "`n  - Test connectivity from all sites"
                    }
                    "OverallImplementation" {
                        $reportContent += "`n  - Improve efficiency and organisation of network design"
                        $reportContent += "`n  - Consider scalability for future growth"
                        $reportContent += "`n  - Demonstrate better understanding of networking concepts"
                    }
                }
            }
            elseif ($rating -ge 4) {
                $reportContent += "`nStrengths - $displayName"
            }
        }
        
        # Export to file
        try {
            $reportContent | Out-File -FilePath $filename -Encoding utf8 -Force
            Write-Success "Report exported to $filename"
        }
        catch {
            Write-CustomError "Failed to export report: $_"
        }
    }
}

function Show-MainMenu {
    do {
        Clear-Host
        Write-Header "Packet Tracer Evaluation Menu"
        
        Write-Info "1. Initialise new evaluation"
        Write-Info "2. Site Creation and Structure"
        Write-Info "3. Internal Site Connectivity"
        Write-Info "4. Data Centre Configuration"
        Write-Info "5. WAN Connectivity"
        Write-Info "6. Intermediate Device Configuration"
        Write-Info "7. Web Server Access"
        Write-Info "8. Overall Implementation and Design"
        Write-Info "9. Generate Summary Report"
        Write-Info "10. Show Command Reference"
        Write-Info "11. Show Star Rating Guide"
        Write-Info "0. Exit"
        
        Write-Host ""
        Write-Host "  Select an option (0-11): " -ForegroundColor Yellow -NoNewline
        $choice = Read-Host
        
        switch ($choice) {
            "1" { Initialise-Evaluation }
            "2" { Evaluate-SiteCreation }
            "3" { Evaluate-SiteConnectivity }
            "4" { Evaluate-DataCentre }
            "5" { Evaluate-WANConnectivity }
            "6" { Evaluate-DeviceConfiguration }
            "7" { Evaluate-WebServerAccess }
            "8" { Evaluate-OverallImplementation }
            "9" { Generate-SummaryReport }
            "10" { Show-CommandReference }
            "11" { Show-StarRatingGuide }
            "0" { return }
            "?" { Show-CommandReference }
            default { Write-CustomError "Invalid option. Press any key to continue..."; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
        }
        
        if ($choice -ne "0" -and $choice -ne "9") {
            Write-Host ""
            Write-Host "  Press any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    } while ($choice -ne "0")
}

# Main script execution
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
    Write-Host "Thank you for using the Packet Tracer Evaluation Tool." -ForegroundColor Cyan
}