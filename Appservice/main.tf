provider "azurerm" {
  features {}
  subscription_id   = "437f4153-e76c-4e6a-82b4-65ac394befa4"
  client_id         = "0a9723c8-1725-4d46-b9f4-418b38cb1db0"
  client_secret     = "5md8Q~TYS.CLQO.4_N-v-a1C5UJe2Im.RafcxasA"
  tenant_id         = "b63b1848-777d-4f1b-a158-bbe5afbb52b8"
}

resource "azurerm_resource_group" "test_rg" {
  name     = "test6"
  location = "West Europe"
} 

resource "azurerm_virtual_network" "test_vnet" {
  name                = "vnet03"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
  address_space       = ["10.4.0.0/16"]
}

# Subnets for App Service instances
resource "azurerm_subnet" "test_sub1" {
  name                 = "subnet01"
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = ["10.4.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
  }


resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "royal01"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app_service" {
  name                = "rompi01"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  /* #(Optional)
  site_config {
      dotnet_framework_version = "v4.0"
      scm_type                 = "LocalGit"
  }
  
  #(Optional)
  app_settings = {
      "SOME_KEY" = "some-value"
  }*/

}

#private endpoint

resource "azurerm_private_endpoint" "pe1" {
  name                = "${azurerm_app_service.app_service.name}-endpoint"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
  subnet_id           = azurerm_subnet.test_sub1.id
  

  private_service_connection {
    name                           = "${azurerm_app_service.app_service.name}-privateconnection"
    private_connection_resource_id = azurerm_app_service.app_service.id
    subresource_names = ["sites"]
    is_manual_connection = false
  }
}

# private DNS
resource "azurerm_private_dns_zone" "dns1" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.test_rg.name
}

#private DNS Link
resource "azurerm_private_dns_zone_virtual_network_link" "dnszone1" {
  name                  = "${azurerm_app_service.app_service.name}-dnslink"
  resource_group_name   = azurerm_resource_group.test_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns1.name
  virtual_network_id    = azurerm_virtual_network.test_vnet.id
  registration_enabled = false
}

resource "azurerm_subnet" "test_sub2" {
  name                 = "subnet02"
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  address_prefixes     = ["10.4.2.0/27"]

  delegation {
    name = "delegation"

    service_delegation {
        actions = [
            "Microsoft.Network/virtualNetworks/subnets/action",
            "Microsoft.Network/virtualNetworks/subnets/join/action"
          ]
        name    = "Microsoft.Web/serverFarms"
      }
  }
}