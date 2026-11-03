---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Starting Environment

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Only pods that carry the label `team=bridge` may call the `probe` Service. The `shuttle` pod must get that label.
