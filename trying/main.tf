provider "azurerm" {
  features {}
  subscription_id   = "437f4153-e76c-4e6a-82b4-65ac394befa4"
  client_id         = "0a9723c8-1725-4d46-b9f4-418b38cb1db0"
  client_secret     = "5md8Q~TYS.CLQO.4_N-v-a1C5UJe2Im.RafcxasA"
  tenant_id         = "b63b1848-777d-4f1b-a158-bbe5afbb52b8"
}

resource "azurerm_resource_group" "test_rg" {
  name     = var.azurerm_resource_group-name
  location = var.location
} 