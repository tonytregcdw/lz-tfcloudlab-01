variable "subnets" {
    default = {}
}
variable "rg" {
}
variable "vnet_id" {
}
variable "code" {
}
variable "regioncode" {
}
variable "tag_Department" {
}
variable "tag_Environment" {
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.1.0"
    }
  }
}

resource "azurerm_subnet" "snet" {
  for_each             = var.subnets
  name                 = each.key
  provider            = azurerm
  resource_group_name  = var.rg.name
  virtual_network_name = element(split("/", var.vnet_id), 8)
  address_prefixes     = each.value.address_prefixes
  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = lookup(delegation.value, "service_delegation", [])
        content {
          name    = lookup(service_delegation.value, "name", null)    # (Required) The name of service to delegate to. Possible values include Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Logic/integrationServiceEnvironments, Microsoft.Netapp/volumes, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.Web/hostingEnvironments and Microsoft.Web/serverFarms.
          actions = lookup(service_delegation.value, "actions", null) # (Required) A list of Actions which should be delegated. Possible values include Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, Microsoft.Network/virtualNetworks/subnets/action and Microsoft.Network/virtualNetworks/subnets/join/action.
        }
      }
    }
  }
}

#create NSGs
module "nsg" {
  source = "../nsg"
  providers = {
    azurerm = azurerm
  }
  for_each = {
    for name, subnet in var.subnets : name => subnet
    if !(contains(["GatewaySubnet","AzureFirewallManagementSubnet","AzureBastionSubnet","AzureFirewallSubnet","RouteServerSubnet","AppGWSubnet"],name))
  }
  ruleset = each.value.nsg_ruleset
  rg = var.rg
  code = var.code
  regioncode = var.regioncode
  subnet = azurerm_subnet.snet[each.key]
  tag_Environment = var.tag_Environment
  tag_Department = var.tag_Department
}

output "snets" {
  value = azurerm_subnet.snet
}
