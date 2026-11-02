---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Enforce An Endpoint Selected Policy

Permit the trusted client while denying the untrusted client.

## Starting state

Cilium manages the private two-node cluster. Hubble Relay and the BGP control plane are enabled. The probe and two clients are healthy; no learner policy or evidence report exists. This baseline uses kube-proxy and tunnelling.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-lab-010-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-lab-010-01-01" || exit 1
node_name="astro-ats-053-lab-010-01-01-control-plane"
worker_name="astro-ats-053-lab-010-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Select the probe endpoint, allow traffic from starfleet and deny a request from outpost. Policy selection changes the selected endpoints default ingress behavior.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
