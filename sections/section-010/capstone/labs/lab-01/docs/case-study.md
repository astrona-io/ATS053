---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Starting Environment

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

The `probe` Service must accept requests only from `shuttle`. The `shuttle` pod may only call the `probe` Service and use DNS.
