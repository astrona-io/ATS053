---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Add A Rule Without Enabling Default Deny

The team wants to roll out an allow rule for the `probe` Service in steps. The first step must not block any client.

## Starting state

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-lab-030-02-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-lab-030-02-01" || exit 1
```

## Required result

Create a CiliumNetworkPolicy named `observe-shuttle` in `starfleet`. It selects `app: probe`, allows ingress on TCP port 8080 from `app: shuttle`, and sets `enableDefaultDeny` for ingress to `false`. After it is applied, both `shuttle` and `drifter` must still reach the probe.

## Verify the result

The grader reads the live cluster. It checks the object fields named above and sends real requests. Wait for the Cilium agent to apply the policy before you submit. Keep the namespaces and workload names unchanged.
