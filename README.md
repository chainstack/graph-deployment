# The Graph — IaC tooling

This repository contains the infrastructure as code (IaC) definition to deploy The Graph stack to public clouds using the tools:

* Terraform
* Kubernetes
* Helm
* Helmfile

Currently supported clouds:

* Amazon Web Services (AWS)
* Google Cloud Platform (GCP)
* Microsoft Azure

Each part of IaC in this repository can be used completely separately.

## IaC parts

* `terraform/` — contains the Terraform definitions separate for each supported cloud. Each of the definitions deploys the network and the Kubernetes cluster to the selected cloud.
* `charts/` — contains the Helm charts to deploy The Graph stack.
* `helmfile/` - contains the definition of Helm releases that would be deployed to the Kubernetes cluster.

## Quickstart

1. Set up your Kubernetes cluster.

   See `terraform/` for specific cloud provider integration.

   See the relevant `README.md` in `terraform/<provider_name>` for further instructions on how to set up the Kubernetes cluster.

   The Terraform setup takes approximately 10 minutes.

1. Install the infrastructure components by following the instructions in `helmfile/INFRA_README.md`
1. Install The Graph stack by following the instructions in `helmfile/README.md`

## Contributions

We welcome community contributions.
