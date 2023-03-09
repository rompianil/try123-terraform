
provider "azurerm" {
  features {}
  subscription_id   = "437f4153-e76c-4e6a-82b4-65ac394befa4"
  client_id         = "0a9723c8-1725-4d46-b9f4-418b38cb1db0"
  client_secret     = "5md8Q~TYS.CLQO.4_N-v-a1C5UJe2Im.RafcxasA"
  tenant_id         = "b63b1848-777d-4f1b-a158-bbe5afbb52b8"
}

/*
resource "azurerm_resource_group" "test_rgt" {
  name     = "test2"
  location = "West Europe"
} 

provider "azurerm" {
  features {}
  subscription_id   = "437f4153-e76c-4e6a-82b4-65ac394befa4"
  client_id         = "0a9723c8-1725-4d46-b9f4-418b38cb1db0"
  client_secret     = "5md8Q~TYS.CLQO.4_N-v-a1C5UJe2Im.RafcxasA"
  tenant_id         = "b63b1848-777d-4f1b-a158-bbe5afbb52b8"
} 

module "rg" {
    source = "./trying"

azurerm_resource_group-name = "test5"
location = "West Europe"   
} */

resource "azurerm_resource_group" "test_rg" {
  name     = "test5"
  location = "West Europe"
} 

resource "azurerm_virtual_network" "vnet" {
  name                = "test-vent"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name

 /* depends_on = [
    azurerm_resource_group.test_rg.name 
  ] */
}



resource "azurerm_subnet" "subnet1" {
  name                 = "test-sub"
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

 /* depends_on = [
    azurerm_virtual_network.vnet.name
  ] */
}


resource "azurerm_network_interface" "nic" {
  name                = "test-nic"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name

  ip_configuration {
    name                          = "try1"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }

 /* depends_on = [
    azurerm_subnet.subnet1.name
  ] */
}


resource "azurerm_network_security_group" "nsg" {
  name                = "test-nsg"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Dev"
  }

 /* depends_on =[
    azurerm_resource_group.test_rg.name 
  ] */
} 

/*
resource "azurerm_windows_virtual_machine" "vm01" {
  name                = "jump"
  resource_group_name = azurerm_resource_group.test_rg.name
  location            = azurerm_resource_group.test_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}*/




/*
resource "azurerm_linux_virtual_machine" "vm02" {
  name                = "linuxhost"
  resource_group_name = azurerm_resource_group.test_rg.name
  location            = azurerm_resource_group.test_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "test1234@21"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  } 

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
*/

