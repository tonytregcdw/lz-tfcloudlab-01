data "azurerm_resources" "ttvms" {
  type = "Microsoft.Compute/virtualMachines"
  provider = azurerm.applications
  required_tags = {
    Environment = "Production"
  }
  
}

locals {
  vms_01 = {
    for obj in data.azurerm_resources.ttvms.resources : obj.name => obj
    # if (contains(["test"],obj.name))
  }
}

output "ttvmlist" {
  value = local.vms_01
}
