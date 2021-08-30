variable "name" {
  description = "The name of the cluster"
  type        = string
  default     = "graph-indexer"
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = "us-east-1"
}

variable "avalability_zones" {
  description = "Zones to host the cluster in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_cidr" {
  description = "IP range that would be used for created VPC"
  type        = string
  default     = "172.31.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "IP ranges for public subnetworks, that would be created in VPC. Ranges must be subranges of vpc_cidr."
  type        = list(string)
  default     = ["172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20"]
}

variable "kubernetes_version" {
  description = "Kubernetes version that would be installed"
  type        = string
  default     = "1.19"
}

variable "node_groups" {
  description = "Definition of EKS managed node groups"
  type        = any # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/variables.tf#L329
  default = {
    default = {
      desired_capacity  = 1
      max_capacity      = 3
      min_capacity      = 0
      enable_monitoring = false

      instance_types = ["m4.xlarge"]
      capacity_type  = "SPOT"
    }
  }
}
