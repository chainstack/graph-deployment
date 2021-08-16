# AWS terraform
This terraform project creates kubernetes cluster in AWS from scratch. It's required in order deploy The Graph indexer on later steps.

## Install prerequisites
| Tool | Recommended version | Install documentation link |
| ------------ | ------------ | ------------ |
| Terraform | `~> 1.0.2` | https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform |
| Kubectl | Latest | https://kubernetes.io/docs/tasks/tools/#kubectl |
| AWS cli | Latest `> 2.0.0` | https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html |

## Apply terraform
### Auth in aws
Get AWS access key using this guide https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html .

Run in terminal:
```
aws configure
```
And input Access Key ID and Secret Access Key.

### Fill variables
Copy example variables file `terraform.example.tfvars` to `terraform.tfvars` in the `terraform/aws` directory.
Most variables are optional and terraform will prompt you for variables if you have not filled required variables.
You can also override variables defined in `variables.tf`

### Run terraform apply
Go to the `terraform/aws` directory and run following command in terminal:
```
# you will need to run terraform init if terraform has yet to be initialiized
# a .terraform.lock.hcl file will be present if terraform is initialized
terraform init

terraform apply
```

After calculating the diff you will be asked if you want to apply changes. Type `yes` and press `enter`.

### Get kubectl config for created cluster
---
**Note: Using AWS CLI version 1.x.x**

We highly recommends you to use 2.x.x version of AWS CLI.

You can check your AWS CLI version by running following command:
```
aws --version
```

But if you are using AWS CLI v1 the next notes could help you:
* If you are using AWS CLI version ealier than 1.16.156 you will need to install `aws-iam-authenticator` before you can run `aws eks`.
[Installation instructions](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html).
* If you are using AWS CLI verion 1.16.156 or later you can run `aws eks get-token` instead.
More information about creating kubeconfig for Amazon EKS can be found [here](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html).
---


```
aws eks --region <region-code> update-kubeconfig --name <cluster_name>
```

If you use the default values provided in variables.tf it would be:
```
aws eks --region us-east-1 update-kubeconfig --name graph-indexer
```

### Test that kubectl config works
```
kubectl get ns,node
```

## Destroy terraform
**If you have active services or ingresses in your cluster that are associated with a load balancer, you must delete those services/ingresses before deleting the cluster so that the load balancers are deleted properly. Otherwise, you can have orphaned resources in your VPC that prevent you from being able to delete the VPC.**
This step deletes all resources that were created by terraform.

Go to the `terraform/aws` directory and run following command in terminal:
```
terraform destroy
```

After calculating the diff you will be asked if you want to apply changes. Type `yes` and press `enter`.
