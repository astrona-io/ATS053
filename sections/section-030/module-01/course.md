---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Default, Always And Never Enforcement

Cilium decides for every endpoint, and for each direction, whether policy applies at all. An endpoint that no policy selects accepts all traffic. An endpoint that a policy selects accepts only what the policies allow. A cluster-wide setting, the policy enforcement mode, changes that rule for all endpoints.

This module explains the three modes, shows what the default mode does per direction, and uses the agent to read the enforcement state of an endpoint. The playground has the `probe` Service and the `shuttle` pod in `starfleet`, the `drifter` pod in `outpost`, and no policy at the start.

## Learning Goals

- Name the three enforcement modes and state what each one does to an endpoint with no policy.
- Explain why the first policy that selects an endpoint turns on default deny for one direction only.
- Read the ingress and egress enforcement state of an endpoint with the agent.
- Predict which traffic an `always` mode cluster drops that a `default` mode cluster allows.

## Before You Start

You need to read a CiliumNetworkPolicy: subject, direction, peers and ports. You need `kubectl` and the `astrona` command.

The module has three parts. The first part explains the modes and the per-direction rule. The second part shows how to read and change the mode and what `always` does to cluster services. The third part applies a policy in the playground and checks the enforcement state. A summary closes the module.

<!-- astrona:playground -->
