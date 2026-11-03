---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Starting Environment

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

A standard NetworkPolicy already protects the `probe` Service and allows only `shuttle`. The `drifter` pod in `outpost` now also needs access. You must not edit or delete the NetworkPolicy.
