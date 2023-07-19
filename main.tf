terraform {
  required_version = ">=1.5.0"
  required_providers {
    azurerm = {
      "source" = "hashicorp/azurerm"
      version  = "3.65.0"
    }
  }
}

terraform {
  cloud {
    organization = "CloudDave"

    workspaces {
      name = "storage-pipeline"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "random_string" "uniquestring" {
  length           = 20
  special          = false
  upper            = false
}

resource "azurerm_resource_group" "rg" {
  name     = rg-terraform
  location = "UK South"
}

module "securestorage" {
  source  = "app.terraform.io/CloudDave/securestorage/azurerm"
  version = "2.0.0"
  # insert required variables here
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name = "stg${random_string.uniquestring.result}"
}
