$vmName = Read-Host 'VM Name:'
$locationPath = Read-Host 'Location Path:'

Set-VM -Name $vmName -AutomaticStopAction TurnOff
Set-VM -GuestControlledCacheTypes $true -VMName $vmName
Set-VM -LowMemoryMappedIoSpace 3Gb -VMName $vmName
Set-VM -HighMemoryMappedIoSpace 33280Mb -VMName $vmName

#Setzt nur die Grafikkarte an die jewilige VM. Zuvor muss die Graka im Gerätemanager Deaktiviert werden und vom Host-OS detatched werden.
#Entfernen der GPU Vom Host
Dismount-VMHostAssignableDevice -force -LocationPath $locationPath

Add-VMAssignableDevice -LocationPath $locationPath -VMName $vmName