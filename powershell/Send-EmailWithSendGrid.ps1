# Send emails using the SendGrid API
#
# Multiple emails must be received as a comma separated list
#
# Call from another ps1 file with the following:
#
# Include function from this file:
# . ./Send-EmailWithSendGrid.ps1  
# 
# Declare variables:
# $From = "sender@testing.com" 
# $To = "recipient@testing.com" 
# $APIKEY = "SendGrid API key" 
# $Subject = "TESTING" 
# $Body ="TESTING"
#
# Send email:
# Send-EmailWithSendGrid -from $from -to $to -ApiKey $APIKEY -Body $Body -Subject $Subject


function Send-EmailWithSendGrid {
     Param
    (
        [Parameter(Mandatory=$true)]
        [string] $From,
 
        [Parameter(Mandatory=$true)]
        [String] $To,
 
        [Parameter(Mandatory=$true)]
        [string] $ApiKey,
 
        [Parameter(Mandatory=$true)]
        [string] $Subject,
 
		[array] $Emails,
			
        [Parameter(Mandatory=$true)]
        [string] $Body
 
    )
 
    $headers = @{}
    $headers.Add("Authorization","Bearer $apiKey")
    $headers.Add("Content-Type", "application/json")
 
	# Handle multiple emails, received as a comma separated list
	if($To.Contains(","))
	{
		[array]$Emails = $To.Split(",").replace(' ','')
	}else
	{
		[array]$Emails = $To.replace(' ','')
	}
 
    $jsonRequest = [ordered]@{
                            personalizations= @(@{to = @($Emails | %{ @{email = "$_"} })
                                subject = "$SubJect" })
                                from = @{email = "$From"}
                                content = @( @{ type = "text/plain"
                                            value = "$Body" }
                                )} | ConvertTo-Json -Depth 10
    Invoke-RestMethod   -Uri "https://api.sendgrid.com/v3/mail/send" -Method Post -Headers $headers -Body $jsonRequest 
}
 