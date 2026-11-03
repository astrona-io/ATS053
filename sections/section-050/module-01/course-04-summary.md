---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Summary

A Kubernetes NetworkPolicy selects subject pods in its namespace, lists the directions in `policyTypes`, and allows peers and ports. A peer is a pod selector, a namespace selector or an address block. Selectors in one peer item are joined with AND, and separate items are joined with OR.

The resource has no deny rule and no order. A pod that no policy selects accepts all traffic, and a selected pod accepts the union of the allow rules for the selected direction. An empty ingress list with an empty pod selector is the standard default deny for a namespace.

Cilium enforces the resource. Each agent watches NetworkPolicy objects, translates them to its internal rules with identities, and loads them into the kernel. The enforcement flags and policy maps are the same as for Cilium's own policy kinds, and the allowed set is the union of all kinds.

The standard API cannot express Layer 7 rules, names, entities, deny rules, cluster scope or audit. A Cilium policy next to the NetworkPolicy fills these gaps without any change to the standard object.

Key facts:

- A NetworkPolicy only adds allows.
- Numeric ports have no quotes in a NetworkPolicy.
- Both policy kinds on one pod are combined by union.
- An agent reports only the endpoints of its own node.

<!-- astrona:playground:destroy -->
