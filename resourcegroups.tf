resource "azurerm_resource_group" "r1-rg-applications" {
  name     = "${var.code}-rg-${var.region1code}-applications"
  provider = azurerm.applications
  location = var.region1
  tags = {
      Environment            = var.tag_EnvironmentPROD
      Application-Taxonomy   = "applications"
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
