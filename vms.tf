######################################
# VMs
######################################

module "vm" {
  source    = "./vm"
  providers = {
    azurerm = azurerm.applications
  }
  for_each = var.vm
  rg = azurerm_resource_group.r1-rg-applications.name
  name = each.value.name
  region = var.region1
  regioncode = var.region1code
  code = var.code
  tag-environment = each.value.tagenvironment
  tag-application-taxonomy = each.value.tagapplicationtaxonomy
  tag-department = each.value.tagdepartment
  vmsize = each.value.size
  #avzone = each.value.avzone
  image = each.value.image
  disktype = each.value.disktype
  adminusername = "localadmin"
  adminpassword = var.localadminpass
  subnet = module.appsnets_r1.snets["snet-apps-02"]
}

locals {
  setupscript = textencodebase64(templatefile("${path.module}/script.ps1",
    {
      arg1 = module.vm["tt-win-01"].vm.name
      arg2 = azurerm_resource_group.r1-rg-applications.name
      arg3 = var.region1
    }
   ), "UTF-16LE")
}

#run some stuff
resource "azurerm_virtual_machine_extension" "script-vm" {
  name                 = "${var.code}-ext-${module.vm["tt-win-01"].vm.name}"
  provider             = azurerm.applications
  virtual_machine_id   = module.vm["tt-win-01"].vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

    settings = <<SETTINGS
    {
        "commandToExecute": "powershell -encodedCommand ${local.setupscript}"
    }
    SETTINGS

  tags = {
    Environment            = var.tag_EnvironmentDEV
    Application-Taxonomy   = "script"
    Department             = var.tag_Department
    Geography              = var.region1
    Terraform              = "Yes"
  }
}

