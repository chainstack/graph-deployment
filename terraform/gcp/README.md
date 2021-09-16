# GCP Terraform

This Terraform project creates a Kubernetes cluster in GCP from scratch. This is required to deploy The Graph indexer at later steps.

## Install prerequisites

| Tool | Recommended version | Install documentation link |
| ------------ | ------------ | ------------ |
| Terraform | `~> 1.0.2` | [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform) |
| Kubectl | Latest | [Install Tools: kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) |
| GCloud | Latest | [Install Cloud SDK](https://cloud.google.com/sdk/docs/install) |

## Apply Terraform

### Auth in GCP

Run in terminal:

```
gcloud auth login
```

This will open the Google login page in your browser. Log in to your account.

### Fill variables

Copy the sample variables file `terraform.example.tfvars` to `terraform.tfvars` in the `terraform/gcp` directory.

Most variables are optional and Terraform will prompt you for variables if you have not filled required ones.

Fill the `gcp_project` variable. You can also override other variables defined in `variables.tf`.

### Run `terraform apply`

Go to the `terraform/gcp` directory and run the following command in terminal:

```
# you will need to run terraform init if terraform has yet to be initialiized
# a .terraform.lock.hcl file will be present if terraform is initialized
terraform init

terraform apply
```

After calculating the diff, you will be asked if you want to apply the changes. Type `yes` and press **Enter**.

After the command succeeds, the Kubernetes cluster will be created.

### Get kubectl config for the created cluster

For the zonal cluster, run:

```
gcloud container clusters get-credentials <cluster_name> --zone <cluster_zone> --project <gcp_project>
```

For the regional cluster, run:

```
gcloud container clusters get-credentials <cluster_name> --region <cluster_region> --project <gcp_project>
```

### Test that kubectl config works

```
kubectl get ns,node
```

## Destroy Terraform

This step deletes all resources that were created by Terraform.

Go to the `terraform/gcp` directory and run the following command in terminal:

```
terraform destroy
```

After calculating the diff, you will be asked if you want to apply the changes. Type `yes` and press **Enter**.
