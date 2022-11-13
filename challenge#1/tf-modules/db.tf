resource "azurerm_mssql_server" "lz_sql_server" {
  for_each                     = var.sql_server
  name                         = join("-", [var.resource_initials.sql_server, each.value.name, var.project_variables.project])
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = each.value.version
  administrator_login          = each.value.administrator_login
  administrator_login_password = azurerm_key_vault_secret.sql_pass.value

  tags = var.project_variables.tags

}

resource "azurerm_mssql_database" "lz_sql_db" {
  for_each                    = var.sql_db
  name                        = join("-", [var.resource_initials.sql_db, var.project_variables.project, each.value.name])
  server_id                   = azurerm_mssql_server.lz_sql_server[each.value.server-index].id
  auto_pause_delay_in_minutes = try(each.value.auto_pause_delay_in_minutes, null)
  create_mode                 = try(each.value.create_mode, null)
  creation_source_database_id = try(each.value.creation_source_database_id, null)
  collation                   = try(each.value.collation, null)
  sku_name                    = try(each.value.sku_name, null)
  storage_account_type        = try(each.value.storage_account_type, null)
  zone_redundant              = try(each.value.read_replica_count, null)
  tags                        = var.project_variables.tags

}