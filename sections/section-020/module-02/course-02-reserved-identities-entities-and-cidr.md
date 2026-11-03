---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Reserved Identities, Entities And CIDR

Some of the most important traffic in a cluster does not come from a labelled pod. Health checks come from the node, API calls go to the Kubernetes API server, and external clients come from the internet. This part shows how Cilium gives these peers an identity, and how a policy names them.

## Reserved identities

Cilium reserves a range of small identity numbers for special peers. These are called reserved identities. They exist in every cluster, with fixed meaning. The agent lists them with `cilium-dbg identity list`, next to the identities of pods.

The reserved identities that matter for policy are these:

- `host`: the local node, including processes that use the host network.
- `remote-node`: other nodes of the cluster.
- `kube-apiserver`: the Kubernetes API server addresses.
- `world`: every address outside the cluster that has no other identity.
- `health`: the Cilium health endpoints.
- `init`: an endpoint whose identity is not yet resolved.
- `unmanaged`: a pod that Cilium does not manage.
- `ingress`: the Cilium Envoy proxy that handles ingress traffic.

## Entities select reserved identities

A policy does not use the numbers. It uses entities, which are names for groups of reserved identities. The peer fields are `fromEntities` and `toEntities`. The entity `world` selects traffic from or to every address outside the cluster. The entity `cluster` selects everything inside the cluster, which includes all pods, all nodes and the health endpoints. The entity `all` selects every peer.

```yaml
ingress:
- fromEntities:
  - world
  toPorts:
  - ports:
    - port: "8080"
      protocol: TCP
```

This rule allows traffic from outside the cluster to TCP port 8080. It does not allow other ports, and it does not change what other rules allow.

## Read the reserved identities

Renew the playground and look at the identities that the agent holds. The first command connects to the playground. The second lists identities, and the reserved ones have small numbers and labels that start with `reserved:`.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-020-02)"
kubectl -n kube-system exec ds/cilium -- cilium-dbg identity list
```

Find the entries whose labels are `reserved:host`, `reserved:world` and `reserved:kube-apiserver`. Every pod identity in the list also shows its labels, which you can compare with the labels of your pods. The exact numbers and the full list differ between clusters, so this page does not print them.

## CIDR rules for addresses

A CIDR (Classless Inter-Domain Routing) block is an address range such as `192.0.2.0/24`. The fields `fromCIDR`, `toCIDR`, `fromCIDRSet` and `toCIDRSet` select peers by range. A CIDR rule fits destinations that have no labels, such as an external database with a fixed address range.

`toCIDRSet` adds an `except` list, so a rule can allow a broad range and exclude parts of it. A CIDR rule should not select pods or Services of the cluster, because Cilium identifies those by identity and not by address. The documented behaviour is that CIDR rules do not apply to cluster-internal endpoints.

```yaml
egress:
- toCIDRSet:
  - cidr: 192.0.2.0/24
    except:
    - 192.0.2.128/25
```

This rule allows egress to the addresses of the block `192.0.2.0/24` except the upper half. When a policy names a CIDR, the agent allocates a local identity for that range and stores it in an IP-to-identity map named the ipcache.

## The ipcache

The ipcache maps an IP address or range to an identity. For pods, the agent fills it from the pod addresses. For CIDR rules, it adds the named ranges. For all other addresses, a lookup returns the reserved `world` identity. The agent prints the cache with `cilium-dbg bpf ipcache list`, which shows the address, the identity and, for tunnel traffic, the node that owns it.

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg bpf ipcache list
```

Find the address of the `shuttle` pod, which `kubectl -n starfleet get pod shuttle -o wide` prints, and look for it in the list. Its identity number matches the identity of the `shuttle` endpoint.

## Node and host peers

The entity `host` covers the node that runs the pod. This matters because the kubelet, the node agent of Kubernetes, sends health probes from the host network. If a policy puts a pod into default deny for ingress and does not allow `host`, a probe from the kubelet can be dropped. Cilium allows traffic from the local host to local endpoints by default, so this problem normally does not appear. A setting that disables that default makes the rule necessary.

## What this part showed

Reserved identities give the special peers a stable meaning, and entities are the policy names for them. CIDR rules cover labelless external addresses, and the ipcache connects addresses to identities in both cases. The question that remains is how enforcement is switched on for an endpoint at all.

## Common pitfalls

> [!WARNING]
> The entity `world` does not include nodes or pods of the cluster. The entity `cluster` includes every node and pod, so it is wider than most rules need. A CIDR rule does not select cluster pods, and a pod address in a CIDR rule does not stay valid when the pod restarts.
