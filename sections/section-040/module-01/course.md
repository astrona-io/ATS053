---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Selectors, Peers And Ports

A Cilium policy is a structured document, and every field has a fixed meaning. A reader who knows the structure can build a policy from a requirement and can find the mistake in a policy that does not work. This module covers the Layer 3 and Layer 4 parts of that structure: the subject, the peer selectors, and the ports.

The module uses a private playground with the `probe` Service and the `shuttle` pod in `starfleet` and the `drifter` pod in `outpost`. The playground has no policy at the start.

## Learning Goals

- Name the main fields of a CiliumNetworkPolicy and say what each one selects.
- Write a selector with `matchLabels` and with `matchExpressions`.
- Choose between endpoint, entity and CIDR peers for a given destination.
- Write port rules with a protocol and with a port range.
- Predict the result when fields are combined in one rule and when rules are combined in one list.

## Before You Start

You need to know what a security identity is and how a policy turns on enforcement per direction. You need `kubectl` and the `astrona` command.

The module has three parts. The first part covers the anatomy of a policy and the peer selectors. The second part covers ports and how rules combine. The third part builds and tests a port-scoped policy in the playground. A summary closes the module.

<!-- astrona:playground -->
