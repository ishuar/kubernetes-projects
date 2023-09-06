resource "azurerm_virtual_network" "aks" {
  name                = "vnet-aks-docker-registry-${local.tags["github_repo"]}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  tags                = local.tags
}

resource "azurerm_subnet" "aks_node" {
  name                 = "snet-aks-node-${local.tags["github_repo"]}"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "aks_api" {
  name                 = "snet-aks-api-${local.tags["github_repo"]}"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = ["10.0.2.0/24"]
  delegation {

    name = "aks-api-access-profile"
    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}