# This repo contains IaaC for deploying The Graph indexer to existing k8s cluster.
Current status of all IaaC components in this repo should be considered as *alpha* for now.
We don't guarantee that charts won't have major breaking changes until the early stage of the development is done.

Also this repo could be split into separate terraform and charts repos in future.

## Helm Charts
Currently 3 helm charts are implemented (see `charts` directory):
* graphprotocol-node - deploys graphprotocol index and query nodes
* graphprotocol-indexer-agent - deploys graphprotocol indexer agent
* graphprotocol-indexer-service - deploys graphprotocol indexer agent

## Helmfile
For now we are using helmfile to deploy charts to test environment.
All values files that used for our testenv (configured to work with The Graph testnet) live in `values` directory.

There's:
* `<name>.yaml` - contains common configuration options
* `<name>.secret.example.yaml` - contain sensitive configuration options. You need to copy example files, remove `.example` from name and fill in the configuration options.

Currently we have 3 external dependencies for our installation:
* Ethereum archive node (rinkeby for testnet)
* The Graph IPFS endpoint (could be found it The Graph Docs)
* Cloud Provider managed ingress controller to make indexer endpoint public (needed to participate in The Graph net).

## Found limitations
* Postgres user should be set to `postgres` if bitnami/postgres chart is used (it's the postgres chart we are using as dependency in helmfile), cause create pg_extension requires super user.
