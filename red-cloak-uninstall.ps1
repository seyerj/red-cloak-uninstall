###################
# uninstaller Red Cloak
# Josh Seyer
# 03-01-2024
# v 0.01
###################

# Define the application search term
$searchTerm = "red cloak"

# Define the log file path
$logFilePath = "C:\temp\$searchterm-uninstall-log.txt"

# Initialize an empty array to store uninstall results
$uninstallResults = @()

# Query installed applications
$installedApps = Get-WmiObject -Query "SELECT * FROM Win32_Product" | Where-Object { $_.Name -like "*$searchTerm*" }

# Check if any matching applications were found
if ($installedApps) {
    # Loop through each matching application and attempt to uninstall
    foreach ($app in $installedApps) {
        try {
            # Uninstall the application
            $uninstallResult = $app.Uninstall()

            # Add the uninstall result to the array
            $uninstallResults += "Uninstalled $($app.Name): $($uninstallResult.ReturnValue)"
        } catch {
            # If an error occurs during uninstallation, capture the error message
            $errorMessage = $_.Exception.Message

            # Add the error message to the array
            $uninstallResults += "Error uninstalling $($app.Name): $errorMessage"
        }
    }
} else {
    $uninstallResults = "No applications found with the name '$searchTerm'."
}

# Save the uninstall results to the log file
$uninstallResults | Out-File -FilePath $logFilePath

# Display a message indicating the script has completed
Write-Host "Uninstall script completed. Check $logFilePath for results."
