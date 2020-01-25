$PasswordFile = "encrypted.key"
$KeyFile = "AES_KEY.key"
$Key = Get-Content $KeyFile
$pw = Read-Host 'Password to Encrypt:'
$Password = $pw | ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile