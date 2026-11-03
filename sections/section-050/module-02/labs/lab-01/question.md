---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Combine A NetworkPolicy With A CiliumNetworkPolicy

A standard NetworkPolicy already protects the `probe` Service and allows only `shuttle`. The `drifter` pod in `outpost` now also needs access. You must not edit or delete the NetworkPolicy.

## Starting state

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-lab-050-02-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-lab-050-02-01" || exit 1
```

## Required result

Leave the NetworkPolicy `probe-allow-starfleet` in `starfleet` unchanged. Create a CiliumNetworkPolicy named `allow-drifter` in `starfleet` that selects `app: probe` and allows ingress on TCP port 8080 from the pods with the label `app: drifter` in the namespace `outpost`. After the policy is applied, both `shuttle` and `drifter` must reach the probe.

## Verify the result

The grader reads the live cluster. It checks the object fields named above and sends real requests. Wait for the Cilium agent to apply the policy before you submit. Keep the namespaces and workload names unchanged.
