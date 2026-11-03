---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Reading A CiliumNetworkPolicy

A CiliumNetworkPolicy is a Kubernetes custom resource. It tells the Cilium agent on each node which network traffic to allow or deny for a selected group of pods. This module teaches how to read one policy and state, in plain words, what it permits and what it blocks.

The module works in a private playground. The playground is a kind cluster (Kubernetes running in containers) with Cilium as its network plugin. It has a Service named `probe` in the `starfleet` namespace, a client pod named `shuttle` in `starfleet`, and a client pod named `drifter` in the `outpost` namespace.

## Learning Goals

- Find the subject of a policy and the direction of each rule.
- Read peer, port and application constraints inside one rule as a single combined condition.
- Explain why several allow rules add up, and why a matching deny rule wins.
- Say which traffic is still allowed after a policy selects an endpoint, and why.

## Before You Start

You need basic Kubernetes knowledge: pods, labels, namespaces and Services. You need `kubectl` and the `astrona` command. The playground starts from the marker at the end of this page. It has no policy at the start, so every request between the pods works.

The parts of the module read in this order. The first part names the subject and the direction. The second part reads peers, ports and combinations. The third part applies a policy and tests it with real requests. A summary closes the module.

<!-- astrona:playground -->
