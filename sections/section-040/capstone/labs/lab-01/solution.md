---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Capstone: Combine An Entity Allow With A Deny Rule Solution

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-capstone-040-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-capstone-040-01" || exit 1
```

## Save and apply the policy

Save this as `ciliumnetworkpolicy-probe-cluster-with-deny.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: probe-cluster-with-deny
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
  ingress:
  - fromEntities:
    - cluster
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
  ingressDeny:
  - fromEndpoints:
    - matchLabels:
        app: drifter
        k8s:io.kubernetes.pod.namespace: outpost
```

Apply it:

```sh
kubectl apply -f ciliumnetworkpolicy-probe-cluster-with-deny.yaml
```

The `cluster` entity includes `drifter`. The deny rule still wins, because a matching deny rule takes precedence over every allow rule.

## Check the result

Run each request on its own. A denied request ends with an error after the timeout, so do not chain it after a command that must succeed.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=3).read()"
```

Then run `astrona submit` to grade the result.

After you record the result, remove the lab with `astrona destroy ats-053-capstone-040-01`.

## Common pitfalls

> [!WARNING]
> Check the context before every change, and wait for the agent to realize the policy before you test.
