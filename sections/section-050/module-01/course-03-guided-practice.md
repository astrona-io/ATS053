---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Apply And Check A Kubernetes NetworkPolicy

This part applies a standard NetworkPolicy to the `probe` pods and checks it with requests and with the agent. The goal is to see that the Cilium agent enforces a portable resource in the same way as its own policy kind.

## Connect to the playground

Renew the playground and connect. Check the context before any change.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-050-01)"
kubectl config current-context
```

The context must be `kind-astro-ats-053-playground-050-01`.

## Apply the NetworkPolicy

The policy selects the `probe` pods, covers ingress only and allows pods of the namespace `starfleet` on TCP port 8080. The namespace is selected through the label that Kubernetes sets on every namespace.

Save this as `networkpolicy-allow-starfleet.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-starfleet
  namespace: starfleet
spec:
  podSelector:
    matchLabels:
      app: probe
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: starfleet
    ports:
    - port: 8080
      protocol: TCP
```

Apply it:

```sh
kubectl apply -f networkpolicy-allow-starfleet.yaml
```

Then check the result. Wait a few seconds for the agents. The request from `shuttle` is in the allowed namespace, and the request from `drifter` is not.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=3).read()"
```

The first request prints `probe-ready`. The second request ends with an error that contains `timed out`.

## See it in the agent

The agent holds the translated rule. Print the endpoint list on the agent of the node that hosts the `probe` pod. The ingress enforcement column of the `probe` endpoint shows `Enabled`, and the egress column shows `Disabled`, as for a Cilium policy with only an ingress section.

```sh
kubectl -n kube-system get pods -l k8s-app=cilium -o wide
kubectl -n kube-system exec <AGENT_POD> -- cilium-dbg endpoint list
```

Replace `<AGENT_POD>` with the agent pod that runs on the node of the `probe` pod. Then list the policy rules the agent holds and find the one that carries the name `allow-starfleet`.

```sh
kubectl -n kube-system exec <AGENT_POD> -- cilium-dbg policy get
```

The output is a JSON list of rules. Look for the labels of the rule that name the resource kind `NetworkPolicy`, the name `allow-starfleet` and the namespace `starfleet`. The exact layout depends on the Cilium version, so this page does not print it.

## Add a Cilium policy next to it

Add a second policy of the Cilium kind that allows the `drifter` pod. The NetworkPolicy stays unchanged.

Save this as `ciliumnetworkpolicy-allow-drifter.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: allow-drifter
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: drifter
        k8s:io.kubernetes.pod.namespace: outpost
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
```

Apply it:

```sh
kubectl apply -f ciliumnetworkpolicy-allow-drifter.yaml
```

Then check the result. Both requests print `probe-ready`, because the allowed set is the union of both policies.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
```

## What this part showed

The Cilium agent enforced a standard NetworkPolicy with the same flags as its own policy kind, and a second policy of the Cilium kind added an allow without any edit to the first. The union of both kinds decided the result.

## Common pitfalls

> [!WARNING]
> A numeric port in a NetworkPolicy has no quotes, and in a Cilium policy it does. Read the agent that hosts the pod, because an agent knows only its own node. A policy of the other kind can widen the result, so list both kinds when a request passes that you expected to fail.
