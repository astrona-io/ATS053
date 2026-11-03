---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Effective Policy, Dependencies And Evidence

A policy that looks correct in YAML can still break an application, and a request that fails does not tell you which policy caused it. This module teaches two things: how to include the dependencies that an application needs, and how to ask the Cilium agent what policy it really enforces.

The module uses the same playground layout as before. The `probe` Service and the `shuttle` pod are in `starfleet`. The `drifter` pod is in `outpost`. The Cilium agent runs as the DaemonSet `cilium` in `kube-system`, and you reach its command line tool, `cilium-dbg`, with `kubectl exec`.

## Learning Goals

- Explain why an egress policy must allow DNS (Domain Name System) before a named destination works.
- Write an egress rule for the cluster DNS service and a rule for one destination port.
- Describe what a `toFQDNs` rule needs before it allows any traffic.
- Read the realized policy of one endpoint with `cilium-dbg`, and tell a policy drop from an application failure.

## Before You Start

You need to be able to read the subject, direction, peers and ports of a policy. You need `kubectl` and the `astrona` command. The playground has no policy at the start.

The module has two parts. The first part adds egress rules with their DNS dependency and applies them. The second part reads the effective policy from the agent and uses drop events as evidence. A summary closes the module.

<!-- astrona:playground -->
