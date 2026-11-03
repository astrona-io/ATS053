---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Capstone: Block One Client Without Editing The NetworkPolicy

A standard NetworkPolicy already lets `shuttle` and every pod in `outpost` call the `probe` Service. The `intruder` pod in `outpost` must now be blocked. The owner of the NetworkPolicy does not allow edits.

## Starting state

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-capstone-050-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-capstone-050-01" || exit 1
```

## Required result

Leave the NetworkPolicy `probe-allow-clients` in `starfleet` unchanged. Create a CiliumClusterwideNetworkPolicy named `deny-intruder` that selects `app: probe` and has an `ingressDeny` rule for endpoints with the label `app: intruder` in the namespace `outpost`. `shuttle` and `drifter` must still reach the probe. `intruder` must time out.

## Verify the result

The grader reads the live cluster. It checks the object fields named above and sends real requests. Wait for the Cilium agent to apply the policy before you submit. Keep the namespaces and workload names unchanged.
