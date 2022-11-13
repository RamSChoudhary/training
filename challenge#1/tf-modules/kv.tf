resource "azurerm_key_vault" "kv" {
  name                = join("-", [var.kv.kv-name])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = var.project_variables.tenant_id
  sku_name            = var.kv.kv_sku
  tags                = var.project_variables.tags
}

resource "random_password" "password" {
  length           = var.random_password_length
  special          = var.random_password_special
  override_special = var.random_password_override_special
}

resource "azurerm_key_vault_secret" "sql_pass" {
  name         = var.kv.kv_secret_name
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.kv.id
}
