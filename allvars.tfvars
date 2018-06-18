VMSize = "Standard_DS1_v2"

#storage_image_reference
VMpublisher = "Canonical"
VMoffer     = "UbuntuServer"
VMsku       = "16.04-LTS"
VMversion   = "latest"

#storage_os_disk
VMcaching           = "ReadWrite"
VMcreate_option     = "FromImage"
VMmanaged_disk_type = "Standard_LRS"
 
#storage_data_disk
VMlun               = 0
VMdisk_size_gb      = "1023"

#os_profile 
VMcomputer_name  = "hostname"
VMadmin_username = "testadmin"
VMadmin_password = "Password1234!"

AddressSpace = "10.0.0.0/16"
DNSServers = ["10.0.0.4", "10.0.0.5"]
SubnetPrefix = "10.0.1.0/24"
StorageAccountType = "Standard_LRS"
DiskSizeGB = "64"

ResourceGroupName = "AveResGr1"
Location = "West US"
VirtualNetworkName = "AveVirNet1"
SubnetName = "sub1"
NetworkInterfaceName = "AveNetInt1"
IpConfigurationName = "AveIpConf"
ManagedDiskName = "AveManDisk1"
VirtualMachineName = "AveVM1"