# Network
You can deploy graph nodes in network mode. In this case you would participate in graph network. It would deploy additional graph indexer components, that are needed to participate in network.

## Instalation
```
helmfile -f helmfile-network.yaml -n <namespace> apply
```

## Instalation
Prepare values in `values` directory first.

```
helmfile -f helmfile-standalone.yaml -n <namespace> apply
```

# Standalone
You can deploy graph nodes in standalone mode. In this case you wouldn't participate in graph network and would have separate IPFS node. It allows you to install subgraphs locally to your own node, without sharing nodes with Graph network

## Instalation
Prepare values in `values` directory first.
For test subgraph installation bellow I'm using graph-node installation connected to external ethereum mainnet endpoint, cause example subgraph by default indexing contract located in ethereum mainnet.


```
helmfile -f helmfile-standalone.yaml -n <namespace> apply
```


## Deploy subgraph
This instruction is based on https://thegraph.com/docs/developer/quick-start

### Clone example subgraph
I'm using https://github.com/graphprotocol/example-subgraph as an example
```
git clone git@github.com:graphprotocol/example-subgraph.git
cd example-subgraph
```

### Run port-forward to access internal endpoints
During deploy of subgraph you need access to internal ports of installation.
You need to run this command in separate terminals.
After deploy you can kill port-forwarding processed by `Ctrl+C`
```
kubectl -n <namespace> port-forward svc/ipfs-ipfs 5001:5001
kubectl -n <namespace> port-forward svc/graphprotocol-node-index 8020:8020
```

### Deploy example subgraph
You need to install graph-cli first
```
npm install -g @graphprotocol/graph-cli
```

After that you need to execute following commands from the subgraph-example folder
```
npm install
npm run codegen
npm run create-local
npm run deploy-local
```

After successful deployment you can stop port-forwarding.

### Tracking subgraph indexing status
You can track subgraph indexing progress in indexer-node (ingest-node) logs or via metrics endpoint.
I'm using metrics approach in this guide.

Port-forward metrics port (used only for tracking)
```
kubectl -n <namespace> port-forward svc/graphprotocol-node-index 8040:8040
```

You can get information about number of last block handled by subgraph
```
curl localhost:8040/metrics | grep deployment_head
```

Also you can get information about last block on indexed networks:
```
curl localhost:8040/metrics | grep ethereum_chain_head_number
```

Fully synced subgraph should have `deployment_head` number equals to `ethereum_chain_head_number` of indexed chain.

### Requesting data from subgraph
First you need to port-forward graphql ports (http and ws) to your machine in separate terminals
```
kubectl -n <namespace> port-forward svc/graphprotocol-node-query 8000:8000
kubectl -n <namespace> port-forward svc/graphprotocol-node-query 8001:8001
```

Now you can re
