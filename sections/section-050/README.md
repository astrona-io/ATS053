---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Kubernetes Network Policies versus Cilium Network Policies

This section teaches how the standard Kubernetes NetworkPolicy relates to the Cilium policy kinds. The standard API is portable and has only allow rules. Cilium adds Layer 7 rules, deny rules, entities, FQDN rules and cluster scope.

The first module covers the NetworkPolicy API and how Cilium enforces it. The second module covers the Cilium extensions, how the kinds combine, how to choose a kind and how to migrate. A capstone lab and a quiz close the section, and the final domain quiz follows the last section.

## Learning Outcomes

- Read a NetworkPolicy, including how selectors in one peer item and in separate items differ.
- Explain how Cilium translates and enforces a NetworkPolicy.
- Name the features that only the Cilium kinds offer.
- Predict the result when several policy kinds select the same pod.
- Choose a policy kind for a requirement and migrate between kinds without a gap.
