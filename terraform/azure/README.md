# Azure terraform
This terraform project creates kubernetes cluster in Azure from scratch. It's required in order deploy The Graph indexer on later steps.

## Install prerequisites
| Tool | Recommended version | Install documentation link |
| ------------ | ------------ | ------------ |
| Terraform | `~> 1.0.2` | https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform |
| Kubectl | Latest | https://kubernetes.io/docs/tasks/tools/#kubectl |
| Azure cli | Latest | https://docs.microsoft.com/en-us/cli/azure/install-azure-cli |

## Apply terraform
### Auth in Azure
Run in terminal:
```
az login
```

Browser with Microsoft login page would be opened. Log in to your account.

### Fill variables
Copy example variables file `terraform.example.tfvars` to `terraform.tfvars` in the `terraform/azure` directory.
You can also override variables defined in `variables.tf`

### Run terraform apply
Go to the `terraform/azure` directory and run following command in terminal:
```
terraform apply
```

After calculating the diff you will be asked if you want to apply changes. Type `yes` and press `enter`.

### Get kubectl config for created cluster
```
aws eks --region <region-code> update-kubeconfig --name <cluster_name>
```

### Test that kubectl config works
```
kubectl get ns,node
```

## Destroy terraform
**If you have active services or ingresses in your cluster that are associated with a load balancer, you must delete those services/ingresses before deleting the cluster so that the load balancers are deleted properly. Otherwise, you can have orphaned resources in your VPC that prevent you from being able to delete the VPC.**
This step deletes all resources that were created by terraform.

Go to the `terraform/azure` directory and run following command in terminal:
```
terraform destroy
```

After calculating the diff you will be asked if you want to apply changes. Type `yes` and press `enter`.
