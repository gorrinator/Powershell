# Read the contents of the text file
$text = Get-Content -Path "terminals.txt" | Out-String

# Convert the JSON text to PowerShell objects
$soapMessages = $text | ConvertFrom-Json

# Initialize an array to store non-null subMerchantId values
$subMerchantIds = @()

# Initialize an array to store converted data
$csvData = @()

# Loop through each SOAP message
foreach ($message in $soapMessages) {
    # Skip entries with shortName value of "LAT", terminal IDs starting with "PT1" or "GS0"
    if ($message.shortName -eq "LAT" -or $message.terminalId -like "PT1*" -or $message.terminalId -like "GS0*") {
        continue
    }

    $csvEntry = [PSCustomObject]@{
        "terminalId" = $message.terminalId
        "shortName" = $message.shortName
        "merchantId" = $message.merchantId
        "encryptionKeyId" = $message.encryptionKeyId
        "terminalType" = $message.terminalType
        "gsapTerminalId" = $message.gsapTerminalId
        "ewayCustomerId" = $message.ewayCustomerId
        "AccountClientID" = $message.AccountClientID
        "subMerchantId" = $message.subMerchant.id
        "subMerchantName" = $message.subMerchant.name
        "subMerchantStreet" = $message.subMerchant.address.street
        "subMerchantCity" = $message.subMerchant.address.city
        "subMerchantState" = $message.subMerchant.address.state
        "subMerchantPostcode" = $message.subMerchant.address.postcode
        "subMerchantCountry" = $message.subMerchant.address.country
        "association" = $message.association
        "enabled" = $message.enabled
        "serviceMethodId" = $message.serviceMethodId
        "timeZone" = $message.timeZone
    }
    
    # Add CSV entry to the array
    $csvData += $csvEntry
    
    # Check if subMerchantId is not null
    if ($message.subMerchant.id) {
        # Add non-null subMerchantId to the array
        $subMerchantIds += "'$($message.subMerchant.id)'"
    }
}

# Convert array to comma-separated string
$subMerchantIdsString = $subMerchantIds -join ","

# Write subMerchantIds to a text file
$subMerchantIdsString | Out-File -FilePath "subMerchantIds.txt"

# Export the CSV data to a CSV file
$csvData | Export-Csv -Path "terminals.csv" -NoTypeInformation
