# Reference List and Help Commands

function Show-StarRatingGuide {
    Write-SubHeader "Star Rating Criteria Guide"
    
    Write-Info "5 STARS: Excellent implementation meeting all requirements"
    Write-Info "- All sites + data center properly created and configured"
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

# Show helpful PT commands to verify configurations
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

Export-ModuleMember -Function Show-CommandReference, Show-StarRatingGuide, Format-CategoryName