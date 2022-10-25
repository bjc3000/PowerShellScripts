#------------------- Stale User check and e-mail -------------- Bjc300
$d = [DateTime]::Today.AddDays(-90)
$staleAccounts = Get-ADUser -Filter 'LastLogon -lt $d' -Properties PasswordLastSet,LastLogon |
Select-Object -Property Name, DisplayName,
@{N = "pwdlastset"; E = {[DateTime]::FromFileTime($_.pwdlastset)}},
@{N = "AccountExpires"; E = {[DateTime]::FromFileTime($_.AccountExpires)}},
@{N = "LastLogon"; E = {[DateTime]::FromFileTime($_.LastLogon)}} |
export-csv "C:\temp\StaleUsers.csv" -NoTypeInformation
$SvrDomain = Get-AdDomain | Select-Object -property InfrastructureMaster
$FromAddress = "<From Address>"
$ToAddress = "<To Address>"
$Subject = "Stale user list from $SvrDomain"
$Body = "Please find attached spreadsheet of potential user login risks."
$Attachment ="C:\temp\StaleUsers.Csv"
$SmtpServer = "<E-mail Server>"
$secpasswd = ConvertTo-SecureString "<Password>" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("<Username>", $secpasswd)
Send-MailMessage -smtpServer $SmtpServer -port <Mail Server Port> -credential $cred -from $FromAddress -to $ToAddress -subject $Subject -body $Body -attachment $Attachment
Remove-Item -path "C:\temp\StaleUsers.csv"


