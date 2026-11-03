---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Summary

A policy selects peers through identities. A pod identity comes from its labels and its namespace, so a selector needs the namespace label to select pods in another namespace. A namespaced CiliumNetworkPolicy defaults to its own namespace, and a CiliumClusterwideNetworkPolicy matches pods in every namespace.

Peers without labels use reserved identities. Entities such as `host`, `world`, `cluster` and `kube-apiserver` name groups of reserved identities. CIDR rules select address ranges for labelless destinations, and they do not select cluster pods.

The agent keeps the identity list and the ipcache, which maps addresses to identities. Reading both shows which identity a request has and which rules can match it.

Key facts:

- A namespaced policy selects subjects only in its own namespace.
- The entity `world` means outside the cluster, and `cluster` means inside it.
- A CIDR rule fits external addresses and not pods.
- Whoever can set labels or the namespace of a pod chooses its identity.

<!-- astrona:playground:destroy -->
