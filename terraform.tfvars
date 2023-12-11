######################################
# Variables
######################################

#subscriptions
sub-applications = "a2d3df79-3372-479d-83b8-7140c9f56b5c"

# Core Naming
code = "ttlab"

# Locations
region1     = "UK South"
region2     = "UK West"
region1code = "uks"
region2code = "ukw"
regions = ["UK South", "UK West"]

# Tags
tag_EnvironmentPROD        = "Production"
tag_EnvironmentDEV         = "Development"
tag_IT-Owner-Contact       = "tt@tt.net"
tag_Business-Owner-Contact = "tt@tt.net"
tag_Department             = "tt-landingzone"
tag_Hours-Operational      = "24"
tag_Days-Operational       = "7"
tag_Billed-To              = "tt-landingzone"
tag_Cost-Centre            = "tt-landingzone"
tag_Build-Date             = "7/4/2022"
tag_Geography1             = "UK South"
tag_Geography2             = "UK West"
tag_Terraform              = "Yes"

region1-snets = {
  hub = {
    snet-hub-01 = {
      address_prefixes = ["10.10.0.0/24"]
      nsg_ruleset = {
      }
    } 
    snet-hub-02 = {
      address_prefixes = ["10.10.1.0/24"]
      nsg_ruleset = {
      }
    } 
    AzureFirewallSubnet = {
      address_prefixes = ["10.10.2.0/25"]
      nsg_ruleset = {
      }
    } 
    AzureFirewallManagementSubnet = {
      address_prefixes = ["10.10.2.128/25"]
      nsg_ruleset = {
      }
    } 
    GatewaySubnet = {
      address_prefixes = ["10.10.3.0/24"]
      nsg_ruleset = {
      }
    } 
    AzureBastionSubnet = {
      address_prefixes = ["10.10.4.0/25"]
      nsg_ruleset = {
      }
    } 
    AppGWSubnet = {
      address_prefixes = ["10.10.5.0/24"]
      nsg_ruleset = {
      }
    } 
    RouteServerSubnet = {
      address_prefixes = ["10.10.6.0/26"]
      nsg_ruleset = {
      }
    } 
  }
  applications = {
    "snet-apps-01" = {
      address_prefixes = ["10.10.16.0/24"]
      nsg_ruleset = {
      }
    } 
    "snet-apps-02" = {
      address_prefixes = ["10.10.17.0/24"]
      nsg_ruleset = {
        in-rdp = {
          name                       = "in-rdp"
          priority                   = 4094
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "3389"
          destination_port_ranges     = null
          source_address_prefix      = "*"
          destination_address_prefix = "*"
          description                = "in-rdp"
        }
      }
    } 
    "snet-dns-in-01" = {
      address_prefixes = ["10.10.18.0/28"]
      nsg_ruleset = {
      }
      delegation = [
        {
          name = "Microsoft.Network.dnsResolvers" #(Required) A name for this delegation.
          service_delegation = [
            {
              name    = "Microsoft.Network/dnsResolvers"       # (Required) The name of service to delegate to. Possible values include Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Logic/integrationServiceEnvironments, Microsoft.Netapp/volumes, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.Web/hostingEnvironments and Microsoft.Web/serverFarms.
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"] # (Required) A list of Actions which should be delegated. Possible values include Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, Microsoft.Network/virtualNetworks/subnets/action and Microsoft.Network/virtualNetworks/subnets/join/action.
            },
          ]
        },
      ]
    }
    "snet-dns-out-01" = {
      address_prefixes = ["10.10.18.32/28"]
      nsg_ruleset = {
      }
      delegation = [
        {
          name = "Microsoft.Network.dnsResolvers" #(Required) A name for this delegation.
          service_delegation = [
            {
              name    = "Microsoft.Network/dnsResolvers"       # (Required) The name of service to delegate to. Possible values include Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Logic/integrationServiceEnvironments, Microsoft.Netapp/volumes, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.Web/hostingEnvironments and Microsoft.Web/serverFarms.
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"] # (Required) A list of Actions which should be delegated. Possible values include Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, Microsoft.Network/virtualNetworks/subnets/action and Microsoft.Network/virtualNetworks/subnets/join/action.
            },
          ]
        },
      ]
    }
  }
}

vm = {
  "tt-win-01" = {
    "name" = "TTWINVM01"
    "size" = "Standard_B2ms"
    "avzone" = 1
    "tagenvironment" = "Production"
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
