---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Limit Egress And Keep DNS Working Solution

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-lab-010-02-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-lab-010-02-01" || exit 1
```

## Save and apply the policy

Save this as `ciliumnetworkpolicy-shuttle-egress.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: shuttle-egress
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: shuttle
  egress:
  - toEndpoints:
    - matchLabels:
        k8s:io.kubernetes.pod.namespace: kube-system
        k8s:k8s-app: kube-dns
    toPorts:
    - ports:
      - port: "53"
        protocol: ANY
      rules:
        dns:
        - matchPattern: "*"
  - toEndpoints:
    - matchLabels:
        app: probe
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
```

Apply it:

```sh
kubectl apply -f ciliumnetworkpolicy-shuttle-egress.yaml
```

The first egress rule lets `shuttle` ask `kube-dns` for names. Without it, the name `probe` does not resolve and the second rule never gets a chance to match.

## Check the result

Run each request on its own. A denied request ends with an error after the timeout, so do not chain it after a command that must succeed.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe:8080/',timeout=4).read().decode())"
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; urllib.request.urlopen('http://kubernetes.default.svc:443/',timeout=3).read()"
```

Then run `astrona submit` to grade the result.

After you record the result, remove the lab with `astrona destroy ats-053-lab-010-02-01`.

## Common pitfalls

> [!WARNING]
> Check the context before every change, and wait for the agent to realize the policy before you test.
