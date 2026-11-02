---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Restrict A Request By HTTP Path

Permit GET /public and reject GET /private from the same client.

The task and solution use a separate pinned kind cluster. Run `testing/smoke.sh` with its private kubeconfig to verify initial rejection and reference success. Static validation is not live evidence. Runtime verification remains pending.
