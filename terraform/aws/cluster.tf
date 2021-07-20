module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~>3.2.0"
  name = var.name
  cidr = var.vpc_cidr

  azs             = var.avalability_zones
  public_subnets = var.public_subnet_cidrs

  enable_nat_gateway = true
}

# data "aws_eks_cluster" "cluster" {
#   name = module.cluster.cluster_id
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.cluster.cluster_id
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   load_config_file       = false
# }

# module "cluster" {
#   source          = "terraform-aws-modules/eks/aws"
#   version         = "~>17.1.0"
#   cluster_name    = var.name
#   cluster_version = "1.17"
#   subnets         = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
#   vpc_id          = "vpc-1234556abcdef"

#   worker_groups = [
#     {
#       instance_type = "m4.large"
#       asg_max_size  = 5
#     }
#   ]
# }
