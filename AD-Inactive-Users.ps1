# Import the Active Directory module
Import-Module ActiveDirectory

# Retrieve all disabled users
$disabledUsers = Get-ADUser -Filter {Enabled -eq $false}

# Export the disabled users to a CSV file
$exportPath = "C:\Temp\DisabledUsers.csv"
$disabledUsers | Select-Object Name, SamAccountName, Enabled |
    Export-Csv -Path $exportPath -NoTypeInformation

Write-Host "All disabled users exported to $exportPath"
