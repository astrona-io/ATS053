---
draft: true
exam_objectives:
- Kubernetes Network Policies versus Cilium Network Policies
---
# Kubernetes NetworkPolicy And Cilium Extensions

Kubernetes NetworkPolicy and Cilium's extended policy resources share the goal of restricting communication, but their scope and expressiveness differ. Choosing between them requires understanding portability, intended enforcement and the additional semantics an application needs. More fields do not automatically create a better boundary if the selected implementation cannot enforce them.

## The Standard Contract

Kubernetes NetworkPolicy selects Pods in a namespace and describes ingress and egress relationships using supported selectors and address blocks. Isolation is direction-specific, and allowed relationships from applicable policies combine. A missing allow in one policy is not a general explicit denial that cancels an allow in another.

The standard resource needs a network implementation that supports enforcement. Creating the object in a cluster without suitable support does not prove traffic is restricted. Even with support, host-related paths and implementation details need review within the documented contract. A namespace resource does not become a universal host firewall.

## Cilium Adds Extended Resources

CiliumNetworkPolicy provides a namespaced extended model, while CiliumClusterwideNetworkPolicy supports broader scope and supported node-related patterns. Extensions can include identity-aware entities, FQDN relationships, application-layer rules and explicit deny behavior. These capabilities depend on Cilium and their documented prerequisites.

An applicable explicit Cilium deny takes precedence over an allow. That is a different expressive feature from the standard API's additive allow model. Do not describe a standard policy with no matching allow as though it had the same explicit deny field or cross-policy precedence mechanism.

## Portability Is A Deliberate Tradeoff

A standard policy can be easier to reuse across compatible Kubernetes network implementations. An extended policy can express a needed HTTP or external-name relationship that the standard API does not directly represent. The decision depends on the requirement and migration expectations rather than a blanket rule to use only one API.

If an environment changes network implementations, Cilium CRDs may remain stored without an active controller or datapath interpreting them. A successful API listing is not proof of continued enforcement. Migration needs a mapping of actual semantics and supported paths, including differences in defaults and host traffic.

## Combine Policies Carefully

Standard and extended policies can apply to the same endpoint in a Cilium deployment. Review the effective relationships together. A broad allow from one resource can expand the allowed set, while a matching extended deny can block a relationship that another rule allows. The result is not established by reading only the resource with the most security-oriented title.

DNS, readiness and application dependencies also remain relevant. A more expressive resource cannot infer every legitimate dependency automatically. Narrowly allow the required relationship and assess its actual direction, peer and protocol.

## Verify The Intended Boundary

Identify the workload labels, selected policy resources, enforcement mode and realized endpoint policy. Then use appropriate observations to distinguish permission from routing or destination failure. An allowed network flow can still fail business authentication, and a denied flow need not indicate a malformed route.

Document which parts of the design use the standard contract and which rely on Cilium extensions. That makes review, future migration and incident reasoning possible without treating every YAML object as universally portable protection.

## Common pitfalls

> [!WARNING]
> Standard NetworkPolicy allows combine; Cilium explicit denies add different semantics. Extended CRDs require their implementation, and API presence alone does not establish enforcement or portability.
