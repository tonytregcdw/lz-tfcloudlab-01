variable "vnet" {
    default = {}
}
variable "vnetname" {
}
variable "subnets" {
    default = {}
}
variable "usegateway" {
}
variable "rg" {
}
variable "region" {
}
variable "regioncode" {
}
variable "code" {
}
variable "dns-servers" {
}
variable "dns-ruleset" {
}
variable "sub-connectivity" {
}
variable "hub_virtual_network_id" {
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

#-------------------------------------
# hub Provider Alias for Peering
#-------------------------------------
provider "azurerm" {
  alias           = "hub"
  subscription_id = var.sub-connectivity
  # subscription_id = element(split("/", var.hub_virtual_network_id), 2)
  features {}
}

resource "azurerm_virtual_network" "spokevnet" {
  name                = "${var.code}-vnet-${var.regioncode}-${var.vnetname}"
  location            = var.rg.location
  provider = azurerm
  resource_group_name = var.rg.name
  address_space       = [var.vnet.address_space]
  # dns_servers         = var.dns-servers
  tags = {
    Application-Taxonomy   = var.vnet.name
    role                   = "spokeNetwork"
    Geography              = var.region
    Environment            = var.tag_Environment
    Department             = var.tag_Department
    Terraform              = "Yes"
  }
}

resource "azurerm_virtual_network_dns_servers" "vnet_dns" {
  # count              = var.dns-servers == null ? 0 : 1
  virtual_network_id = azurerm_virtual_network.spokevnet.id
  dns_servers        = var.dns-servers
}

#link vnet to dns ruleset if exists
resource "azurerm_private_dns_resolver_virtual_network_link" "dns_ruleset_vnetlink" {
  count                     = var.dns-ruleset == null ? 0 : 1
  name                      = "${var.code}-dns-ruleset-vnetlink-${var.vnetname}"
  dns_forwarding_ruleset_id = var.dns-ruleset.id
  virtual_network_id        = azurerm_virtual_network.spokevnet.id
}


#create subnets
module "spokesubnet" {
  source    = "../subnets"
  providers = {
    azurerm = azurerm
  }
  rg = var.rg
  code = var.code
  regioncode = var.regioncode
  subnets = var.subnets
  vnet_id = azurerm_virtual_network.spokevnet.id
  tag_Environment = var.tag_Environment
  tag_Department = var.tag_Department
}

#create peerings to hub vnet
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = lower("peering-${var.vnetname}-to-hub-${element(split("/", var.hub_virtual_network_id), 8)}")
  resource_group_name          = var.rg.name
  virtual_network_name         = azurerm_virtual_network.spokevnet.name
  remote_virtual_network_id    = var.hub_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.usegateway
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider                     = azurerm.hub
  name                         = lower("peering-${element(split("/", var.hub_virtual_network_id), 8)}-to-spoke-${var.code}-${var.vnetname}")
  resource_group_name          = element(split("/", var.hub_virtual_network_id), 4)
  virtual_network_name         = element(split("/", var.hub_virtual_network_id), 8)
  remote_virtual_network_id    = azurerm_virtual_network.spokevnet.id
  allow_gateway_transit        = true
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  use_remote_gateways          = false
}





#output "vnet_id" {
#  value = azurerm_virtual_network.spokevnet.id
#}

output "vnet" {
  value = azurerm_virtual_network.spokevnet
}

output "snets" {
  value = module.spokesubnet.snets
}