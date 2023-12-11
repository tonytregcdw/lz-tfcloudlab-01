######################################
# Variables
######################################
# Core Naming
variable "code" {
  type        = string
  description = "Customer code used for creation of some resources"
}

#subscriptions
variable "sub-applications" {
  description = "sub-applications"
  type = string
}

variable "localadminpass" {
  type        = string
}

variable "region1-vnets" {
  description = "hub vnet Map for Creation"
  type = map
  default = {
    hub = {
      address_space = "10.10.0.0/21"
    }
    applications = {
      address_space = "10.10.16.0/21"
    }
  }
}

variable "region1-snets" {
  description = "Hub Subnet Map for Creation"
  type = any
}

# Locations
variable "region1" {
  type        = string
  description = "Region 1 in format as per Azure CLI"
}
variable "region2" {
  type        = string
  description = "Region 2 in format as per Azure CLI"
}
variable "region1code" {
  type        = string
  description = "Region 1 in code format used for Resource Naming"
}
variable "region2code" {
  type        = string
  description = "Region 2 in code format used for Resource Naming"
}
variable "regions" {
  type        = list
  description = "regions"
}

# Tags
variable "tag_EnvironmentPROD" {
  type        = string
  description = "Tag for Environment when Resource is Production"
}
variable "tag_EnvironmentDEV" {
  type        = string
  description = "Tag for Environment when Resource is Development"
}
variable "tag_IT-Owner-Contact" {
  type        = string
  description = "IT Owner Contact Tag"
}
variable "tag_Business-Owner-Contact" {
  type        = string
  description = "Business Owner Contact Tag"
}
variable "tag_Department" {
  type        = string
  description = "Department Tag"
}
variable "tag_Hours-Operational" {
  type        = string
  description = "Hours Operational Tag"
}
variable "tag_Days-Operational" {
  type        = string
  description = "Day Operational Tag"
}
variable "tag_Billed-To" {
  type        = string
  description = "Billed To Tag"
}
variable "tag_Cost-Centre" {
  type        = string
  description = "Cost Center Tag"
}
variable "tag_Build-Date" {
  type        = string
  description = "Build Date Tag"
}
variable "tag_Geography1" {
  type        = string
  description = "Geography 1 Tag"
}
variable "tag_Geography2" {
  type        = string
  description = "Geography 2 Tag"
}
variable "tag_Terraform" {
  type        = string
  description = "Tag applied to Resources Created by Terraform"
}

variable "privatezonemap" {
  description = "DNZ zone map for creation"
  type = map
  default = {
    "agentsvc.azure-automation.net" = {
    }
    "monitor.azure.com" = {
    }
    "ods.opinsights.azure.com" = {
    }
    "oms.opinsights.azure.com" = {
    }
    "privatelink.adf.azure.com" = {
    }
    "privatelink.api.azureml.ms" = {
    }
    "privatelink.azurecr.io" = {
    }
    "mysql.database.azure.com" = {
    }
    "privatelink.blob.core.windows.net" = {
    }
    "privatelink.database.windows.net" = {
    }
    "privatelink.datafactory.azure.net" = {
    }
    "privatelink.dfs.core.windows.net" = {
    }
    "privatelink.file.core.windows.net" = {
    }
    "privatelink.notebooks.azure.net" = {
    }
    "privatelink.vaultcore.azure.net" = {
    }
    "privatelink.snowflakecomputing.com" = {
    }
    "privatelink.vaultcore.azure.net" = {
    }
    "privatelink.monitor.azure.com" = {
    }
    "privatelink.oms.opinsights.azure.com" = {
    }
    "privatelink.ods.opinsights.azure.com" = {
    }
    "privatelink.agentsvc.azure-automation.net" = {
    }
  }
}


variable "vm" {
  type = map
  default = {
    "prod-vm-01" = {
      "name" = "AZVTESTM01"
      "size" = "Standard_DS1_v2"
      "avzone" = 1
      "tagenvironment" = "Test"
      "tagapplicationtaxonomy" = "Test"
      "tagdepartment" = "LandingZone"
      "disktype" = "StandardSSD_LRS"
      "image" = {
        "publisher" = "MicrosoftWindowsServer"
        "offer" = "WindowsServer"
        "sku" = "2019-Datacenter"
        "version" = "latest"
      }
    }
  }
}

