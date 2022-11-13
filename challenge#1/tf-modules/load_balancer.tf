resource "azurerm_application_gateway" "application_gateway" {
  for_each            = var.app_gateways
  name                = join("-", [var.resource_initials.app_gateways, each.value.name, var.project_variables.project])
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.project_variables.tags

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.sku_capacity
  }

  gateway_ip_configuration {
    name      = each.value.gateway_ip_configuration_name
    subnet_id = azurerm_subnet.subnet[each.value.sn-index].id
  }

  dynamic "frontend_port" {
    for_each = each.value.frontend_port
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }
  frontend_ip_configuration {
    name                 = each.value.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip[each.value.public_ip_index].id
  }

  dynamic "backend_address_pool" {
    for_each = each.value.backend_address_pool
    content {
      name         = backend_address_pool.value.name
    }
  }

  dynamic "backend_http_settings" {
    for_each = each.value.backend_http_settings
    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  dynamic "http_listener" {
    for_each = each.value.http_listener
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol

    }
  }

  dynamic "request_routing_rule" {
    for_each = each.value.request_routing_rule
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
    }
  }
  #   identity {
  #     type = "UserAssigned"
  #     identity_ids = [azurerm_user_assigned_identity.application_gateway.id]
  #   }
}

resource "azurerm_public_ip" "pip" {
    for_each = var.public_ip
  name                = join("-", [var.resource_initials.public_ip, each.value.name])
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = each.value.allocation_method
  tags                = var.project_variables.tags

}