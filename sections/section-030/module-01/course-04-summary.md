---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Summary

Cilium keeps two enforcement flags for every endpoint, one for ingress and one for egress. When a flag is off, the endpoint allows all traffic in that direction. When it is on, the endpoint allows only what the rules of the selecting policies allow.

The policy enforcement mode sets how the flags start. In `default` mode, both flags are off until a policy selects the endpoint, and a policy turns on only the directions for which it has a rule section. In `always` mode, both flags are on for every endpoint, and every flow needs a rule. In `never` mode, no flag is on and policy is not applied.

The mode is a startup setting of the agent. The Helm chart writes it as `enable-policy`, and a change needs an agent restart. The mode `always` also affects cluster services such as DNS, so a baseline of policies must exist first.

The agent reports the flags for each endpoint on its node. Reading them is the fastest way to learn whether a policy selected an endpoint and in which direction.

Key facts:

- A policy with only an ingress section leaves egress open for its subject.
- An endpoint that no policy selects is open in `default` mode.
- The mode applies to every policy kind.
- The endpoint list shows only endpoints of the agent that answers.

<!-- astrona:playground:destroy -->
