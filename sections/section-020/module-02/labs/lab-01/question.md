---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Select Peers By Label Identity

Only pods that carry the label `team=bridge` may call the `probe` Service. The `shuttle` pod must get that label.

## Starting state

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-lab-020-02-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-lab-020-02-01" || exit 1
```

## Required result

Add the label `team=bridge` to the pod `shuttle` in `starfleet`. Create a CiliumNetworkPolicy named `allow-bridge-team` in `starfleet` that selects `app: probe` and allows ingress on TCP port 8080 from endpoints with the label `team: bridge`. The request from `shuttle` to the probe must succeed and the request from `drifter` in `outpost` must time out.

## Verify the result

The grader reads the live cluster. It checks the object fields named above and sends real requests. Wait for the Cilium agent to apply the policy before you submit. Keep the namespaces and workload names unchanged.
