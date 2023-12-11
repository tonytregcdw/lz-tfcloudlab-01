#module defaultroute - creates default route tables and associates to each spoke subnet
variable "subnets" {
  default = {}
}
variable "rg" {
}
variable "region" {
}
variable "regioncode" {
}
variable "code" {
}
variable "gatewayip" {
}
variable "name" {
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
#route table

resource "azurerm_route_table" "routetable" {
  name                = "${var.code}-routetable-${var.regioncode}-${var.name}"
  location            = var.region
  resource_group_name = var.rg
  disable_bgp_route_propagation = true

  route {
    name           = "${var.code}-route-${var.regioncode}-default"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = var.gatewayip
  }
  tags = {
    Application-Taxonomy   = "route"
    Geography              = var.region
    Environment            = var.tag_Environment
    Department             = var.tag_Department
    Terraform              = "Yes"
  }
}

#route table association
resource "azurerm_subnet_route_table_association" "route" {
  for_each = {
    for name, subnet in var.subnets : name => subnet
    if !(contains(["GatewaySubnet","AzureFirewallManagementSubnet","AzureBastionSubnet","AzureFirewallSubnet","AppGWSubnet","RouteServerSubnet"],subnet.name))
  }
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.routetable.id
}
