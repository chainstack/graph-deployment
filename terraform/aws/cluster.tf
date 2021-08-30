module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>3.2.0"
  name    = var.name
  cidr    = var.vpc_cidr

  azs            = var.avalability_zones
  public_subnets = var.public_subnet_cidrs

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb"            = 1
    "kubernetes.io/cluster/${var.name}" = "owned"
  }
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

locals {
  # Splitting node groups per AZ (subnet) to make EBS PVs triger scale up of needed AZ
  # https://github.com/kubernetes/autoscaler/issues/1431, https://github.com/kubernetes/autoscaler/issues/3845,
  # Based on: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/346#issuecomment-544857715

  node_groups = flatten([
    for i, subnet in module.vpc.public_subnets :
    [
      for ng_name, ng in var.node_groups : merge(ng, { subnets : [subnet], _name : "${ng_name}-${module.vpc.azs[i]}" })
    ]
  ])
}

module "cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~>17.1.0"
  cluster_name    = var.name
  cluster_version = var.kubernetes_version
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa      = true
  write_kubeconfig = false

  node_groups = {
    for i in local.node_groups : i._name => i
  }
}
