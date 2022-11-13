# Creating Azure Storage Account
resource "azurerm_storage_account" "storage_tfstate" {
  for_each                  = var.storages
  name                      = join("", [var.resource_initials.storage_account, var.project_variables.project, each.key])
  resource_group_name       = azurerm_resource_group.rg[each.key].name
  location                  = var.project_variables.location
  account_tier              = each.value.storageaccount_tier
  account_replication_type  = each.value.storageaccount_replication_type
  enable_https_traffic_only = each.value.sa_enable_https_traffic_only
  network_rules {
    default_action = each.value.network_rule_action
  }
  tags = var.project_variables.tags
}

# Creating Azure Storage Container
resource "azurerm_storage_container" "container_tfstate" {
  for_each              = var.storage_blobs
  name                  = join("", [var.resource_initials.storage_blob, each.key, ])
  storage_account_name  = azurerm_storage_account.storage_tfstate[each.value.storage_index].name
  container_access_type = each.value.container_access_type
}