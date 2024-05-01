# Import the Active Directory module
Import-Module ActiveDirectory

# Define the number of days to consider as inactive
$inactiveDays = 90

# Get the current date
$currentDate = Get-Date

# Calculate the date 90 days ago
$inactiveDate = $currentDate.AddDays(-$inactiveDays)

# Retrieve inactive users from Active Directory
$inactiveUsers = Get-ADUser -Filter {LastLogonTimeStamp -lt $inactiveDate -and Enabled -eq $true} -Properties LastLogonTimeStamp

# Filter out active users
$inactiveUsers = $inactiveUsers | Where-Object { $_.LastLogonTimeStamp -ne $null }

# Create custom objects with converted LastLogonTimeStamp to datetime format
$customObjects = foreach ($user in $inactiveUsers) {
    [PSCustomObject]@{
        Name = $user.Name
        SamAccountName = $user.SamAccountName
        LastLogonDateTime = [DateTime]::FromFileTime($user.LastLogonTimeStamp)
        Enabled = -not $user.Enabled
    }
}

# Export the inactive users to a CSV file
$exportPath = "C:\Temp\90-day-InactiveUsers.csv"
$customObjects | Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "Inactive users exported to $exportPath"
