---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Summary

Cilium offers two tools to adopt policy without outages. Audit mode lets the agent evaluate policy and report the flows it would drop, while the flows still pass. It applies to the whole agent through the `--policy-audit-mode` flag, or to one endpoint through the `PolicyAuditMode` option.

Hubble labels each flow with a verdict. `FORWARDED` is an allowed flow, `DROPPED` is a flow dropped by enforcement, and `AUDIT` is a flow that a policy would drop in audit mode. The audit events are a work list of missing rules.

The `enableDefaultDeny` field of a policy, set per direction, stops that policy from turning on default deny. The rules are stored and apply as soon as another policy enforces the same direction. Switching the field to `true` is the moment enforcement starts.

A safe rollout writes the allow rules, observes a full application cycle, adds missing rules, and then enforces one workload at a time with a prepared rollback.

Key facts:

- Audit mode allows flows that the policy would drop, so it does not protect.
- The per-endpoint audit option is lost when the endpoint is recreated.
- A policy with `enableDefaultDeny` set to `false` does not restrict by itself.
- Deleting the last enforcing policy opens the endpoint.

<!-- astrona:playground:destroy -->
