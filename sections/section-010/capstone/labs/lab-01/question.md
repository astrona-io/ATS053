---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Capstone: Write The Contract For Both Directions

The `probe` Service must accept requests only from `shuttle`. The `shuttle` pod may only call the `probe` Service and use DNS.

## Starting state

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-capstone-010-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-capstone-010-01" || exit 1
```

## Required result

Create two CiliumNetworkPolicy objects in `starfleet`. `probe-ingress` selects `app: probe` and allows ingress on TCP 8080 from `app: shuttle` only. `shuttle-egress` selects `app: shuttle` and allows egress only to `kube-dns` in `kube-system` on port 53 with a DNS rule and to `app: probe` on TCP 8080. Then: `shuttle` reaches `http://probe:8080/`, `drifter` in `outpost` times out against the probe, and `shuttle` times out against `http://kubernetes.default.svc:443/`.

## Verify the result

The grader reads the live cluster. It checks the object fields named above and sends real requests. Wait for the Cilium agent to apply the policy before you submit. Keep the namespaces and workload names unchanged.
