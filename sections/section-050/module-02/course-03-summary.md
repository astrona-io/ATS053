---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Summary

A cluster that runs Cilium has three policy kinds. The Kubernetes NetworkPolicy is namespaced and portable, and it has allow rules only. The CiliumNetworkPolicy and the CiliumClusterwideNetworkPolicy add entities, Layer 7 rules, name-based egress, deny rules and control of default deny, and they work only with Cilium. The clusterwide kind has no namespace and can also select nodes.

All kinds feed the same agent, which combines the allow rules by union and applies deny rules on top. A Cilium policy can therefore extend a NetworkPolicy without any change to it, and a deny rule can restrict the union without editing any allow.

To choose a kind, check whether the requirement needs a Cilium-only feature, then whether it must hold in every namespace, and then whether it must stay portable. A migration adds the new object next to the old one, verifies it, and removes the old one last.

Key facts:

- A deny rule in any kind wins over all allow rules.
- Allow rules of all kinds are combined by union.
- Only the clusterwide kind can select nodes.
- The agent lists the objects that shaped each endpoint.

<!-- astrona:playground:destroy -->
