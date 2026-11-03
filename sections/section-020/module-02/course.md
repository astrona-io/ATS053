---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Reserved Identities, Entities And CIDR

Not every peer is a pod with labels. Cilium also protects traffic from the node itself, from the Kubernetes API server, from addresses outside the cluster and from pods in other namespaces. This module explains how a policy names each kind of peer, and which policy kind has which scope.

The module uses a private playground with the same layout as the other playgrounds of this course. The `probe` Service and the `shuttle` pod are in `starfleet`, and the `drifter` pod is in `outpost`.

## Learning Goals

- Select peers across namespaces with the namespace label in a CiliumNetworkPolicy.
- Choose between a CiliumNetworkPolicy and a CiliumClusterwideNetworkPolicy by scope.
- Name the reserved identities and the entities that select them.
- Explain how a CIDR rule works and which address ranges it fits.

## Before You Start

You need to know that Cilium derives an identity from labels, and that a selector matches a subset of an identity label set. You need `kubectl` and the `astrona` command. The playground has no policy at the start.

The module has two parts. The first part selects peers by label and namespace and compares the two policy kinds. The second part covers reserved identities, entities and CIDR rules. A summary closes the module.

<!-- astrona:playground -->
