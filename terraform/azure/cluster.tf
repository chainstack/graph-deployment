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
  subnet_names        = [var.network_subnet_name]
  depends_on          = [azurerm_resource_group.resource_group]
}

module "cluster" {
  source  = "Azure/aks/azurerm"
  version = "~>4.13.0"

  resource_group_name             = azurerm_resource_group.resource_group.name
  cluster_name                    = var.name
  prefix                          = var.prefix
  kubernetes_version              = var.kubernetes_version
  orchestrator_version            = var.kubernetes_version
  vnet_subnet_id                  = module.network.vnet_subnets[0]
  os_disk_size_gb                 = var.os_disk_size_gb
  sku_tier                        = var.sku_tier
  network_plugin                  = var.network_plugin
  enable_http_application_routing = false
  enable_auto_scaling             = true

  agents_min_count = var.agents_min_count
  agents_max_count = var.agents_max_count
  agents_count     = var.agents_count

  agents_size               = var.agents_size
  agents_pool_name          = var.agents_pool_name
  agents_availability_zones = var.agents_availability_zones
  agents_type               = var.agents_type
  public_ssh_key            = var.public_ssh_key

  agents_labels = var.agents_labels
  agents_tags   = var.agents_tags

  net_profile_dns_service_ip     = var.net_profile_dns_service_ip
  net_profile_docker_bridge_cidr = var.net_profile_docker_bridge_cidr
  net_profile_service_cidr       = var.net_profile_service_cidr

  enable_log_analytics_workspace = var.enable_log_analytics_workspace
  depends_on                     = [module.network]
}
