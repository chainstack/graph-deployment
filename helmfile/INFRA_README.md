# Infra helmfile
This directory contains helmfile and helm charts that are used to install infra applications to k8s cluster.

## Components
### Nginx Ingress
[Nginx Ingress](https://www.nginx.com/products/nginx-ingress-controller/) is an [Kubernetes Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) that handles http/https routing and TLS termination.
We are using 3rd party ingress controller instead of clouds' built-in to prevent maintaining different configurations and different TLS certs' issuing mechanisms.

### Postgres operator
[Postgres operator](https://postgres-operator.readthedocs.io/en/latest/) is an [kubernetes operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) for postgres. It installs postgres and manages it's upgrades, failover, etc.

### Cert-Manager
Cert-Manager is an application for automatic https certificate issuing and renewal.
https://cert-manager.io/docs/

### Let's Encrypt prod clusterissuer
Small staff helm chart for configuring cert-manager to use let's encrypt for issuing certs.

### Kubernetes Dashboard
https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
WebUI allows you to see and edit workloads, read pod's logs and etc.

### KubeDashboard Admin ServiceAccount
Creates kubernetes service account with admin rights that would be used to access Kubernetes Dashboard.

### Prometheus stack
This includes Prometheus, Exporters, Grafana and basic kubernetes dashboards

### Graph Grafana dashboards
Includes The Graph specific dashboards for grafana. Also includes configuration of postgres datasource for grafana.

Some of dashboards was inspired or based on https://github.com/StakeSquid/graphprotocol-mainnet-docker/tree/advanced/grafana/provisioning/dashboards

**Postgres datasource**:
Unfortunately postgresql password (used for postgres datasource) is not known before graph installation.
In order to make dashboards that uses postgres data work you should pass postgres password to values after graph installation and reapply infra helmfile.

You can get needed postgres password using following command:
```
kubectl -n <graph-node namespace> get secret node.postgres-postgres.credentials.postgresql.acid.zalan.do -o json | jq -r ".data.password" | base64 -d`
```

You should pass it to `postgresDatasource.password` field in `infra.secret.yaml` and run appli command again.

After that you should restart grafana pod to make changes take effect.

## Installation
Copy `values-example.yaml` to `values.yaml`. Replace values with actual values.

Run following command:
```
helmfile -n <namespace> apply
```

## Usage
### Kubernetes Dashboard
Run the following command to configure a proxy between your local machine and k8s API:
```
kubectl proxy
```

To get admin token issued for KubeDashboard Admin ServiceAccount run following command:
```
NS=<namespace>; kubectl -n $NS get secret $(kubectl -n $NS get sa kube-dashboard-admin -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 -d
```

Open the following link in a browser. Don't forget to replace `<namespace>` with the actual namespace used during the installation.
`http://127.0.0.1:8001/api/v1/namespaces/<namespace>/services/https:kubernetes-dashboard:https/proxy/`.

On login page, select `token` option and past token you got in previous step.

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
