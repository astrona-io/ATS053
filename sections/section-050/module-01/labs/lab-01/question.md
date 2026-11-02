---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Enforce A Standard Kubernetes Policy

Express the namespace boundary using standard NetworkPolicy.

## Starting state

Cilium manages the private two-node cluster. Hubble Relay and the BGP control plane are enabled. The probe and two clients are healthy; no learner policy or evidence report exists. This baseline uses kube-proxy and tunnelling.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-lab-050-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-lab-050-01-01" || exit 1
node_name="astro-ats-053-lab-050-01-01-control-plane"
worker_name="astro-ats-053-lab-050-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Apply an ingress-only NetworkPolicy selecting app=probe. Compare its portable API with Cilium extensions; verify the allowed request and the bounded rejected request.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
