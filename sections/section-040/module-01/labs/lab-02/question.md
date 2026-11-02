---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Restrict A Request By HTTP Path

Permit GET /public and reject GET /private from the same client.

## Starting state

Cilium manages the private two-node cluster. Hubble Relay and the BGP control plane are enabled. The probe and two clients are healthy; no learner policy or evidence report exists. This baseline uses kube-proxy and tunnelling.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-lab-040-01-02)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-lab-040-01-02" || exit 1
node_name="astro-ats-053-lab-040-01-02-control-plane"
worker_name="astro-ats-053-lab-040-01-02-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Use an HTTP rule on TCP 8080. Both requests come from the same permitted namespace, so the changed verdict tests the L7 path constraint rather than a different identity.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
