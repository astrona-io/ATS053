---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Summary

Cilium enforces Layer 7 rules through a proxy. An HTTP rule filters by method, path and host, using regular expressions. A request that does not match is answered with status 403, while a request dropped by a Layer 3 or Layer 4 rule gets no answer and times out.

A DNS rule filters the lookups an endpoint may send. A `toFQDNs` rule allows connections to the addresses returned for the named domains, and it works only together with a DNS rule that lets the DNS proxy see the answers. Cluster names need their own pattern in the DNS rule.

Deny rules in `ingressDeny` and `egressDeny` take precedence over every allow rule in every policy kind. The order of checks is deny first, then allow, then the default drop for an enforced endpoint. A deny policy also turns on default deny for its subject.

Deny rules cannot match Layer 7 content or domain names. For those cases, an allow rule that leaves the content out is the tool.

Key facts:

- A Layer 7 mismatch gives status 403, and a Layer 3 or Layer 4 drop gives a timeout.
- `toFQDNs` allows nothing without a DNS rule.
- A deny rule cannot be overridden by any allow rule.
- A policy with only deny rules still enforces default deny.

<!-- astrona:playground:destroy -->
