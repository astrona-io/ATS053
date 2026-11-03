---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Select Peers By Label Identity Solution

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-lab-020-02-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-lab-020-02-01" || exit 1
```

## Label the pod

A label change gives the pod a new security identity. Add the label:

```sh
kubectl -n starfleet label pod shuttle team=bridge
```

## Save and apply the policy

Save this as `ciliumnetworkpolicy-allow-bridge-team.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: allow-bridge-team
  namespace: starfleet
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
kubectl apply -f ciliumnetworkpolicy-allow-bridge-team.yaml
```

The rule names no namespace, so it matches only pods in the namespace of the policy. The `drifter` pod lives in `outpost` and does not match.

## Check the result

Run each request on its own. A denied request ends with an error after the timeout, so do not chain it after a command that must succeed.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=3).read()"
```

Then run `astrona submit` to grade the result.

After you record the result, remove the lab with `astrona destroy ats-053-lab-020-02-01`.

## Common pitfalls

> [!WARNING]
> Check the context before every change, and wait for the agent to realize the policy before you test.
