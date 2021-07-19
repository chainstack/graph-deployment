variable "k8s_provider" {
  type        = string
  description = "Selects provider that would be used for creation of k8s cluster"

  validation {
    condition     = contains(["gke"], var.k8s_provider)
    error_message = "Specified k8s provider is not in supported list."
  }
}

variable "name" {
  description = "The name of the cluster"
  type        = string
  default     = "graph-indexer"
}

variable "indexer_mode" {
  description = "The mode of the indexer"
  type        = string
  default     = "network"

  validation {
    condition     = contains(["network", "standalone"], var.indexer_mode)
    error_message = "Specified indexer_mode is not in supported list."
  }
}

## Google Cloud
variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
  default     = ""
}

variable "gcp_regional" {
  type        = bool
  description = "Whether is a regional cluster (WARNING: changing this after cluster creation is destructive!)"
  default     = true
}

variable "gcp_region" {
  description = "The GCP region to host the cluster in"
  type        = string
  default     = "us-central1"
}

variable "gcp_zones" {
  description = "GCP Zones to host the zones in"
  type        = list(string)
  default     = ["us-central1-a"]
}

variable "gcp_ip_range_nodes" {
  type        = string
  description = "The ip range of the subnet that would be used for nodes"
  default     = "10.128.0.0/20"
}

variable "gcp_ip_range_pods" {
  type        = string
  description = "The secondary ip range of subnet that would be used for pods"
  default     = "10.32.0.0/14"
}

variable "gcp_ip_range_services" {
  type        = string
  description = "The secondary ip range of subnet that would be used for pods"
  default     = "10.36.0.0/20"
}

variable "gcp_node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools"
  default = [
    {
      name               = "default"
      machine_type       = "e2-standard-4"
      initial_node_count = 1
      min_count          = 0
      max_count          = 3
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
    }
  ]
}

variable "gcp_node_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Map of lists containing node taints by node-pool name"
  default     = {}
}

variable "gcp_node_pools_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name"
  default     = {}
}

variable "gcp_release_channel" {
  type        = string
  description = "Specifies release channel for kubernetes versions"
  default     = "STABLE"
}
