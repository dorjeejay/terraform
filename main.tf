resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
   name = "vnet08"
   address_space = ["10.0.0.0/16"]
   location = azurerm_resource_group.rg.location
   resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
   name = "subnet08"
   resource_group_name = azurerm_resource_group.rg.name
   virtual_network_name = azurerm_virtual_network.vnet.name
   address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
   name = "nic08"
   location = azurerm_resource_group.rg.location
   resource_group_name = azurerm_resource_group.rg.name

   ip_configuration {
      name = "testconfiguration1"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
   }
}

resource "azurerm_virtual_machine" "vm" {
   name = "vm08"
   location = azurerm_resource_group.rg.location
   resource_group_name = azurerm_resource_group.rg.name
   network_interface_ids = [azurerm_network_interface.nic.id]
   vm_size = "Standard_D2s_v3"


storage_image_reference {
   publisher = "Canonical"
   offer = "0001-com-ubuntu-server-jammy"
   sku = "22_04-lts"
   version = "latest"
}
storage_os_disk {
   name = "myosdisk1"
   caching = "ReadWrite"
   create_option = "FromImage"
   managed_disk_type = "Standard_LRS"
}
os_profile {
   computer_name = "hostname"
   admin_username = "testadmin"
   admin_password = "Password1234!"
}
os_profile_linux_config {
   disable_password_authentication = false
}
}