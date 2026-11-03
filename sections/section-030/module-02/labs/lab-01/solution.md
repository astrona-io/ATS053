---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Add A Rule Without Enabling Default Deny Solution

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-lab-030-02-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-lab-030-02-01" || exit 1
```

## Save and apply the policy

Save this as `ciliumnetworkpolicy-observe-shuttle.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: observe-shuttle
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
  enableDefaultDeny:
    ingress: false
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: shuttle
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
```

Apply it:

```sh
kubectl apply -f ciliumnetworkpolicy-observe-shuttle.yaml
```

Because `enableDefaultDeny.ingress` is `false`, the policy does not move the `probe` endpoint into default deny for ingress. The allow rule is stored, but traffic that matches no rule is still allowed.

## Check the result

Run each request on its own. A denied request ends with an error after the timeout, so do not chain it after a command that must succeed.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
```

Then run `astrona submit` to grade the result.

After you record the result, remove the lab with `astrona destroy ats-053-lab-030-02-01`.

## Common pitfalls

> [!WARNING]
> Check the context before every change, and wait for the agent to realize the policy before you test.
