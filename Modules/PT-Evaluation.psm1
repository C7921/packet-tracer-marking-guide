# All evaluation logic for different categories

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


# Module exports
Export-ModuleMember -Function Evaluate-*