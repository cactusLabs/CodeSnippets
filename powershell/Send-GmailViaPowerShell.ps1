# This script sends a hardcoded payload.txt via email using Powershell

# Gmail email address and password of sender 
$sender = 'sender@testing.com'
$password = "secretSquirrels"

# Comma separated list of all intended email recipients
$recipients = 'recipient@testing.com'

# Send email
$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($sender, $secpasswd)
Send-MailMessage -SmtpServer 'smtp.gmail.com' -Port 587 -Credential $cred -UseSsl -From $sender -To $recipients -Subject 'Server Builds: ' $(Get-Date) -Attachments payload.txt 