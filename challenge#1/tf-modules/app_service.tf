

resource "azurerm_app_service_plan" "lz_app_service_plan" {
  for_each            = var.app_service_plan
  name                = join("", [var.resource_initials.app_service_plan, each.value.name, var.project_variables.project])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier     = each.value.sku.plan_sku.tier
    size     = each.value.sku.plan_sku.size
    capacity = try(each.value.sku.plan_sku.capacity, null)
  }

  tags = var.project_variables.tags

}


resource "azurerm_app_service" "lz_app_service" {
  for_each            = var.app_service
  name                = join("", [var.resource_initials.app_service_plan, var.project_variables.project, each.value.name])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.lz_app_service_plan[each.value.plan-index].id
  https_only          = try(each.value.https_only, null)

}