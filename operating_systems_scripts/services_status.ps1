# Configuration of services to monitor
$servicesToMonitor = @(
    "Dhcp",
    "Dnscache",
    "DNS",
    "VDS"
)

# Function to check the status of a service
function CheckServiceStatus {
    param(
        [string]$serviceName
    )

    # Get the service status
    $service = Get-Service -Name $serviceName

    # Check if the service is running
    if ($service.Status -eq "Running") {
        Write-Host "[$serviceName] is running." -ForegroundColor Green
    } else {
        Write-Host "[$serviceName] is NOT running. Alert!" -ForegroundColor Red
        # You can add additional actions here, such as sending an email or logging the event.
    }
}

# Iterate over the list of services to monitor and check their status
foreach ($service in $servicesToMonitor) {
    CheckServiceStatus -serviceName $service
}
