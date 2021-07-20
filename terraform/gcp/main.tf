terraform {
  required_version = "~> 1.0.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.75.0"
    }
  }
}

provider "google" {
  project = var.project_id
}
