---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Policy Rule Structure

This section teaches the fields of a Cilium policy and how they fit together: the subject selector, peer selectors, ports, application rules and deny rules.

The first module covers the anatomy of a policy, selectors, peers, ports and how rule fields combine. The second module covers HTTP and DNS rules, deny rules and their precedence. A capstone lab and a quiz close the section.

## Learning Outcomes

- Read `endpointSelector` separately from peer selectors, and write selector expressions.
- Write port rules with protocols and port ranges.
- Combine peers, ports and Layer 7 rules correctly with AND and OR.
- Write HTTP and DNS rules and predict the 403 or timeout the client sees.
- Use deny rules, know that deny wins, and know their limits.
