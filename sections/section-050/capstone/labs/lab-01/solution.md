---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Capstone: Block One Client Without Editing The NetworkPolicy Solution

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-capstone-050-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-capstone-050-01" || exit 1
```

## Save and apply the policy

Save this as `ciliumclusterwidenetworkpolicy-deny-intruder.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumClusterwideNetworkPolicy
metadata:
  name: deny-intruder
spec:
  endpointSelector:
    matchLabels:
      app: probe
  ingressDeny:
  - fromEndpoints:
    - matchLabels:
        app: intruder
        k8s:io.kubernetes.pod.namespace: outpost
```

Apply it:

```sh
kubectl apply -f ciliumclusterwidenetworkpolicy-deny-intruder.yaml
```

A deny rule takes precedence over allow rules, and that holds across resource kinds. The NetworkPolicy still allows all of `outpost`, but the deny rule removes `intruder` from that set.

## Check the result

Run each request on its own. A denied request ends with an error after the timeout, so do not chain it after a command that must succeed.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
kubectl -n outpost exec intruder -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=3).read()"
```

Then run `astrona submit` to grade the result.

After you record the result, remove the lab with `astrona destroy ats-053-capstone-050-01`.

## Common pitfalls

> [!WARNING]
> Check the context before every change, and wait for the agent to realize the policy before you test.
