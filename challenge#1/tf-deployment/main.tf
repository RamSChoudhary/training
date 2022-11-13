module "subs_tfstate" {
  source            = "../tf-state"
  project_variables = var.project_variables
  resource_initials = var.resource_initials
  storages          = var.storages
  storage_blobs     = var.storage_blobs
}


module "subs_infra" {
  source                           = "../tf-modules"
  resource_initials                = var.resource_initials
  project_variables                = var.project_variables
  app_service_plan                 = var.app_service_plan
  app_service                      = var.app_service
  sql_server                       = var.sql_server
  sql_db                           = var.sql_db
  app_gateways                     = var.app_gateways
  virtualnet_variables             = var.virtualnet_variables
  subnet_var                       = var.subnet_var
  kv                               = var.kv
  public_ip                        = var.public_ip
  random_password_override_special = var.random_password_override_special
  random_password_special          = var.random_password_special
  random_password_length           = var.random_password_length
}