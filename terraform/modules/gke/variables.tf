variable "project_id" {
  description = "Project ID for all created resources"
  type        = string
}

variable "name" {
  description = "The name of the cluster"
  type        = string
}

variable "regional" {
  description = "Whether is a regional cluster (WARNING: changing this after cluster creation is destructive!) "
  type        = bool
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
}

variable "zones" {
  description = "Zones to host the cluster in"
  type        = list(string)
}

variable "ip_range_nodes" {
  type        = string
  description = "The ip range of the subnet that would be used for nodes"
}

variable "ip_range_pods" {
  type        = string
  description = "The secondary ip range of subnet that would be used for pods"
}

variable "ip_range_services" {
  type        = string
  description = "The secondary ip range of subnet that would be used for pods"
}

variable "node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools"
}

variable "node_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Map of lists containing node taints by node-pool name"
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name"
}

variable "release_channel" {
    type = string
    description = "Specifies release channel for kubernetes versions"
}
