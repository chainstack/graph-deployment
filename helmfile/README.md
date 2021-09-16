# The Graph protocol indexer Helmfile

The Graph protocol indexer can be installed in two different modes:

* Network mode — the node participates in the network, processes external requests and gets commission.
* Standalone mode — the node doesn't join in The Graph network, processes only your own subgraph and requests.

## Prerequisites

You will need to install the following tools before proceeding:

1. [kubectl](https://kubernetes.io/docs/tasks/tools/)
1. [helmfile](https://github.com/roboll/helmfile)
1. [helm-diff](https://github.com/databus23/helm-diff)

Make sure to set up the kubectl config to point to the right Kubernetes instance. See `terraform/<respective cloud provider>` for instructions.

## Network mode

You can deploy The Graph node in the network mode. In this case, the additional graph indexer components are deployed so that the node can join The Graph network.

For more information about indexing, see [The Graph Indexer](https://thegraph.com/docs/indexing).

### Installation

Prepare the values in the `values` directory first. The `<namespace>` value can be any string of your choice.

```
helmfile -f helmfile.yaml -e network -n <namespace> apply
```

### Install graph-cli and indexer-cli

Install graph-cli and indexer-cli by following [Getting started: from NPM packages](https://thegraph.com/docs/indexing#from-npm-packages).

### Check the indexer status

```
kubectl -n <namespace> port-forward svc/graphprotocol-indexer-agent 18000:8000
graph indexer status
```

### Interacting with indexer-agent

First, you must run the port-forward command:

```
kubectl -n <namespace> port-forward svc/graphprotocol-indexer-agent 18000:8000
```

Then, connect with graph-cli and check the status:

```
graph indexer connect http://localhost:18000
graph indexer status
```

For other useful commands for subgraphs and the cost model configuration, see [Indexer CLI: Usage](https://thegraph.com/docs/indexing#usage-1).

## Standalone mode

You can deploy The Graph nodes in the standalone mode. In this case, a separate IPFS node is deployed together with The Graph node. It allows you to install subgraphs locally without connecting to The Graph network.

### Installation

Prepare the values in the `values` directory first. The `<namespace>` value can be any string of your choice.

In the example below, an external Ethereum mainnet endpoint is used to index the contract deplopyed to the Ethereum mainnet.

```
helmfile -f helmfile.yaml -e standalone -n <namespace> apply
```

### Deploy the subgraph

This instruction is based on [The Graph: Quickstart](https://thegraph.com/docs/developer/quick-start).

#### Clone the example subgraph

Clone [the example subgraph repository](https://github.com/graphprotocol/example-subgraph).

```
git clone git@github.com:graphprotocol/example-subgraph.git
cd example-subgraph
```

#### Run port-forward to access internal endpoints

During the deployment of a subgraph, you need access to the internal ports of the installation.

You must run the following commands to access the deployed components locally.

When the subgraph is deployed, you can kill the port-forwarding processes by `Ctrl+C`.

```
kubectl -n <namespace> port-forward svc/ipfs-ipfs 5001:5001 & \
kubectl -n <namespace> port-forward svc/graphprotocol-node-index 8020:8020
```

#### Deploy the example subgraph

Install graph-cli first.

```
npm install -g @graphprotocol/graph-cli
```

Then run the following commands from the `subgraph-example` directory:

```
npm install
npm run codegen
npm run create-local
npm run deploy-local
```

After the successful deployment, stop port-forwarding.

### Tracking the subgraph indexing status

Subgraph indexing progress can be observed in the indexer-node (ingest-node) logs or via a metrics endpoint.

This guide uses the metrics endpoint to watch the indexing progress.

Port-forward metrics port (used only for tracking the indexing):

```
kubectl -n <namespace> port-forward svc/graphprotocol-node-index 8040:8040
```

You can get the information about the number of the latest block indexed by a subgraph by running the following command:

```
curl localhost:8040/metrics | grep deployment_head
```

Also you can get the information about the latest block on the indexed networks:

```
curl localhost:8040/metrics | grep ethereum_chain_head_number
```

A fully synced subgraph has `deployment_head` equal to `ethereum_chain_head_number`.

### Requesting data from a subgraph

Port-forward the GraphQL ports (HTTP and WS) to your local machine:

```
kubectl -n <namespace> port-forward svc/graphprotocol-node-query 8000:8000
```

**Note:** the GraphQL WebSocket is exposed on a separate 8001 port.

Now you can access the GraphQL request UI in the browser via http://localhost:8000/subgraphs/name/example/graphql

Run a test query:

```
{
  gravatars {
    id
    owner
    displayName
    imageUrl
  }
}
```

If everything is ok, you will get a response containing indexed information.

### Exposing The Graph protocol node to the Internet

The Graph protocol node does not expose itself to the Internet by default.

One method of exposure is to utilize the LoadBalancer service.

Do note that the downside of this approach is that it will expose the installation to the web.

#### Ingress resource

You can use the built-in ingress support to expose The Graph node to the Internet.

You can configure that by using the `ingress` and `ingressWebsocket` structure in `values/graphprotocol-node-query.yaml` .

This will expose the ports used by The Graph protocol node to the web.

Do note you will need to run the below commands for the changes to be reflected.

```
helmfile -f helmfile-standalone.yaml -n <namespace> apply

or

helmfile -f helmfile-network.yaml -n <namespace> apply
```

Once the changes are applied, get the external IP for the ingress query.

```
$ kubectl get ing -n <namespace>
```

#### Loadbalancer service

In `values/graphprotocol-node-query.yaml`, add the following line at the bottom:

```
service:
  type: LoadBalancer

```

This will expose the ports used by The Graph protocol node to the web.

Do note you will need to run the below commands for the changes to be reflected.

```
helmfile -f helmfile.yaml -e standalone -n <namespace> apply

or

helmfile -f helmfile.yaml -e network -n <namespace> apply
```

Once the changes are applied, get the external IP for the query service.

```
$ kubectl get svc -n <namespace>
NAME                           TYPE           CLUSTER-IP      EXTERNAL-IP                               PORT(S)                                                       AGE
graphprotocol-node-index       ClusterIP      some ip         <none>                                    8040/TCP,8020/TCP,8000/TCP,8001/TCP,8030/TCP                  64m
graphprotocol-node-query       LoadBalancer   some ip         *Service external address (CNAME or IP)*  8040:31563/TCP,8020:32350/TCP,8000:30795/TCP,8001:31281/TCP   64m
ipfs-ipfs                      ClusterIP      some ip         <none>                                    5001/TCP,8080/TCP                                             65m
postgres-postgresql            ClusterIP      some ip         <none>                                    5432/TCP                                                      65m
postgres-postgresql-headless   ClusterIP      None            <none>                                    5432/TCP                                                      65m
```

## Securely store values in repository

You can install [helm-secret](https://github.com/jkroepke/helm-secrets) if you want to store your Helm values containing secrets inside git repository in encrypted form.

The helm-secret README covers how to use it the proper way.

## Potential installation bugs and troubleshooting

### Monitoring infrastructure not present

```
Error: Failed to render chart: exit status 1: Error: unable to build kubernetes objects from release manifest: unable to recognize "": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

This means you do not have the monitoring infrastructure components configured.

See `INFRA_README.md` for the setup instructions.

If monitoring is not a priority or desired feature, you can do away with it. Under the `values` directory, set `monitoring` to `false` in the affected files.

```
monitoring:
  enabled: false
```

### Timeouts and pods experiencing `CrashLoopBackOff`

If you get timeouts or if some pods get the `CrashLoopBackOff` errors when you run `kubectl get pods -n <namespace>`,
this means there are configuration errors.

Possible causes:

* Missing the `config.chains` value in the `values/graphprotocol-node*` file.
