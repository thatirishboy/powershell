#Create Password File (Only need once)
$Credential = Get-Credential
$Credential.Password | ConvertFrom-SecureString | Set-Content C:\trey\365creds.txt

#Send Email
 $EncryptedCredential = "C:\trey\365creds.txt"
 $EmailUsername = "jdoe@gmail.com"
 $EncryptedPW = Get-Content
 $EncryptedCredential | ConvertTo-SecureString
 $Credential = New-Object System.Management.Automation.PsCredential($EmailUsername, $EncryptedPW)
 $EmailFrom = "jdoe@gmail.com"
 $EmailTo = "asmith@domain.com"
 $EmailSubject = "Test Subject"
 $EmailBody = "Test Body"
 $EmailAttachments = $LogFile
 $SMTPServer = "smtp.office365.com" # or "smtp.gmail.com"
 $SMTPPort = 587
 $SMTPSsl = $true
 $param = @{ SmtpServer = $SMTPServer Port = $SMTPPort UseSsl = $SMTPSsl
	Credential = $Credential
	From = $EmailFrom
	To = $EmailTo
	Subject = $EmailSubject
	Body = $EmailBody
	Attachments = $EmailAttachments
	}
Send-MailMessage @param