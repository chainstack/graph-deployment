# Infra helmfile
This directory contains helmfile and helm charts that are used to install infra applications to k8s cluster.

## Components
### Cert-Manager
Cert-Manager is an application for automatic https certificate issuing and renewal.
https://cert-manager.io/docs/

### Let's Encrypt prod clusterissuer
Small staff helm chart for configuring cert-manager to use let's encrypt for issuing certs.

### Kubernetes Dashboard
https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
This dashboard allows is WebUI allows you to see and edit workloads, read pod logs and etc.

## Installation
Copy `values-example.yaml` to `values.yaml`. Replace values with actual values.

Run following command:
```
helmfile -n <namespace> apply
```

## Usage
### Kubernetes Dashvoard
Run following command it would return address (for me it's I'll use it in next steps):
```
kubectl proxy
```

Replace in following url `<namespace>` with actual namespace used during installation and open it in browser `http://127.0.0.1:8001/api/v1/namespaces/<namespace>/services/https:kubernetes-dashboard:https/proxy/`.

On login page select `kubeconfig` option. Now you need to upload your kubeconfig file, that is located by default in `~/.kube/config`. Note: typically this directory is hidden.
