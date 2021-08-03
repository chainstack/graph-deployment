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
WebUI allows you to see and edit workloads, read pod's logs and etc.

### Prometheus stack
This includes Prometheus, Exporters, Grafana and basic kubernetes dashboards

### Graph Grafana dashboards
Includes The Graph specific dashboards for grafana. Also includes configuration of postgres datasource for grafana.

## Installation
Copy `values-example.yaml` to `values.yaml`. Replace values with actual values.

Run following command:
```
helmfile -n <namespace> apply
```

## Usage
### Kubernetes Dashvoard
Run the following command to configure a proxy between your local machine and k8s API:
```
kubectl proxy
```

Open the following link in a browser. Don't forget to replace `<namespace>` with the actual namespace used during the installation. 
`http://127.0.0.1:8001/api/v1/namespaces/<namespace>/services/https:kubernetes-dashboard:https/proxy/`.

On login page, select `kubeconfig` option and upload your kubeconfig file located in `~/.kube/config` by default. Note: typically this directory is hidden.

### Grafana
Run the following command to configure forwarding between grafana k8s service and your local machine:
```
kubectl -n <namespace> port-forward svc/prometheus-stack-grafana 8001:80
```

Open `http://localhost:8001`, you will be redirected to a login screen.
Use the following basic authentication credentials to login:`admin:prom-operator`.
There are two folders with Dashboards:
- Kubernetes - kubernetes cluster monitoring info
- The Graph - graphprotocol installation subgraph status and application specific monitoring info
