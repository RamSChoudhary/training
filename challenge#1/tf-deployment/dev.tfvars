
#region Projuect Variables Commonly used in entire project
project_variables = {
  project          = "training"
  location         = "East US"
  tenant_id        = "<<tenantid>>"
  subscription_ids = "<<subscription_id>>"
  tags = {
    "Resourcetype" = ""
  }
}

resource_initials = {
  storage_account  = "sa"
  resource_group   = "rg"
  storage_blob     = "sblob"
  app_service_plan = "asp"
  app_service      = "appsvc"
  sql_server       = "sqlsvr"
  sql_db           = "sqldb"
  app_gateways     = "ag"
  vnet             = "vnet"
  subnet           = "sn"
  private_endpoint = "pe"
  key_vault        = "kv"
  public_ip        = "pip"
}


storages = {
  tfstate = {
    resource_groups                 = "3tiertfstate"
    storageaccount_tier             = "Standard"
    storageaccount_replication_type = "LRS"
    sa_enable_https_traffic_only    = "true"
    network_rule_action             = "Allow"
  }
}

storage_blobs = {
  tfstate = {
    container_access_type = "private"
    storage_index         = "tfstate"
  }
}

app_service_plan = {
  UI = {
    name                         = "apps"
    kind                         = "Linux"
    reserved                     = true
    maximum_elastic_worker_count = 1
    sku = {
      plan_sku = {
        tier     = "Basic"
        size     = "B1"
        capacity = 1
      }
    }
  }
}

app_service = {
  appsvc-ui = {
    name             = "UserInterface"
    plan-index       = "UI"
    https_only       = true
    client_cert_mode = "Required"
  }
}

subnet_var = {
  snag = {
    vnet-index            = "vnet"
    name                  = "sn-ag-ui"
    subnet_address_prefix = ["10.0.1.0/24"]
  }
  snsql = {
    vnet-index            = "vnet"
    name                  = "sn-sql"
    subnet_address_prefix = ["10.0.2.0/24"]
  }
  snagsvc = {
    vnet-index            = "vnet"
    name                  = "sn-ag-svc"
    subnet_address_prefix = ["10.0.3.0/24"]
  }

}

virtualnet_variables = {
  vnet = {
    name            = "vnet"
    address_space   = ["10.0.0.0/16"]
    resource_groups = "3tier"
  }

}

app_gateways = {
  ag = {
    name                           = "ag"
    frontend_ip_configuration_name = "ag-frontend-ip-config"
    sn-index                       = "snag"
    frontend_port = {
      listener_admin = {
        name = "ag-frontend-port_443"
        port = "443"
      }
    }
    gateway_ip_configuration_name = "ag-gateway-ip-config"
    sku_capacity                  = 2
    sku_name                      = "WAF_v2"
    sku_tier                      = "WAF_v2"
    public_ip_index               = "ag_pip"
    backend_http_settings = {
      http_settings_443 = {
        cookie_based_affinity = "Disabled"
        name                  = "bp-backend"
        port                  = 443
        protocol              = "Http"
        request_timeout       = 60
      }
    }
    request_routing_rule = {
      listener_admin = {
        name                       = "ag-request-route-rule"
        rule_type                  = "Basic"
        http_listener_name         = "ag-http-listener"
        backend_address_pool_name  = "ag-backend-address-pool"
        backend_http_settings_name = "ag-backend-http-settings"
      }
    }
    http_listener = {
      listener_admin = {
        name                           = "ag-http-listener"
        protocol                       = "Http"
        frontend_ip_configuration_name = "ag-frontend-ip-config"
        frontend_port_name             = "ag-frontend-port_80"
      }
    }
    backend_address_pool = {
      add_pool_default = {
        name = "pool-backend-service-80-bp-80"
      }
    }
  }
  agsvc = {
    name                           = "agsvc"
    frontend_ip_configuration_name = "agsvc-frontend-ip-config"
    sn-index                       = "snagsvc"
    frontend_port = {
      listener_admin = {
        name = "agsvc-frontend-port_443"
        port = "443"
      }
    }
    gateway_ip_configuration_name = "agsvc-gateway-ip-config"
    sku_capacity                  = 2
    sku_name                      = "WAF_v2"
    sku_tier                      = "WAF_v2"
    public_ip_index               = "agsvc_pip"
    backend_http_settings = {
      http_settings_443 = {
        cookie_based_affinity = "Disabled"
        name                  = "bp-backend"
        port                  = 443
        protocol              = "Http"
        request_timeout       = 60
      }
    }
    request_routing_rule = {
      listener_admin = {
        name                       = "agsvc-request-route-rule"
        rule_type                  = "Basic"
        http_listener_name         = "agsvc-http-listener"
        backend_address_pool_name  = "agsvc-backend-address-pool"
        backend_http_settings_name = "agsvc-backend-http-settings"
      }
    }
    http_listener = {
      listener_admin = {
        name                           = "agsvc-http-listener"
        protocol                       = "Http"
        frontend_ip_configuration_name = "agsvc-frontend-ip-config"
        frontend_port_name             = "agsvc-frontend-port_80"
      }
    }
    backend_address_pool = {
      add_pool_default = {
        name = "pool-backend-service-80-bp-80"
      }
    }
  }
}

sql_server = {
  sql = {
    name                          = "sqlserveradmin"
    version                       = "12.0"
    identity                      = {}
    threat_detection_policy       = {}
    vnet_index                    = "vnet"
    sn_index                      = "snsql"
    vnet_rule_name                = "sqlvnetrule-admin"
    public_network_access_enabled = "true"
    administrator_login           = "sqlsvruser"
    minimum_tls_version           = "1.2"
  }
}

sql_db = {
  db = {
    name                       = "sql-db"
    server-index               = "sql"
    plan-index                 = "collector"
    sku_name                   = "Basic"
    collation                  = "SQL_Latin1_General_CP1_CI_AS"
    long_term_retention_policy = {}
    short_term_retention_policy = {
      admin-retention-policy = {
        retention_days = 7
      }
    }
    identity                = {}
    threat_detection_policy = {}
  }
}

kv = {
  kv-name        = "secret"
  kv_sku         = "standard"
  kv_secret_name = "sql-password"
}

public_ip = {
  ag_pip = {
    name              = "ag"
    allocation_method = "Dynamic"
  }
  agsvc_pip = {
    name              = "agsvc"
    allocation_method = "Dynamic"
  }
}

random_password_length           = 16
random_password_special          = true
random_password_override_special = "!#$%\u0026*()-_=+[]{}\u003c\u003e:?"
