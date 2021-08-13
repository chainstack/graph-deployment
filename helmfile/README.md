# Graph Protocol indexer helmfile
Graph protocol indexer could be installed in two different modes:
* Network mode - node participates in network, processes external requests and gets commission.
* Standalone mode - node doesn't join in the graph network, processes only your own subgraph and requests.

## Prerequisites
You will need to install the following tools before proceeding
1. [kubectl](https://kubernetes.io/docs/tasks/tools/) 
2. [helmfile](https://github.com/roboll/helmfile)
3. [helm-diff](https://github.com/databus23/helm-diff)

## Network mode
You can deploy graph node in network mode. In this case additional graph indexer components gets deployed, so that the node can join the graph network.

### Installation
Prepare values in `values` directory first. `<namespace>` can be any string of your choice.
```
helmfile -f helmfile-network.yaml -n <namespace> apply
```

**TODO: document full installation, setup and usage** - https://github.com/chainstack/graph-deployment/issues/15

## Standalone mode
You can deploy graph nodes in standalone mode. In this case separate IPFS node gets deployed together with the graph node. It allows you to install subgraphs locally without connecting to the Graph network.

### Installation
Prepare values in `values` directory first. `<namespace>` can be any string of your choice.

In the example bellow external ethereum mainnet endpoint is used, cause the indexing contract for the example subgraph is located in ethereum mainnet.

```
helmfile -f helmfile-standalone.yaml -n <namespace> apply
```

## Potential Installation Bugs and Troubleshooting

### Monitoring Infrastructure Not Present
```
Error: Failed to render chart: exit status 1: Error: unable to build kubernetes objects from release manifest: unable to recognize "": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

If you experienced the error above, it means you do not have the monitoring infrastructure components configured.
See `INFRA_README.md` for setup instructions.
If monitoring is not a priority or desired feature you can do away with it. Under the `values` folder, set monitoring to false in affected files.
```
monitoring:
  enabled: false
```

### Timeouts and Pods experiencing `CrashLoopBackOff`
Should timeouts be experienced or if you noticed that some pods are experiencing `CrashLoopBackOff` errors when you run `kubectl get pods -n <namespace>`,
it suggests that there are configuration errors.

Some possible errors could be
1. Blank fields in files found in `value`, if the field is not needed or optional. Remember to comment them out.


### Deploy subgraph
This instruction is based on https://thegraph.com/docs/developer/quick-start

#### Clone example subgraph
https://github.com/graphprotocol/example-subgraph is used as an example of a subgraph.
```
git clone git@github.com:graphprotocol/example-subgraph.git
cd example-subgraph
```

#### Run port-forward to access internal endpoints
During the deployment of a subgraph you need an access to the internal ports of the installation.
The following commands should be run to access the deployed components locally.
When subgraph is deployed, you can kill the port-forwarding processes by `Ctrl+C`
```
kubectl -n <namespace> port-forward svc/ipfs-ipfs 5001:5001 & \
kubectl -n <namespace> port-forward svc/graphprotocol-node-index 8020:8020
```

#### Deploy example subgraph
Install graph-cli first
```
npm install -g @graphprotocol/graph-cli
```

After that execute following commands from the subgraph-example folder
```
npm install
npm run codegen
npm run create-local
npm run deploy-local
```

After the successful deployment stop port-forwarding.

### Tracking subgraph indexing status
Subgraph indexing progress can be observed in the indexer-node (ingest-node) logs or via metrics endpoint.
This guide uses metrics endpoint to watch the indexing progress.

Port-forward metrics port (used only for tracking the indexing)
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

Fully synced subgraph has `deployment_head` equals to `ethereum_chain_head_number`.

### Requesting data from subgraph
Port-forward the graphql ports (http and ws) to your local machine:
```
kubectl -n <namespace> port-forward svc/graphprotocol-node-query 8000:8000
```

*Note: graphql websocket is exposed on separate 8001 port*

Now you can access graphql request UI in browser via http://localhost:8000/subgraphs/name/example/graphql

Try to perform the test query:
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

If everything is ok you will get a response containing indexed info.

### Exposing Graph Protocol Node to the Internet
The graph protocol node does not expose itself to the internet by default.
One method of exposure is to utilize the LoadBalancer service. 
Do note that the downside of this approach is that it would expose the installation to the web.

In `values/graphprotocol-node-query.yaml` add the following line at the bottom
```
service:
  type: LoadBalancer

```

This would expose ports used by the graph protocol node to the web. 
Do note you'll need to run the below commands for changes to be reflected.
```
helmfile -f helmfile-standalone.yaml -n <namespace> apply

or

helmfile -f helmfile-network.yaml -n <namespace> apply
```

Once the changed have been applied get the external ip for the the query service.
```
$ kubectl get svc -n graph
NAME                           TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)                                                       AGE
graphprotocol-node-index       ClusterIP      some ip         <none>            8040/TCP,8020/TCP,8000/TCP,8001/TCP,8030/TCP                  64m
graphprotocol-node-query       LoadBalancer   some ip         *CNAME you want*  8040:31563/TCP,8020:32350/TCP,8000:30795/TCP,8001:31281/TCP   64m
ipfs-ipfs                      ClusterIP      some ip         <none>            5001/TCP,8080/TCP                                             65m
postgres-postgresql            ClusterIP      some ip         <none>            5432/TCP                                                      65m
postgres-postgresql-headless   ClusterIP      None            <none>            5432/TCP                                                      65m
```
