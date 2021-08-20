variable "project_id" {
  description = "Project ID for all created resources"
  type        = string
}

variable "name" {
  description = "The name of the cluster"
  type        = string
  default     = "graph-indexer"
}

variable "regional" {
  description = "Whether is a regional cluster (WARNING: changing this after cluster creation is destructive!) "
  type        = bool
  default     = true
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "Zones to host the cluster in"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "ip_range_nodes" {
  type        = string
  description = "The ip range of the subnet that would be used for nodes"
  default     = "10.128.0.0/20"
}

variable "ip_range_pods" {
  type        = string
  description = "The secondary ip range of subnet that would be used for pods"
  default     = "10.32.0.0/14"
}

variable "ip_range_services" {
  type        = string
  description = "The secondary ip range of subnet that would be used for pods"
  default     = "10.36.0.0/20"
}

variable "node_pools" {
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

variable "node_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Map of lists containing node taints by node-pool name"
  default     = {}
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name"
  default     = {}
}

variable "release_channel" {
  type        = string
  description = "Specifies release channel for kubernetes versions"
  default     = "STABLE"
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  default     = "latest"
}

variable "monitoring_enabled" {
  type        = bool
  description = "Enables GCP built in metrics collection (Disabled by default to prevent extra spents)"
  default     = false
}

variable "logging_enabled" {
  type        = bool
  description = "Enables GCP built in logs collection (Disabled by default to prevent extra spents)"
  default     = false
}
