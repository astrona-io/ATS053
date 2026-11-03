---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Security Identities And Labels

Cilium does not write security rules for IP addresses. It gives every group of identical pods a numeric security identity, and it writes rules for identities. This module explains why Cilium works this way, how labels become an identity, and how to read the identity of a running endpoint.

The module uses a private playground: a kind cluster with Cilium as its network plugin. The `probe` Service and the `shuttle` pod are in the `starfleet` namespace, and the `drifter` pod is in the `outpost` namespace.

## Learning Goals

- Explain why address-based rules do not scale in a cluster where pods change often.
- Describe how Cilium derives a security identity from the labels of a pod.
- Name labels that are excluded from the identity and explain why.
- Read the identity of an endpoint, and predict what changes when a label changes.

## Before You Start

You need basic Kubernetes knowledge: pods, labels, namespaces and Services. You need `kubectl` and the `astrona` command. The playground starts from the marker at the end of this page, and it has no network policy at the start.

The module has three parts. The first part explains why identities replace addresses. The second part shows how labels become an identity and which labels count. The third part reads identities in the playground. A summary closes the module.

<!-- astrona:playground -->
