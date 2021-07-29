# Infra helmfile
This directory contains helmfile and helm charts that are used to install infra applications to k8s cluster.

## Components
### Cert-Manager
Cert-Manager is an application for automatic https certificate issuing and renewal.
https://cert-manager.io/docs/

### Let's Encrypt prod clusterissuer
Small staff helm chart for configuring cert-manager to use let's encrypt for issuing certs.

## Installation
Copy `values-example.yaml` to `values.yaml`. Replace values with actual values.

Run following command:
```
helmfile -n <namespace> apply
```
