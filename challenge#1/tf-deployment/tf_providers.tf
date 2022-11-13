terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.31.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.2"
    }
  }
    backend "azurerm" {
      storage_account_name = "satrainingtfstate"
      container_name       = "sblobtfstate"
      key                  = "training.tfstate"
      use_azuread_auth     = true
      subscription_id      = "<<subscription_id>>"
      tenant_id            = "<<tenant_id>>"
    }
}

provider "azuread" {
  # Configuration options
}

provider "azurerm" {
  # Configuration options
  tenant_id       = var.project_variables.tenant_id
  subscription_id = var.project_variables.subscription_ids
  features {
  }
}


provider "random" {
  # Configuration options
}
