######################################
# Connectivity
######################################

resource "azurerm_virtual_network" "region1_applications" {
  name                = "${var.code}-vnet-${var.region1code}-apps"
  provider            = azurerm.applications
  location            = var.region1
  resource_group_name = azurerm_resource_group.r1-rg-applications.name
  address_space       = [var.region1-vnets["applications"].address_space]
  tags = {
    Environment            = var.tag_EnvironmentPROD
    Application-Taxonomy   = "Connectivity"
    role                   = "Network"
    IT-Owner-Contact       = var.tag_IT-Owner-Contact
    Business-Owner-Contact = var.tag_Business-Owner-Contact
    Department             = var.tag_Department
    Hours-Operational      = var.tag_Hours-Operational
    Days-Operational       = var.tag_Days-Operational
    Billed-To              = var.tag_Billed-To
    Cost-Centre            = var.tag_Cost-Centre
    Geography              = var.region1
    Terraform              = "Yes"
  }
}

module "appsnets_r1" {
  source    = "./subnets"
  providers = {
    azurerm = azurerm.applications
  }
  rg = azurerm_resource_group.r1-rg-applications
  code = var.code
  regioncode = var.region1code
  subnets = var.region1-snets["applications"]
  vnet_id = azurerm_virtual_network.region1_applications.id
  tag_Department = var.tag_Department
  tag_Environment = var.tag_EnvironmentPROD
}
