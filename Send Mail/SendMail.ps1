
    $MailSubject="Test"

    $MailTo="office@luis-falkenhan.de"

    $MailFrom="test@luis-falkenhan.de"

    $SmtpServer="luis-falkenhan.de"

    $SmtpUser="test@luis-falkenhan.de"

    $SmtpPwd = "mailsettings\encrypted.key"

    $SmtpPwdKeyFile = "mailsettings\AES_KEY.key"

    ## If email was configured, set the variables for the email subject and body.
    If ($SmtpServer)
    {
        # If no subject is set, use the string below
        If ($Null -eq $MailSubject)
        {
            $MailSubject = "Hyper-V Backup"
        }

        $MailBody = "TESTMAIL"#Get-Content -Path $Log | Out-String

        ## If an email password was configured, create a variable with the username and password.
        If ($SmtpPwd -and $SmtpPwdKeyFile)
        {
            $SmtpPwdKey = Get-Content $SmtpPwdKeyFile
            $SmtpCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SmtpUser, (Get-Content $SmtpPwd | ConvertTo-SecureString -Key $SmtpPwdKey)

            ## If ssl was configured, send the email with ssl.
            If ($UseSsl)
            {
                Send-MailMessage -To $MailTo -From $MailFrom -Subject $MailSubject -Body $MailBody -SmtpServer $SmtpServer -UseSsl -Credential $SmtpCreds
            }

            ## If ssl wasn't configured, send the email without ssl.
            Else
            {
                Send-MailMessage -To $MailTo -From $MailFrom -Subject $MailSubject -Body $MailBody -SmtpServer $SmtpServer -Credential $SmtpCreds
            }
        }

        ## If an email username and password were not configured, send the email without authentication.
        Else
        {
            Send-MailMessage -To $MailTo -From $MailFrom -Subject $MailSubject -Body $MailBody -SmtpServer $SmtpServer
        }
    }
