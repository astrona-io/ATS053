---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Understand Cilium's Identity-based Network Security Model

This section teaches how Cilium decides which traffic belongs to which workload. Cilium turns the labels of a pod into a numeric security identity, and policy rules name identities instead of IP addresses.

The first module covers identities, the labels that form them and how a label change moves a pod to another identity. The second module covers selecting peers across namespaces, reserved identities, entities and CIDR rules. A capstone lab and a quiz close the section.

## Learning Outcomes

- Explain why identities keep policy stable while pod addresses change.
- State which labels and which namespace form an identity, and which labels Cilium ignores.
- Read an endpoint identity from the agent and the Kubernetes API.
- Select peers across namespaces with the namespace label.
- Choose between reserved identities, entities and CIDR rules, and between namespaced and clusterwide policies.
