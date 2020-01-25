$KeyFile = "AES_KEY.key"
$Key = New-Object Byte[] 16   # 16, 24, or 32 for AES
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file $KeyFile