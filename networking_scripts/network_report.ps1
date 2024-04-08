# Define the location of the output HTML file
$htmlFile = ""

# Initial HTML content
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Network Configuration Report</title>
    <style>
        body{ 
            font-family: Arial, sans-serif; 
        }
        
        h1{
            text-align: center; 
        }

        table { 
            border-collapse: collapse; 
            width: 100%; 
        }
        
        th, td{ 
            border: 1px solid #dddddd; 
            text-align: left; 
            padding: 8px; 
        }
        
        th{ 
            background-color: #f2f2f2; 
        }
        
        tr:nth-child(even){ 
            background-color: #f2f2f2; 
        }
    </style>
</head>
<body>
    <h1>Network Configuration Report</h1>
    <table>
        <tr>
            <th>Interface</th>
            <th>Description</th>
            <th>IP Address</th>
            <th>Prefix</th>
            <th>Default Gateway</th>
            <th>DNS Servers</th>
        </tr>
"@

# Get network configuration for all IPv4 interfaces
$interfaceConfigurations = Get-NetIPConfiguration | Where-Object { $_.IPv4Address -ne $null }

# Add each interface to the HTML content
foreach ($interface in $interfaceConfigurations) {
    # Get interface description
    $interfaceDescription = if ($interface.InterfaceDescription) { $interface.InterfaceDescription } else { '-' }

    # Get IP information
    $ipInfo = @{
        IPAddress = if ($interface.IPv4Address.IPAddress) { $interface.IPv4Address.IPAddress } else { '-' }
        Prefix = if ($interface.IPv4Address.PrefixLength) { $interface.IPv4Address.PrefixLength } else { '-' }
    }

    # Get default gateway of the interface
    $interfaceDefaultGateway = if ($interface.IPv4DefaultGateway) { $interface.IPv4DefaultGateway.NextHop } else { '-' }

    # Get DNS servers of the interface
    $interfaceDnsServers = if ($interface.DNSServer.ServerAddresses) { $interface.DNSServer.ServerAddresses -join '<br>' } else { '-' }
    
    # Add a row to the HTML content with interface information
    $htmlContent += @"
        <tr>
            <td>$($interface.InterfaceAlias)</td>
            <td>$($interfaceDescription)</td>
            <td>$($ipInfo.IPAddress)</td>
            <td>$($ipInfo.Prefix)</td>
            <td>$($interfaceDefaultGateway)</td>
            <td>$($interfaceDnsServers)</td>
        </tr>
"@
}

# Close the table and the body of the HTML
$htmlContent += @"
    </table>
</body>
</html>
"@

# Write the HTML content to a file
$htmlContent | Out-File -FilePath $htmlFile

# Open the generated HTML file
Invoke-Item $htmlFile
