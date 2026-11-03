---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Capstone: Grant Access By Identity Across Namespaces Solution

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-capstone-020-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-capstone-020-01" || exit 1
```

## Label the pods

```sh
kubectl -n starfleet label pod shuttle team=bridge
kubectl -n outpost label pod drifter team=bridge
```

## Save and apply the policy

Save this as `ciliumclusterwidenetworkpolicy-allow-bridge-team-everywhere.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumClusterwideNetworkPolicy
metadata:
  name: allow-bridge-team-everywhere
spec:
  endpointSelector:
    matchLabels:
      app: probe
  ingress:
  - fromEndpoints:
    - matchLabels:
        team: bridge
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
```

Apply it:

```sh
kubectl apply -f ciliumclusterwidenetworkpolicy-allow-bridge-team-everywhere.yaml
```

A CiliumClusterwideNetworkPolicy has no namespace. Its peer selector `team: bridge` therefore matches pods in every namespace, not only in `starfleet`.

## Check the result

Run each request on its own. A denied request ends with an error after the timeout, so do not chain it after a command that must succeed.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
kubectl -n outpost exec intruder -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=3).read()"
```

Then run `astrona submit` to grade the result.

After you record the result, remove the lab with `astrona destroy ats-053-capstone-020-01`.

## Common pitfalls

> [!WARNING]
> Check the context before every change, and wait for the agent to realize the policy before you test.
