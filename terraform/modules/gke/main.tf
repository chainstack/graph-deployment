module "vpc" {
  source = "terraform-google-modules/network/google"
  version = "~>3.3.0"
  project_id                        = var.project_id
  network_name = var.name

  subnets = [{
    subnet_name = var.name
    subnet_region = var.region
    subnet_ip = var.ip_range_nodes
  }]

  secondary_ranges = {
    (var.name) = [
      {
        range_name = "pods"
        ip_cidr_range = var.ip_range_pods
      },
      {
        range_name = "services"
        ip_cidr_range = var.ip_range_services
      }
    ]
  }
}

module "gke" {
  source                            = "terraform-google-modules/kubernetes-engine/google"
  version = "~>15.0.2"
  project_id                        = var.project_id
  name                              = var.name
  regional                          = var.regional
  region                            = var.region
  zones                             = var.zones
  network                           = module.vpc.network_name
  subnetwork                        = module.vpc.subnets_names[0]
  ip_range_pods                     = "pods"
  ip_range_services                 = "services"
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = true

  node_pools = var.node_pools
  node_pools_labels = var.node_pools_labels
  node_pools_taints = var.node_pools_taints

  release_channel = var.release_channel
}

data "google_client_config" "default" {}

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig-template.yaml")

  vars = {
    name = var.name
    endpoint = "https://${module.gke.endpoint}"
    ca_cert = module.gke.ca_certificate
    token = data.google_client_config.default.access_token
  }
}
