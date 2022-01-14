# Infra Helmfile

This directory contains the Helmfile and the Helm charts to install infra applications to the Kubernetes cluster.

## Components

### Nginx ingress

[Nginx Ingress](https://www.nginx.com/products/nginx-ingress-controller/) is a [Kubernetes ingress controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) that handles the HTTP/HTTPS routing and TLS termination.

We are using a third-party ingress controller instead of clouds' built-in ones to prevent maintaining different configurations and different TLS certs' issuing mechanisms.

### Postgres operator

[Postgres operator](https://postgres-operator.readthedocs.io/en/latest/) is a [Kubernetes operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) for Postgres. It installs Postgres and manages its upgrades, failover, etc.

### cert-manager

cert-manager is an application for automatic HTTPS certificate issuing and renewal. See the [cert-manager documentation](https://cert-manager.io/docs/).

### Let's Encrypt prod ClusterIssuer

A Helm chart for configuring cert-manager to use [Let's Encrypt](https://letsencrypt.org/) for issuing certs.

### Kubernetes Dashboard

The [Web UI](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) that allows you to see and edit workloads, read pod logs, etc.

### KubeDashboard Admin ServiceAccount

Creates a Kubernetes service account with admin rights to access Kubernetes Dashboard.

### Prometheus stack

This includes Prometheus, Exporters, Grafana and basic Kubernetes dashboards.

### Graph Grafana dashboards

Includes The Graph specific dashboards for Grafana. Also includes configuration of the Postgres datasource for Grafana.

Some of the dashboards were inspired or based on [StakeSquid dashboard](https://github.com/StakeSquid/graphprotocol-mainnet-docker/tree/advanced/grafana/provisioning/dashboards).

**Postgres datasource**

Unfortunately, the PostgreSQL password (used for the Postgres datasource) is not known before The Graph installation.

To make the dashboards that use Postgres data work, you have to pass the Postgres password to values after The Graph installation and reapply the infra Helmfile.

You can get the Postgres password using the following command:

```
kubectl -n <graph-node namespace> get secret node.postgres-postgres.credentials.postgresql.acid.zalan.do -o json | jq -r ".data.password" | base64 -d`
```

You must pass it to the `postgresDatasource.password` field in `infra.secret.yaml` and run the `apply` command again.

After that, restart the Grafana pod to make the changes take effect.

## Installation

Copy `values/infra.example.yaml` to `values/infra.yaml` and change the values if needed. Replace the prefilled values with the actual ones.

Run following command:

```
helmfile -f helmfile-infra.yaml -n <namespace> apply
```

## Usage

### Kubernetes Dashboard

Run the following command to configure a proxy between your local machine and the Kubernetes API:

```
kubectl proxy
```

To get the admin token issued for KubeDashboard Admin ServiceAccount, run following command:

```
NS=<namespace>; kubectl -n $NS get secret $(kubectl -n $NS get sa kube-dashboard-admin -o jsonpath='{.secrets[0].name}') -o jsonpath='{.data.token}' | base64 -d
```

Open the following link in a browser. Don't forget to replace `<namespace>` with the actual namespace used during the installation.

`http://127.0.0.1:8001/api/v1/namespaces/<namespace>/services/https:kubernetes-dashboard:https/proxy/`.

On the login page, select the `token` option and pass the token you received at the previous step.

### Grafana

Run the following command to configure forwarding between the Grafana Kubernetes service and your local machine:

```
kubectl -n <namespace> port-forward svc/prometheus-stack-grafana 8001:80
```

Open `http://localhost:8001`, you will be redirected to a login screen.

Use the following basic authentication credentials to login:`admin:prom-operator`.

There are two folders with dashboards:

- Kubernetes - Kubernetes cluster monitoring information.
- The Graph - The Graph protocol installation subgraph status and application specific monitoring information.
