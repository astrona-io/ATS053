---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Starting Environment

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Everything inside the cluster may call the `probe` Service on port 8080, except the `drifter` pod in `outpost`.
