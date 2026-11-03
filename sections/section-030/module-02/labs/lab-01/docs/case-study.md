---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Starting Environment

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

The team wants to roll out an allow rule for the `probe` Service in steps. The first step must not block any client.
