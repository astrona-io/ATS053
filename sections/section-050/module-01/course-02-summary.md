---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Summary

Kubernetes NetworkPolicy provides a portable namespaced model for supported ingress and egress relationships, while Cilium resources add implementation-specific expressiveness such as application rules and explicit denies.

Portability, scope and enforcement coverage are separate decisions. Extended resources require Cilium support, and standard policy behavior still depends on the network implementation; protect required dependencies and verify effective policy rather than infer safety from resource presence.
