$destHost="<DNS Name for the Backup Share Server>"
$destHostIP=""#IP will be get lookup since the DC (DNS) can be a VM and the Name Reso cant be done while the Backup is running

try {
    $destHostIP = [System.Net.Dns]::GetHostAddresses("$destHost").IPAddressToString
} catch {
    echo "Cannot lookup dns ip for $destHost!"
}

echo "Sending Start Backup Server Signal to iLO..."
Set-HPiLOHostPower -Server "<HOSTNAME OR IP FOR THE ILO OF THE SERVER>" -Username "<RemoteBackupStartTask>" -Password "<somesecretpassword>" -HostPower "Yes"
echo "Backup Server Start signal sent!"


$destPath = "\\$destHostIP\Backups$" # Name of the netshare (\\Backupserver\Backups$\)

echo "Waiting until Backup Server started. . ."
while (!(Test-Path $destPath)) { # Wait until the Server is started and the Generic User can connect to the Share
    "Waiting..."
    Start-Sleep -Seconds 2
}
echo "Backup Server started!"



echo "Starting Backup. . ."
try {
    net use B: $destPath # $password /USER:$username
    D:\Backupscript\Hyper-V-Backup.ps1 -BackupTo 'B:\<Subdirectory where the Backups of this VirtualHost will be Stored (Hostname)>' -L '<Path to a Folder, where the Logfiles will be stored>' -Subject '<Subject of the Email>' -SendTo '<Recipient of the email>' -From '<Sender Email>' -Smtp '<Mailserver Hostname>' -User '<Username (Credentials) of the Sender Email>' -Pwd '<Path to the encrypted.key (where the Password is encrypted Stored)>' -PwdKey '<Path to AES_KEY.key which is required to decrypt the Password in order to login to the Mailserver)>'
} catch [System.Exception] {  
    echo "\r\nERR: $_.Exception.Message"
} finally {  
    net use B: /delete
}
echo "Backup Done!"



echo "Shutdown Backup Server. . ."
Stop-Computer -ComputerName $destHost -WsmanAuthentication Kerberos -Force
echo "Shutdown Done!"