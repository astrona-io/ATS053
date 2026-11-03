---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Policy Enforcement Modes

This section teaches when Cilium enforces policy. The enforcement mode decides which endpoints are in default deny, and audit mode lets you see what a policy would drop before it drops anything.

The first module covers the default, always and never modes and how to read and change the mode. The second module covers audit mode, the `enableDefaultDeny` field and a safe rollout with a way back. A capstone lab and a quiz close the section.

## Learning Outcomes

- Compare the default, always and never modes and their effect on unselected endpoints.
- Explain that enforcement is switched on separately for ingress and egress.
- Read and change the mode in Helm values and in the agent configuration.
- Use audit mode and `AUDIT` verdicts to find missing rules before enforcement.
- Use `enableDefaultDeny` to add rules without turning on default deny, and plan a rollback.
