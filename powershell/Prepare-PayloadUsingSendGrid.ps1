# This script calls 'Send-EmailWithSendGrid.ps1' to deliver payload to a recipient by calling 'Send-EmailWithSendGrid.ps1'

# Using this script
. ./Send-EmailWithSendGrid.ps1

# Get contents of 'payload.txt' to report via email
$payload = Get-Content -Path .\payload.txt -Raw

$Date = Get-Date

# SendGrid API Key
$APIkey = "secretSquirrels" 

# Set email fields
$From = "sender@testing.com" 
$To = "recipient@testing.com" 

$Subject = -join('Test Subject ', $Date)
$Body = -join('Please find following payload sent at ', $Date, ':', "`r`n", "`r`n", $payload, "`r`n", "- From the Sender")

# Send email
Send-EmailWithSendGrid -from $From -to $To -ApiKey $APIkey -Body $Body -Subject $Subject
