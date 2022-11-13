resource "azurerm_virtual_network" "vnet" {
  for_each            = var.virtualnet_variables
  name                = join("-", [var.resource_initials.vnet, each.value.name, var.project_variables.project])
  location            = var.project_variables.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = each.value.address_space
  tags                = var.project_variables.tags
}

# Azure Virtual sub-network
resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet_var
  name                 = join("-", [var.resource_initials.subnet, each.value.name, var.project_variables.project])
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet[each.value.vnet-index].name
  address_prefixes     = each.value.subnet_address_prefix
}

# Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = join("-", [var.resource_initials.resource_group, var.project_variables.project, var.virtualnet_variables.vnet.resource_groups])
  location = var.project_variables.location
  tags     = var.project_variables.tags
}