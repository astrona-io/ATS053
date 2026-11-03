---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Starting Environment

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

The `shuttle` pod in `starfleet` may only call the `probe` Service. It must not reach anything else.
