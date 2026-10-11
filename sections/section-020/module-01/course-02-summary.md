---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Summary

Cilium security identities associate relevant labels with network policy meaning, allowing rules to follow workload roles rather than temporary addresses. Numeric identities are implementation context rather than portable API credentials.

Reserved entities and namespace labels affect selection. Label integrity, propagation and realized endpoint state determine the effective boundary, while authenticated application and Kubernetes API authority remain separate responsibilities.
