module "gke" {
  source = "./modules/gke"

  project_id = var.gcp_project_id
  name       = var.name

  regional = var.gcp_regional
  region   = var.gcp_region
  zones    = var.gcp_zones

  ip_range_nodes    = var.gcp_ip_range_nodes
  ip_range_pods     = var.gcp_ip_range_pods
  ip_range_services = var.gcp_ip_range_services

  node_pools        = var.gcp_node_pools
  node_pools_taints = var.gcp_node_pools_taints
  node_pools_labels = var.gcp_node_pools_labels

  release_channel = var.gcp_release_channel

  count = var.k8s_provider == "gke" ? 1 : 0
}

resource "local_file" "kubeconfig" {
  content  = module.gke[0].kubeconfig
  filename = local.kubeconfig_path
}
