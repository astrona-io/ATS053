---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Summary

A policy states which endpoints it governs and which communication relationships are permitted or denied under the active enforcement model. Selection, direction, peers and protocol constraints must be interpreted together.

Allowed relationships can combine across policies, while applicable deny rules take precedence. DNS and dependencies need explicit consideration; accepting a resource does not prove realized endpoint policy or successful application communication.
