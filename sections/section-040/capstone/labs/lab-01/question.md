---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Capstone: Combine An Entity Allow With A Deny Rule

Everything inside the cluster may call the `probe` Service on port 8080, except the `drifter` pod in `outpost`.

## Starting state

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-capstone-040-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-capstone-040-01" || exit 1
```

## Required result

Create a CiliumNetworkPolicy named `probe-cluster-with-deny` in `starfleet` that selects `app: probe`. Its `ingress` rule allows the entity `cluster` on TCP port 8080. Its `ingressDeny` rule denies endpoints with the label `app: drifter` in the namespace `outpost`. `shuttle` must reach the probe and `drifter` must time out.

## Verify the result

The grader reads the live cluster. It checks the object fields named above and sends real requests. Wait for the Cilium agent to apply the policy before you submit. Keep the namespaces and workload names unchanged.
