######################################
# Providers
######################################
terraform {
  cloud {
    organization = "ttcdw"

    workspaces {
      name = "lz-tfcloudlab-01"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.63"
      configuration_aliases = [azurerm.applications]
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

######################################
# Platform Providers
######################################
# applications
provider "azurerm" {
  features {}
  alias           = "applications"
  subscription_id = var.sub-applications
}

