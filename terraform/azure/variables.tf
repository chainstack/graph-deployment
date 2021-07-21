variable "client_id" {
  description = "Azure Client AD"
  default     = null
}

variable "client_secret" {
  description = "Azure Client Secret"
  default     = null
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  default     = null
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  default     = null
}

variable "name" {
  description = "The name of the cluster"
  type        = string
  default     = "graph-indexer"
}

variable "location" {
  description = "The location where resources would be created"
  type        = string
  default     = "East US 2"
}

variable "network_address_spaces" {
  description = "IP range that would be used for created virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "network_subnet_prefixes" {
  description = "IP ranges for subnetworks, that would be created in virtual network. Ranges must be subranges of network_address_spaces."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "network_subnet_names" {
  description = "Names for subnetworks, that would be created in virtual network. Ranges must be subranges of network_address_spaces."
  type        = list(string)
  default     = ["aks"]
}
