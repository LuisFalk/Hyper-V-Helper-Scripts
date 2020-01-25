$vm = Read-Host 'VM Name:'
#Remove the device from the VM
Remove-VMAssignableDevice -VMName $VM
#Mount the device back in the host
Mount-VMHostAssignableDevice