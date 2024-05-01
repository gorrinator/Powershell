# Read CSV file containing variables
$data = Import-Csv -Path "terminals.csv"

# Initialize array to store SOAP messages
$soapMessages = @()

# Loop through each entry in the CSV file
foreach ($entry in $data) {
    # Construct SOAP message for each entry
    $merchantId = "0000000$($entry.merchantId)"  # Ensure merchantId starts with 0000000
    $enabled = $entry.enabled.ToString().ToLower()  # Convert enabled value to lowercase
    $soapMessage = @"
    {
        "operation": "U",
        "type": "T",
        "terminalId": "$($entry.terminalId)",
        "shortName": "$($entry.shortName)",
        "merchantId": "$merchantId",
        "encryptionKeyId": "$($entry.encryptionKeyId)",
        "terminalType": "$($entry.terminalType)",
        "gsapTerminalId": "$($entry.gsapTerminalId)",
        "subMerchant": {
            "id": "$($entry.subMerchantId)",
            "name": "$($entry.subMerchantName)",
            "ewayCustomerId": "$($entry.ewayCustomerId)",
            "AccountClientID": "$($entry.AccountClientID)",
            "address": {
                "street": "$($entry.subMerchantStreet)",
                "city": "$($entry.subMerchantCity)",
                "state": "$($entry.subMerchantState)",
                "postcode": "$($entry.subMerchantPostcode)",
                "country": "$($entry.subMerchantCountry)"
            }
        },
        "association": "$($entry.association)",
        "enabled": $enabled,
        "serviceMethodId": "$($entry.serviceMethodId)",
        "timeZone": "$($entry.timeZone)"
    }
"@
    # Add SOAP message to array
    $soapMessages += $soapMessage
}

# Convert array to JSON format
$jsonData = "[" + ($soapMessages -join ",") + "]"

# Get the current date in a specific format
$date = Get-Date -Format "yyyyMMdd"

# Output JSON data to a file with the current date in the name
$outputFileName = "output_$date.json"
$jsonData | Out-File -FilePath $outputFileName
