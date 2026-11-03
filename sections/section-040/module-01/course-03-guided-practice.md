---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Apply And Test A Port-Scoped Policy

This part builds a policy from a requirement, applies it, and tests it from both sides. The requirement is: pods in the namespace `outpost` may reach the `probe` pods on TCP port 8080 and nothing else may.

## Connect to the playground

Renew the playground and connect. Check the context before any change.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-040-01)"
kubectl config current-context
```

The context must be `kind-astro-ats-053-playground-040-01`.

## Write the policy from the requirement

The requirement names four things. The subject is the `probe` pods in `starfleet`. The direction is ingress. The peer is every pod in the namespace `outpost`, so the selector uses the namespace label and no `app` label. The traffic is TCP port 8080.

Save this as `ciliumnetworkpolicy-allow-outpost.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: allow-outpost
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
  ingress:
  - fromEndpoints:
    - matchLabels:
        k8s:io.kubernetes.pod.namespace: outpost
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
```

Apply it:

```sh
kubectl apply -f ciliumnetworkpolicy-allow-outpost.yaml
```

## Test the allowed and the dropped request

Wait a few seconds for the agent to realize the policy. Then send one request from each client.

```sh
kubectl -n outpost exec drifter -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=3).read()"
```

The first request prints `probe-ready`. The second request ends with an error that contains `timed out`, because `shuttle` is in `starfleet` and the rule allows only the namespace `outpost`.

The selector matched through the namespace label alone. The pod `drifter` has the label `app=drifter`, but the rule does not look at it. A new pod in `outpost` with any labels is allowed too, which is the effect of a namespace-wide selector.

## Check the realized rule

Find the agent that hosts the `probe` pod and print the endpoint list. Then read the realized ingress rules of the `probe` endpoint with the command below, where `<AGENT_POD>` and `<ENDPOINT_ID>` come from the list.

```sh
kubectl -n kube-system get pods -l k8s-app=cilium -o wide
kubectl -n kube-system exec <AGENT_POD> -- cilium-dbg endpoint list
kubectl -n kube-system exec <AGENT_POD> -- cilium-dbg endpoint get <ENDPOINT_ID> -o jsonpath='{range ..status.policy.realized.l4.ingress[*].derived-from-rules}{@}{"\n"}{end}'
```

Each printed line names a policy that produced a rule for the endpoint. The policy `allow-outpost` must appear. If it does not appear, the agent did not select the endpoint with the policy, and the cause is the selector or the namespace.

## Narrow the rule to one pod

Replace the peer selector so that it also requires the label `app: drifter`. Edit the file so that the peer selector has both labels, and apply it again.

```yaml
    - matchLabels:
        k8s:io.kubernetes.pod.namespace: outpost
        app: drifter
```

Both labels are in one selector item, so both must match. The request from `drifter` still prints `probe-ready`. A pod in `outpost` without the label `app=drifter` is now dropped.

## What this part showed

A requirement maps to the fields of a policy one to one: subject, direction, peer and port. A namespace label selects every pod in a namespace, and an added label narrows the peer. The agent confirms the realized rule for the endpoint.

## Common pitfalls

> [!WARNING]
> A namespace-only selector allows every pod in that namespace, including pods created later. Two labels in one selector item are joined with AND. Test the dropped request as well as the allowed one, because a rule that allows everything also passes the first test.
