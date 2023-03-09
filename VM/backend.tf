terraform {
  backend "azurerm" {
    resource_group_name  = "Test"
    storage_account_name = "storagefortesttrep"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}