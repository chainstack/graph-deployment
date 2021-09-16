# Azure Terraform

This Terraform project creates a Kubernetes cluster in Azure from scratch. This is required to deploy The Graph indexer at later steps.

## Install prerequisites

| Tool | Recommended version | Install documentation link |
| ------------ | ------------ | ------------ |
| Terraform | `~> 1.0.2` |[Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform) |
| Kubectl | Latest | [Install Tools: kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) |
| Azure cli | Latest |[Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)|

## Apply Terraform

### Auth in Azure

Run in terminal:

```
az login
```

This will open the Microsoft login page in your browser. Log in to your account.

### Fill variables

Copy the sample variables file `terraform.example.tfvars` to `terraform.tfvars` in the `terraform/azure` directory.

Most variables are optional and Terraform will prompt you for variables if you have not filled the required ones.

You can also override the variables defined in `variables.tf`

### Run `terraform apply`

Go to the `terraform/azure` directory and run the following command in terminal:

```
# you will need to run terraform init if terraform has yet to be initialiized
# a .terraform.lock.hcl file will be present if terraform is initialized
terraform init

terraform apply
```

After calculating the diff, you will be asked if you want to apply the changes. Type `yes` and press **Enter**.

### Get kubectl config for the created cluster

```
az aks get-credentials --resource-group <name> --name <name>
```

### Test that kubectl config works

```
kubectl get ns,node
```

## Destroy Terraform

**If you have active services or ingresses in your cluster that are associated with a load balancer, you must delete those services/ingresses before deleting the cluster so that the load balancers are deleted properly. Otherwise, you can have orphaned resources in your VPC that prevent you from being able to delete the VPC.**

This step deletes all resources that were created by Terraform.

Go to the `terraform/azure` directory and run the following command in terminal:

```
terraform destroy
```

After calculating the diff, you will be asked if you want to apply the changes. Type `yes` and press **Enter**.
