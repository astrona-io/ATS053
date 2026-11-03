---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Cilium Extensions And Scope

The standard NetworkPolicy covers the common case: pods allow pods on ports. Real requirements go beyond that. A team needs to allow one HTTP path, to reach an external API by its name, to block one client or to set a baseline for the whole cluster. This part lists what the Cilium kinds add and shows how to use them next to an existing NetworkPolicy.

## What the Cilium kinds add

The CiliumNetworkPolicy and the CiliumClusterwideNetworkPolicy share the same fields, and they add these features to the standard API.

- Entities such as `host`, `world`, `cluster`, `kube-apiserver` and `remote-node`, for peers without labels.
- Layer 7 rules for HTTP and DNS, which Cilium enforces through a proxy.
- Name-based egress with `toFQDNs`.
- Deny rules with `ingressDeny` and `egressDeny`, which win over allow rules.
- Control of default deny per direction with `enableDefaultDeny`.
- CIDR sets with exceptions, and port ranges with ICMP rules.
- Selection of nodes with `nodeSelector`, in the clusterwide kind only.

## Scope of the two Cilium kinds

The CiliumNetworkPolicy is namespaced. Its subject is always in its own namespace, and a peer selector defaults to the same namespace. The CiliumClusterwideNetworkPolicy has no namespace. Its subject selector can match pods in every namespace, and an unqualified peer selector matches pods in every namespace.

The scope decides who may edit the policy. Kubernetes RBAC (role-based access control) grants rights on a resource kind in a namespace. A team that owns a namespace can edit the namespaced policies there. A clusterwide policy is a cluster-level resource, and only cluster administrators should have edit rights on it.

## Extend a NetworkPolicy without editing it

A common situation: a standard NetworkPolicy exists, owned by another team, and a new client needs access. Editing the object changes something that the owner controls. Adding a Cilium policy that selects the same pods adds the new allow, and the old object stays as it is.

Renew the playground and connect. The playground starts with no policy, so first apply a NetworkPolicy that allows only `shuttle`.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-050-02)"
kubectl config current-context
```

Save this as `networkpolicy-allow-shuttle.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-shuttle
  namespace: starfleet
spec:
  podSelector:
    matchLabels:
      app: probe
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: shuttle
    ports:
    - port: 8080
      protocol: TCP
```

Apply it:

```sh
kubectl apply -f networkpolicy-allow-shuttle.yaml
```

Then check the result. `shuttle` prints `probe-ready`, and `drifter` times out.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=3).read()"
```

Now add the Cilium policy that allows `drifter`. Save this as `ciliumnetworkpolicy-allow-drifter.yaml`:

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

Then check the result. After the agents realize the new policy, the request from `drifter` prints `probe-ready`, and the request from `shuttle` still prints `probe-ready`.

## Block a client without editing the allows

The reverse requirement also occurs. A standard policy allows a whole group, and one member must be blocked, which the standard API cannot express. A clusterwide policy with an `ingressDeny` rule does it.

```yaml
spec:
  endpointSelector:
    matchLabels:
      app: probe
  ingressDeny:
  - fromEndpoints:
    - matchLabels:
        app: drifter
        k8s:io.kubernetes.pod.namespace: outpost
```

Because the deny rule wins over every allow rule of every kind, the `drifter` pod is dropped even though the NetworkPolicy and the namespaced Cilium policy allow it. Putting the deny in a clusterwide policy keeps it out of the namespaces of other teams, so they cannot edit it away.

## Choosing the scope of a Cilium policy

Use a namespaced policy for rules that a team owns and that concern its own workloads. Use a clusterwide policy for rules that must hold in all namespaces, such as a deny for an untrusted entity or a baseline that allows DNS. A clusterwide policy that selects a very broad set deserves a review, because a mistake affects the whole cluster.

## What this part showed

The Cilium kinds add entities, Layer 7, names, deny, default deny control and node selection to the standard API. The namespaced kind limits the subject to one namespace and the clusterwide kind spans all of them. A Cilium policy extends a NetworkPolicy by union, and a deny rule restricts the union.

## Common pitfalls

> [!WARNING]
> A deny rule in any policy wins over every allow rule, so test the result for the clients that must keep access. A clusterwide policy with an unqualified selector affects every namespace. An allow in a Cilium policy widens a strict NetworkPolicy, so the owner of the NetworkPolicy may not know the real allowed set.
