# GCP terraform
This terraform project creates kubernetes cluster in GCP from scratch, it's required to deploy The Graph indexer on later steps.

## Install prerequisites
| Tool | Recommended version | Install documentation link |
| ------------ | ------------ | ------------ |
| Terraform | `~> 1.0.2` | https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform |
| Kubectl | Latest | https://kubernetes.io/docs/tasks/tools/#kubectl |
| GCloud | Latest | https://cloud.google.com/sdk/docs/install |

## Apply terraform
### Auth in gcp
Run in terminal:
```
gcloud auth login
```

Browser with Google login page would be opened. Log in to your account.

### Fill variables
Copy example variables file `terraform.example.tfvars` to `terraform.tfvars` in the `terraform/gcp` directory.
Fill `gcp_project` variable. You also can override other variables defined in `variables.tf`

### Run terraform apply
Go to the `terraform/gcp` directory and run following command in terminal:
```
terraform apply
```

After calculating diff you would be asked if you want to apply changes, type yes and press enter.
After command successful finish kubernetes cluster would be created.

### Get kubectl config for created cluster
For zonal cluster run:
```
gcloud container clusters get-credentials <cluster_name> --zone <cluster_zone> --project <gcp_project>
```

For regional cluster run:
```
gcloud container clusters get-credentials <cluster_name> --region <cluster_region> --project <gcp_project>
```

### Test that kubectl config works
```
kubectl get ns,node
```

## Destroy terraform
This step would delete all resources that were created by terraform.

Go to the `terraform/gcp` directory and run following command in terminal:
```
terraform destroy
```

After calculating diff you would be asked if you want to apply changes, type yes and press enter.
After command successful finish all created resources.
