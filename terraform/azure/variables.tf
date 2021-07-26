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
  default     = ["10.1.0.0/16"]
}

variable "network_subnet_prefixes" {
  description = "IP ranges for subnetworks, that would be created in virtual network. Ranges must be subranges of network_address_spaces."
  type        = list(string)
  default     = ["10.1.1.0/24"]
}

variable "network_subnet_name" {
  description = "Name for subnetwork, that would be created in virtual network. Ranges must be subranges of network_address_spaces."
  type        = string
  default     = "aks"
}

variable "prefix" {
  description = "The prefix for the resources created in the specified Azure Resource Group"
  type        = string
  default     = "GraphIndexer"
}

variable "kubernetes_version" {
  description = "Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = null
}

variable "orchestrator_version" {
  description = "Specify which Kubernetes release to use for the orchestration layer. The default used is the latest Kubernetes version available in the region"
  type        = string
  default     = null
}

variable "os_disk_size_gb" {
  description = "Disk size of nodes in GBs."
  type        = number
  default     = 50
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid"
  type        = string
  default     = "Free"
}

variable "network_plugin" {
  description = "Network plugin to use for networking."
  type        = string
  default     = "kubenet"
}

variable "agents_type" {
  description = "The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets."
  type        = string
  default     = "VirtualMachineScaleSets"
}

variable "net_profile_dns_service_ip" {
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
  type        = string
  default     = "10.0.0.10"
}

variable "net_profile_docker_bridge_cidr" {
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Changing this forces a new resource to be created."
  type        = string
  default     = "170.10.0.1/16"
}

variable "net_profile_service_cidr" {
  description = "The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_log_analytics_workspace" {
  type        = bool
  description = "(Cost extra money) Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not"
  default     = false
}

variable "agents_tags" {
  description = "A mapping of tags to assign to the Node Pool."
  type        = map(string)
  default     = {}
}

variable "agents_labels" {
  description = "A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created."
  type        = map(string)
  default     = {}
}

variable "public_ssh_key" {
  description = "A custom ssh key to control access to the AKS cluster"
  type        = string
  default     = ""
}

variable "agents_max_count" {
  type        = number
  description = "Maximum number of nodes in a pool"
  default     = 3
}

variable "agents_min_count" {
  type        = number
  description = "Minimum number of nodes in a pool"
  default     = 1
}

variable "agents_count" {
  description = "The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes."
  type        = number
  default     = null
}

variable "agents_size" {
  description = "The default virtual machine size for the Kubernetes agents"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "agents_pool_name" {
  description = "The default Azure AKS agentpool (nodepool) name."
  type        = string
  default     = "nodepool"
}

variable "agents_availability_zones" {
  description = "A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
  type        = list(string)
  default     = ["1", "2", "3"]
}
