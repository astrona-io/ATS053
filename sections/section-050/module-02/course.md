---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Cilium Extensions And Choosing Between Policy Kinds

A cluster that runs Cilium has three policy kinds: the Kubernetes NetworkPolicy, the CiliumNetworkPolicy and the CiliumClusterwideNetworkPolicy. They overlap, and each has features the others lack. This module explains what the Cilium kinds add, how to extend an existing NetworkPolicy without editing it, and how to choose a kind for a requirement.

The module uses a private playground with the `probe` Service and the `shuttle` pod in `starfleet` and the `drifter` pod in `outpost`. The playground has no policy at the start.

## Learning Goals

- List the features that the Cilium policy kinds add to the NetworkPolicy API.
- Choose between a namespaced and a clusterwide Cilium policy by scope.
- Extend a NetworkPolicy by adding a Cilium policy, and block a client with a deny rule.
- Choose a policy kind for a stated requirement and plan a migration between kinds.

## Before You Start

You need to read a NetworkPolicy and a CiliumNetworkPolicy, and to know that allows from all kinds are combined by union. You need `kubectl` and the `astrona` command.

The module has two parts. The first part covers the Cilium extensions and the scope of the two Cilium kinds, and applies a Cilium policy next to a NetworkPolicy. The second part covers the choice of kind and the migration. A summary closes the module.

<!-- astrona:playground -->
