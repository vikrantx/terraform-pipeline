terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.9.0"
    }
  }

#   backend "azurerm" {
#     resource_group_name = "rg-tfstorage"
#     storage_account_name = "tfbootcampstorageaccount"
#     container_name = "tfstoragecontainer"
#     key = "terraform.tfstate"
#   }
}

provider "azurerm" {
  features {}
}