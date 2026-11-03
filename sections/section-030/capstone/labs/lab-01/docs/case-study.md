---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Starting Environment

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

The `probe` pods must not open connections to anything except DNS. Clients must still be able to call the `probe` Service.
