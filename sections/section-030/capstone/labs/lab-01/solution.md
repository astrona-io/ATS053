---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Capstone: Enforce One Direction Only Solution

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-capstone-030-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-capstone-030-01" || exit 1
```

## Save and apply the policy

Save this as `ciliumnetworkpolicy-probe-egress-dns-only.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: probe-egress-dns-only
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
  egress:
  - toEndpoints:
    - matchLabels:
        k8s:io.kubernetes.pod.namespace: kube-system
        k8s:k8s-app: kube-dns
    toPorts:
    - ports:
      - port: "53"
        protocol: ANY
```

Apply it:

```sh
kubectl apply -f ciliumnetworkpolicy-probe-egress-dns-only.yaml
```

Default deny works per direction. This policy has an `egress` section, so the `probe` endpoint is in default deny for egress. It has no `ingress` section, so ingress stays open.

## Check the result

Run each request on its own. A denied request ends with an error after the timeout, so do not chain it after a command that must succeed.

```sh
kubectl -n outpost exec drifter -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
kubectl -n starfleet exec deploy/probe -- python -c "import urllib.request; urllib.request.urlopen('http://kubernetes.default.svc:443/',timeout=3).read()"
```

Then run `astrona submit` to grade the result.

After you record the result, remove the lab with `astrona destroy ats-053-capstone-030-01`.

## Common pitfalls

> [!WARNING]
> Check the context before every change, and wait for the agent to realize the policy before you test.
