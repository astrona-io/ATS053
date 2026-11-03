---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Capstone: Enforce One Direction Only

The `probe` pods must not open connections to anything except DNS. Clients must still be able to call the `probe` Service.

## Starting state

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-capstone-030-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-capstone-030-01" || exit 1
```

## Required result

Create a CiliumNetworkPolicy named `probe-egress-dns-only` in `starfleet` that selects `app: probe` and has only an `egress` section. The egress section allows `kube-dns` in `kube-system` on port 53. Write no `ingress` section. Then `drifter` in `outpost` must still reach `http://probe.starfleet.svc:8080/`, and a request that the probe pod makes to `http://kubernetes.default.svc:443/` must time out.

## Verify the result

The grader reads the live cluster. It checks the object fields named above and sends real requests. Wait for the Cilium agent to apply the policy before you submit. Keep the namespaces and workload names unchanged.
