---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Limit Egress And Keep DNS Working

The `shuttle` pod in `starfleet` may only call the `probe` Service. It must not reach anything else.

## Starting state

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-lab-010-02-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-lab-010-02-01" || exit 1
```

## Required result

Create a CiliumNetworkPolicy named `shuttle-egress` in `starfleet`. It selects the pods with the label `app: shuttle`. Its egress rules allow two destinations only: the `kube-dns` pods in `kube-system` on port 53 with a DNS rule, and the `probe` pods on TCP port 8080. The request from `shuttle` to `http://probe:8080/` must succeed, which needs name resolution. A request from `shuttle` to `http://kubernetes.default.svc:443/` must time out.

## Verify the result

The grader reads the live cluster. It checks the object fields named above and sends real requests. Wait for the Cilium agent to apply the policy before you submit. Keep the namespaces and workload names unchanged.
