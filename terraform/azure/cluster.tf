resource "azurerm_resource_group" "resource_group" {
  name     = var.name
  location = var.location
}

module "network" {
  source  = "Azure/network/azurerm"
  version = "~>3.5.0"

  vnet_name           = var.name
  resource_group_name = azurerm_resource_group.resource_group.name
  address_spaces      = var.network_address_spaces
  subnet_prefixes     = var.network_subnet_prefixes
  subnet_names        = var.network_subnet_names
  depends_on          = [azurerm_resource_group.resource_group]
}
