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