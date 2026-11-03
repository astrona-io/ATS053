---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Starting Environment

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

A standard NetworkPolicy already lets `shuttle` and every pod in `outpost` call the `probe` Service. The `intruder` pod in `outpost` must now be blocked. The owner of the NetworkPolicy does not allow edits.
