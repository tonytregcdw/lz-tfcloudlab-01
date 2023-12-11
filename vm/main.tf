######################################
# Domain Controllers
######################################
variable "subnet" {
}
variable "rg" {
}
variable "name" {
}
variable "region" {
}
variable "regioncode" {
}
variable "code" {
}
variable "vmsize" {
}
# variable "avzone" {
# }
variable "adminusername" {
}
variable "adminpassword" {
}
variable "disktype" {
}
variable "tag-environment" {
}
variable "tag-application-taxonomy" {
}
variable "tag-department" {
}
variable "image" {
  default = {}
}


#Create NICs
resource "azurerm_network_interface" "nic" {
  name                = "${var.code}-nic-${var.regioncode}-${var.name}"
  location            = var.region
  provider            = azurerm
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.code}-ipconfig-${var.regioncode}-${var.name}"
    subnet_id                     = var.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment            = var.tag-environment
    Application-Taxonomy   = var.tag-application-taxonomy
    Department             = var.tag-department
    Geography              = var.region
    Terraform              = "Yes"
  }
}

#Create VM
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "vm-${var.name}-${var.regioncode}"
  computer_name       = var.name
  provider            = azurerm
  resource_group_name = var.rg
  location            = var.region
  size                = var.vmsize
  # zone                = var.avzone
  admin_username      = var.adminusername
  admin_password      = var.adminpassword
  network_interface_ids = [azurerm_network_interface.nic.id]
  patch_assessment_mode = "AutomaticByPlatform"
  patch_mode            = "AutomaticByPlatform"
  identity {
    type = "SystemAssigned"
  }
  tags = {
    Environment            = var.tag-environment
    Application-Taxonomy   = var.tag-application-taxonomy
    Department             = var.tag-department
    Geography              = var.region
    Terraform              = "Yes"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.disktype
  }

  source_image_reference {
    publisher = var.image["publisher"]
    offer     = var.image["offer"]
    sku       = var.image["sku"]
    version   = var.image["version"]
  }
}

output "vm" {
  value = azurerm_windows_virtual_machine.vm
}