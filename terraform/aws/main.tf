terraform {
  required_version = "~> 1.0.2"

  required_providers {
    google = {
      source  = "hashicorp/aws"
      version = "~>3.50.0"
    }
  }
}

provider "aws" {
}
