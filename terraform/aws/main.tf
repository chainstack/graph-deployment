terraform {
  required_version = "~> 1.0.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.50.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.3.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.2.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}
