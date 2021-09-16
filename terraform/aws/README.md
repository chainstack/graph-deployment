# Amazon Web Services (AWS) Terraform

This Terraform project creates a Kubernetes cluster in AWS from scratch. This is required to deploy The Graph indexer at later steps.

## Install prerequisites

| Tool | Recommended version | Install documentation link |
| ------------ | ------------ | ------------ |
| Terraform | `~> 1.0.2` | [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform)|
| Kubectl | Latest | [Install Tools: kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)|
| AWS CLI | Latest `> 2.0.0` | [Installing the AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |

## Apply Terraform

### Auth in AWS

Get the AWS access key using the AWS guide: [AWS Account and Access Keys](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html).

Having obtained the access key, run in terminal:

```
aws configure
```

And input your Access Key ID and your Secret Access Key.

### Fill variables

Copy the example variables file `terraform.example.tfvars` to `terraform.tfvars` in the `terraform/aws` directory.

Most variables are optional and Terraform will prompt you for variables if you have not filled the required ones.

You can also override the variables defined in `variables.tf`

### Run `terraform apply`

Go to the `terraform/aws` directory and run the following command in terminal:

```
# you will need to run terraform init if terraform has yet to be initialiized
# a .terraform.lock.hcl file will be present if terraform is initialized
terraform init

terraform apply
```

After calculating the diff, you will be asked if you want to apply the changes. Type `yes` and press **Enter**.

### Get kubectl config for the created cluster

---

**Note: Using AWS CLI version 1.x.x**

We highly recommend that you use the 2.x.x version of AWS CLI.

You can check your AWS CLI version by running the following command:

```
aws --version
```

But if you are using AWS CLI v1, the following notes can help you:

* If you are using AWS CLI version ealier than 1.16.156, you will need to install `aws-iam-authenticator` before you can run `aws eks`. For installation instructions, see [Installing aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html).
* If you are using AWS CLI verion 1.16.156 or later you can run `aws eks get-token` instead.
For more information about creating kubeconfig for Amazon EKS, see [Create a kubeconfig for Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html).

---

```
aws eks --region <region-code> update-kubeconfig --name <cluster_name>
```

If you use the default values provided in `variables.tf`, run:

```
aws eks --region us-east-1 update-kubeconfig --name graph-indexer
```

### Test that kubectl config works

```
kubectl get ns,node
```

## Destroy Terraform

**If you have active services or ingresses in your cluster that are associated with a load balancer, you must delete those services/ingresses before deleting the cluster so that the load balancers are deleted properly. Otherwise, you can have orphaned resources in your VPC that prevent you from being able to delete the VPC.**

This step deletes all resources that were created by Terraform.

Go to the `terraform/aws` directory and run the following command in terminal:

```
terraform destroy
```

After calculating the diff, you will be asked if you want to apply the changes. Type `yes` and press **Enter**.
