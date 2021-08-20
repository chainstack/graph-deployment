module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~>3.3.0"
  project_id   = var.project_id
  network_name = var.name

  subnets = [{
    subnet_name   = var.name
    subnet_region = var.region
    subnet_ip     = var.ip_range_nodes
  }]

  secondary_ranges = {
    (var.name) = [
      {
        range_name    = "pods"
        ip_cidr_range = var.ip_range_pods
      },
      {
        range_name    = "services"
        ip_cidr_range = var.ip_range_services
      }
    ]
  }
}

module "gke" {
  source                            = "terraform-google-modules/kubernetes-engine/google"
  version                           = "~>16.0.1"
  project_id                        = var.project_id
  name                              = var.name
  kubernetes_version                = var.kubernetes_version
  regional                          = var.regional
  region                            = var.region
  zones                             = var.zones
  network                           = module.vpc.network_name
  subnetwork                        = module.vpc.subnets_names[0]
  ip_range_pods                     = "pods"
  ip_range_services                 = "services"
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = true
  http_load_balancing               = false

  logging_service    = var.logging_enabled ? "logging.googleapis.com/kubernetes" : "none"
  monitoring_service = var.monitoring_enabled ? "monitoring.googleapis.com/kubernetes" : "none"

  node_pools        = var.node_pools
  node_pools_labels = var.node_pools_labels
  node_pools_taints = var.node_pools_taints

  release_channel = var.release_channel
}
