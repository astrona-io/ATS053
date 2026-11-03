---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Kubernetes NetworkPolicy Semantics On Cilium

Kubernetes defines its own policy resource, the NetworkPolicy. It is portable between network plugins, and Cilium enforces it. This module explains what a NetworkPolicy says, how Cilium turns it into the same enforcement that it uses for its own policies, and what the standard API cannot express.

The module uses a private playground with the `probe` Service and the `shuttle` pod in `starfleet` and the `drifter` pod in `outpost`. The playground has no policy at the start.

## Learning Goals

- Read a NetworkPolicy: pod selector, policy types, peers and ports.
- Explain why NetworkPolicy rules only add allows and have no deny.
- Describe how Cilium enforces a NetworkPolicy with the same flags and identities as its own policies.
- Name features that the NetworkPolicy API cannot express.

## Before You Start

You need to know the enforcement flags per endpoint and direction, and the idea of a security identity. You need `kubectl` and the `astrona` command.

The module has three parts. The first part covers the NetworkPolicy API and its rules. The second part explains how Cilium implements it and where the API stops. The third part applies a NetworkPolicy in the playground and checks it. A summary closes the module.

<!-- astrona:playground -->
