variable ResourceGroupName {}
variable Location {}
variable VirtualNetworkName {}
variable NetworkInterfaceName {}
variable IpConfigurationName {}
variable SubnetName {}
variable ManagedDiskName {}
variable VirtualMachineName {}
variable AddressSpace {}
variable DNSServers {
  type= "list"
}
variable SubnetPrefix {}
variable StorageAccountType {}
variable DiskSizeGB {}
#vm options
variable VMSize {}
variable VMpublisher {}
variable VMoffer {}
variable VMsku {}
variable VMversion {}
variable VMcaching {}
variable VMmanaged_disk_type {}
variable VMcreate_option {}
variable VMlun {}
variable VMdisk_size_gb {}
variable VMcomputer_name {}
variable VMadmin_username {}
variable VMadmin_password {}

resource "azurerm_resource_group" "rg1" {
    name = "${var.ResourceGroupName}"
    location = "${var.Location}"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "virtualNetwork1"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
  address_space       = ["${var.AddressSpace}"]
  location            = "West US"
  dns_servers         = ["${var.DNSServers}"]

  subnet {
    name           = "${var.SubnetName}"
    address_prefix = "${var.SubnetPrefix}"
  }

  tags {
    environment = "Production"
  }
}
data "azurerm_subnet" "subnet" {
  name                 = "${var.SubnetName}"
  virtual_network_name = "${azurerm_virtual_network.vnet1.name}"
  resource_group_name  = "${azurerm_resource_group.rg1.name}"
}

# # vms
resource "azurerm_network_interface" "nic" {
    name = "${var.NetworkInterfaceName}"
    location = "${var.Location}"
    resource_group_name = "${var.ResourceGroupName}"
    ip_configuration {
        name = "${var.IpConfigurationName}"
        subnet_id ="${data.azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
    }
}
resource "azurerm_managed_disk" "disk" {
    name = "${var.ManagedDiskName}"
    location = "${var.Location}"
    resource_group_name = "${var.ResourceGroupName}"
    storage_account_type = "${var.StorageAccountType}"
    create_option = "Empty"
    disk_size_gb = "${var.DiskSizeGB}"
}
resource "azurerm_virtual_machine" "VM" {
    delete_os_disk_on_termination = false
    name = "${var.VirtualMachineName}"
    location = "${var.Location}"
    resource_group_name = "${var.ResourceGroupName}"
    network_interface_ids = ["${azurerm_network_interface.nic.id}"]
    vm_size = "${var.VMSize}"
    

  storage_image_reference {
    publisher = "${var.VMpublisher}"
    offer     = "${var.VMoffer}"
    sku       = "${var.VMsku}"
    version   = "${var.VMversion}"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "${var.VMcaching}"
    create_option     = "attach"
    managed_disk_type = "${var.VMmanaged_disk_type}"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new"
    managed_disk_type = "${var.VMmanaged_disk_type}"
    create_option     = "Empty"
    lun               = "${var.VMlun}"
    disk_size_gb      = "${var.VMdisk_size_gb}"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.disk.name}"
    managed_disk_id = "${azurerm_managed_disk.disk.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.disk.disk_size_gb}"
  }

  os_profile {
    computer_name  = "${var.VMcomputer_name}"
    admin_username = "${var.VMadmin_username}"
    admin_password = "${var.VMadmin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }
}