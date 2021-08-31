# TheGraph - IaaC tooling
This repo contains infrastructure as a code definition deploying The Graph stack to public clouds using Terraform, Kubernetes, Helm and Helmfile.
Currently supported clouds: AWS, GCP, Azure.

Each part of IaaC in this repo could be used completely separately.

## IaaC parts:
* `terraform/` - contains terraform definitions separate for each supported Cloud. Deploys network and k8s cluster to selected cloud.
* `charts/` - contains helm charts for deploying The Graph stack.
* `helmfile/` - contains definition of helm releases that would be deployed to k8s cluster.

## Quickstart
1. Set up your Kubernetes cluster. See the `terraform` for specific cloud provider integration. AWS, Azure, and GCP are supported. See the relevant `README.md` in `terraform/<provider name` for further instructions on how to set up the Kubernetes cluster. The terraform setup will take approximately 10 minutes.
2. Install infra components following instructions in `helmfile/INFRA_README.md`
3. Install The Graph stack following instructions in `helmfile/README.md`

## Contributions
We are welcome to community contributions.
