---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Audit Mode And Safe Rollout

A new policy can break an application that nobody knew depended on an open flow. Cilium offers two tools to find that out before traffic is dropped: audit mode, which reports the drops a policy would cause without dropping, and the `enableDefaultDeny` field, which lets a policy add rules without turning on default deny.

This module explains both tools, shows how Hubble reports the result, and describes a rollout order that avoids outages. The playground has the `probe` Service and the `shuttle` pod in `starfleet`, the `drifter` pod in `outpost`, and no policy at the start.

## Learning Goals

- Explain what audit mode does to a flow that a policy would drop.
- Enable audit mode on one endpoint and read the `AUDIT` verdict.
- Use `enableDefaultDeny` to add allow rules without enforcing default deny.
- Describe a rollout order that moves from observation to enforcement.

## Before You Start

You need to know the enforcement flags per endpoint and direction, and the three enforcement modes. You need `kubectl` and the `astrona` command.

The module has two parts. The first part explains audit mode and how to read its results. The second part covers `enableDefaultDeny` and a complete rollout. A summary closes the module.

<!-- astrona:playground -->
