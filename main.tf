terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "security" {
  source              = "./modules/security"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.private_subnet_id
}

module "monitoring" {
  source              = "./modules/monitoring"
  resource_group_name = var.resource_group_name
  location            = var.location
  nsg_id              = module.network.nsg_id
  lb_id               = module.compute.lb_id
  kv_id               = module.security.key_vault_id
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.private_subnet_id
  key_vault_id        = module.security.key_vault_id
  law_id              = module.monitoring.law_id
}

module "database" {
  source              = "./modules/database"
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_password      = module.security.admin_password
}