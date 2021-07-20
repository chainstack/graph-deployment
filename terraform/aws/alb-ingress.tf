provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "http" {}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~>4.2.0"
  create_role                   = true
  role_name                     = "aws-load-balancer-controller"
  provider_url                  = replace(module.cluster.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.aws-load-balancer-controller.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}

data "http" "aws-load-balancer-controller-policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

resource "aws_iam_policy" "aws-load-balancer-controller" {
  name_prefix = "aws-load-balancer-controller"
  description = "EKS aws-load-balancer-controller policy for cluster ${module.cluster.cluster_id}"
  policy      = data.http.aws-load-balancer-controller-policy.body
}

resource "helm_release" "ingress" {
  name       = "ingress"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "v1.2.3"

  set {
    name  = "clusterName"
    value = var.name
  }

  set {
    name  = "ingressClass"
    value = "null"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_admin.iam_role_arn
  }

  depends_on = [
    module.cluster
  ]
}
