---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Interpret Cilium Network Polices and Intent

This section teaches how to read a Cilium policy as a contract: which pods it selects, in which direction it acts, who may connect and on which port. It also covers the dependencies that an application needs, such as name resolution, and how to ask the Cilium agent which policy it enforces.

The first module reads subject, direction, peers, ports and the way rules combine. The second module adds egress dependencies, DNS, and the evidence you collect from the agent. A capstone lab and a quiz close the section.

## Learning Outcomes

- Identify the pods a policy selects and the direction it acts on.
- Read peer, port and Layer 7 fields as combined constraints, and rules as a union.
- Explain why an egress policy must allow DNS before a named destination works.
- Read the enforcement state and the realized rules of an endpoint with `cilium-dbg`.
- Tell a policy drop from another failure by using drop events and Hubble verdicts.
