---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Apply A Policy And Check The Enforcement State

This part applies one ingress policy to the `probe` pods and then checks three things: the enforcement flags in the agent, a request that the policy allows and a request that it drops. You see the per-direction rule from the first part in real output.

## Connect and look at the start state

Renew the playground and connect. Check the context before any change.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-030-01)"
kubectl config current-context
```

The context must be `kind-astro-ats-053-playground-030-01`.

Before any policy exists, both clients reach the probe. Run the two requests and confirm that both print `probe-ready`.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
```

## Apply an ingress policy

The policy selects the `probe` pods and allows only `shuttle` on TCP port 8080. It has an ingress section and no egress section.

Save this as `ciliumnetworkpolicy-allow-shuttle.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: allow-shuttle
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
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
kubectl apply -f ciliumnetworkpolicy-allow-shuttle.yaml
```

Then check the result. Wait a few seconds for the agent to realize the policy, and run the two requests again.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=3).read()"
```

The first request prints `probe-ready`. The second request ends with an error that contains `timed out`, because no rule allows `drifter`.

## Read the enforcement flags

Ask the agent for the endpoint list. The `probe` endpoint now has ingress enforcement enabled. Its egress column shows that egress enforcement is still disabled, because no policy has an egress section for it.

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg endpoint list
```

The list shows only the endpoints on the node of the agent that answers. If the `probe` pod is on the other node, run the command against the agent pod of that node. Use `kubectl -n kube-system get pods -l k8s-app=cilium -o wide` to match agents with nodes.

## Why egress stays open

The policy has no egress section, so no policy turns on egress enforcement for the `probe` endpoint. The egress column of the endpoint list is the evidence for this. Do not test it with a request from the `probe` pod to its own Service, because that request is also an ingress flow to the `probe` endpoint, and the ingress rule allows only `shuttle`.

## Remove the policy

Delete the policy and run the endpoint list again. Both flags return to `Disabled`, because no policy selects the endpoint any more.

```sh
kubectl -n starfleet delete ciliumnetworkpolicy allow-shuttle
kubectl -n kube-system exec ds/cilium -- cilium-dbg endpoint list
```

## What this part showed

An ingress policy turned on the ingress flag of the `probe` endpoint and left the egress flag off. The allowed client kept working, and the other client timed out. Deleting the policy turned the flag off again. The same mechanism explains every policy in the following modules.

## Common pitfalls

> [!WARNING]
> Read the endpoint list on the agent of the node that hosts the pod. Wait for the agent to realize the policy before you test.
