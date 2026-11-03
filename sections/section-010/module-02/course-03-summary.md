---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Summary

An application depends on more than its main destination. A name lookup needs egress to the cluster DNS service before any named destination works. A complete egress policy therefore lists DNS first and each destination after it, and a DNS rule makes the Cilium DNS proxy see the queries.

A `toFQDNs` rule allows the addresses that the DNS proxy learned for a name. It needs a DNS rule for the same endpoint, and it is meant for destinations outside the cluster. A name that the pod never resolved through the proxy has no allowed addresses.

To know what is enforced, ask the Cilium agent. The endpoint list shows, for each direction, whether policy enforcement is on. The realized rules of an endpoint show which policies produced its rules. Drop events and Hubble verdicts show which requests Cilium dropped and in which direction.

Key facts:

- Egress default deny cuts off DNS unless a rule allows it.
- `toFQDNs` cannot share a rule with `toEndpoints` or `toCIDR`.
- An agent reports only the endpoints on its own node.
- A failing request without a drop event is not a policy drop.

<!-- astrona:playground:destroy -->
