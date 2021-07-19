# Graph Protocol indexer helmfile
Graph protocol indexer could be installed in two different modes:
* Network mode - node participates in network, processes requests and gets commission
* Standalone mode - private installation that would be used, managed only by owner.

## Network mode
You can deploy graph node in network mode. In this case additional graph indexer components gets deployed, so that the node can join the graph network.

### Instalation
Prepare values in `values` directory first.
```
helmfile -f helmfile-network.yaml -n <namespace> apply
```
**TODO: document full installation, setup and usage** - https://github.com/chainstack/graph-deployment/issues/15

## Standalone mode
You can deploy graph nodes in standalone mode. In this case separate IPFS node gets deployed together with the graph node. It allows you to install subgraphs locally without connecting to the Graph network.
### Instalation
Prepare values in `values` directory first.
In the example bellow external ethereum mainnet endpoint is used, cause the indexing contract for the example subgraph is located in ethereum mainnet.

```
helmfile -f helmfile-standalone.yaml -n <namespace> apply
```

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
kubectl -n <namespace> port-forward svc/ipfs-ipfs 5001:5001
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
