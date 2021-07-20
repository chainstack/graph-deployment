module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~>3.2.0"
  name = var.name
  cidr = var.vpc_cidr

  azs             = var.avalability_zones
  public_subnets = var.public_subnet_cidrs

  enable_nat_gateway = true
}

data "aws_eks_cluster" "cluster" {
  name = module.cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

module "cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~>17.1.0"
  cluster_name    = var.name
  cluster_version = var.kubernetes_version
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  write_kubeconfig = false

  worker_groups = var.worker_groups
}

resource "helm_release" "ingress" {
  name       = "ingress"
  namespace = "kube-system"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "v1.2.3"

  set {
    name  = "clusterName"
    value = var.name
  }

  set {
    name = "ingressClass"
    value = "null"
  }

  depends_on = [
    module.cluster
  ]
}
