terraform {
  required_version = "~> 1.0.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.75.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.3.2"
    }
    helmfile = {
      source  = "mumoshu/helmfile"
      version = "~>0.14.0"
    }
  }
}

provider "helmfile" {}

provider "google" {
  project = var.gcp_project_id
}

locals {
  tmp_path        = "${path.module}/tmp/"
  kubeconfig_path = "${local.tmp_path}kubeconfig"
}

resource "helmfile_release_set" "indexer" {
  working_directory = "../helmfile/"
  content           = file("../helmfile/helmfile-${var.indexer_mode}.yaml")
  kubeconfig        = local.kubeconfig_path

  depends_on = [local_file.kubeconfig]
}
