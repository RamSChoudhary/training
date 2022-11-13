# Azure Resource Group
resource "azurerm_resource_group" "rg" {
  for_each = var.storages
  name     = join("-", [var.resource_initials.resource_group, var.project_variables.project, each.value.resource_groups])
  location = var.project_variables.location
  tags     = var.project_variables.tags
}