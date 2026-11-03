---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Summary

A CiliumNetworkPolicy has a subject and one or two directions. The `endpointSelector` names the subject, which is the group of endpoints that the policy governs. The `ingress` section describes traffic that enters the subject, and the `egress` section describes traffic that leaves it. The first policy with a section for a direction puts the selected endpoints into default deny for that direction only.

Inside one rule, the peer and the port are joined with AND. Items in one peer list are joined with OR. Several allow rules and several policies add up as a union, so a broad allow can cancel the effect of a narrow one. To state the real contract of an endpoint, list every policy that selects it and combine the rules.

The Cilium agent compiles each policy into kernel rules for the endpoints on its node. Layer 3 and Layer 4 drops appear to the client as timeouts. The Kubernetes API server accepting a policy does not prove enforcement, so an agent command such as `cilium-dbg endpoint list` and real requests are the evidence.

Key facts:

- The subject is the `endpointSelector`, never the peer.
- Direction is always written from the point of view of the subject.
- Selection changes the default for the selected direction only.
- Allow rules add up. A matching deny rule wins over allow rules.

<!-- astrona:playground:destroy -->
