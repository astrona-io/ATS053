---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Capstone: Grant Access By Identity Across Namespaces

Every pod with the label `team=bridge` in any namespace may call the `probe` Service. The `intruder` pod in `outpost` must stay blocked.

## Starting state

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-capstone-020-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-capstone-020-01" || exit 1
```

## Required result

Add the label `team=bridge` to the pods `shuttle` in `starfleet` and `drifter` in `outpost`. Do not label `intruder`. Create a CiliumClusterwideNetworkPolicy named `allow-bridge-team-everywhere` that selects `app: probe` and allows ingress on TCP port 8080 from endpoints with the label `team: bridge`. `shuttle` and `drifter` must reach the probe. `intruder` in `outpost` must time out.

## Verify the result

The grader reads the live cluster. It checks the object fields named above and sends real requests. Wait for the Cilium agent to apply the policy before you submit. Keep the namespaces and workload names unchanged.
