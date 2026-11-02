---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Starting Environment

Cilium manages the private two-node cluster. Hubble Relay and the BGP control plane are enabled. The probe and two clients are healthy; no learner policy or evidence report exists. This baseline uses kube-proxy and tunnelling.

Permit the trusted client while denying the untrusted client.
