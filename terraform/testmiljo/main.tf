terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "4ae9468c-6a3a-4dbb-a32c-e79e2e711931"
}


resource "azurerm_resource_group" "exam_rg" {
  name     = "examensarbete-resurser"
  location = "West Europe"
}

resource "azurerm_virtual_network" "exam_vnet" {
  name                = "exam-vnet"
  resource_group_name = azurerm_resource_group.exam_rg.name
  location            = azurerm_resource_group.exam_rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "exam_subnet" {
  name                 = "exam-subnet"
  resource_group_name  = azurerm_resource_group.exam_rg.name
  virtual_network_name = azurerm_virtual_network.exam_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "exam_nsg" {
  name                = "exam-nic-nsg"
  resource_group_name = azurerm_resource_group.exam_rg.name
  location            = azurerm_resource_group.exam_rg.location

  security_rule {
    name                       = "Allow-SSH-Inbound"
    description                = "Allow SSH from Internet"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "exam_nic" {
  name                = "exam-nic"
  resource_group_name = azurerm_resource_group.exam_rg.name
  location            = azurerm_resource_group.exam_rg.location


  ip_configuration {
    name                          = "exam-ipconfig"
    subnet_id                     = azurerm_subnet.exam_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.existing.id
  }
}

resource "azurerm_network_interface_security_group_association" "exam_nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.exam_nic.id
  network_security_group_id = azurerm_network_security_group.exam_nsg.id
}

# Befintlig publik IP
data "azurerm_public_ip" "existing" {
  name                = "pip-exam-vnet-westeurope-exam-subnet2"
  resource_group_name = "examensarbete-resurser"
}

# Återskapa endast VM:n
resource "azurerm_linux_virtual_machine" "exam_vm" {
  name                = "examvm"
  location            = azurerm_resource_group.exam_rg.location
  resource_group_name = azurerm_resource_group.exam_rg.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.exam_nic.id]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("/Users/samiramoradi/.ssh/devsecops_key.pub")
  }

  os_disk {
    name                 = "examvm_osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
