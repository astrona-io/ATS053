---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Security Identities, Labels And Address Independence

Pod addresses are temporary locations, while an application's role can remain stable through replacement. Cilium's identity-based policy model associates security-relevant labels with identities and uses that context for supported network decisions. This helps describe communication between workload roles without maintaining every transient address in a policy.

## Labels Describe The Policy Population

A workload can carry labels identifying its application, namespace or other supported dimensions. Endpoints with the relevant equivalent label set can share a security identity. A policy selector then describes the intended population through those labels rather than assuming that one IP address permanently identifies a trusted service.

Not every arbitrary label necessarily has the same role in the configured identity model. Understand which labels participate and how namespace context is represented. A selector that omits an important scope constraint can include workloads outside the intended trust boundary. Naming a label app does not intrinsically make its values trustworthy.

## Numeric Identity Is Implementation Context

The numeric identifier represents the security context used by Cilium's implementation. It is not a Kubernetes ServiceAccount credential or a business authentication token. Observing a numeric identity in a flow can help connect the record to realized endpoint state, but it should not be treated as a portable permission grant independent of that state.

Kubernetes API authentication and RBAC govern API operations. Application authentication governs business requests. Cilium network identity governs supported network policy relationships. A workload may be permitted to connect to a service yet still lack application authorization, or have API permission while network policy denies the transport path.

## Reserved Context And External Peers

Cilium has reserved identities or entities for particular contexts, such as host or world, under its documented model. These represent broader classes than a single application label. An allow to a broad entity can therefore permit more traffic than a narrow endpoint selector. Review the exact supported entity semantics and selected path.

External destinations may be represented through address or FQDN-aware mechanisms rather than the same workload-label relationship. A policy that works for managed endpoints should not automatically be assumed to identify every external service's authenticated application identity. Encryption or TLS certificate validation supplies another kind of evidence.

## Address Changes Still Require State

Identity-based intent does not remove the need for endpoint address, route and identity propagation. When a Pod is replaced, agents must realize the new endpoint and relevant relationship. A stale view can produce behavior that does not match current declarations. Compare the endpoint's actual labels, identity and realized policy on the affected node.

In a multi-cluster environment, cluster identity and namespace context also matter. Identically named applications in different clusters may or may not be intended peers. State the supported selection and trust model instead of assuming names alone create universal identity equivalence.

## Protect The Label Boundary

Who may change workload labels or create a workload with selected labels can influence policy membership. API permissions and admission policy can constrain that authority. A tenant able to impersonate a trusted role through unrestricted labels can undermine the intended network relationship even when the datapath enforces the declared rule correctly.

Review identity through the full chain: authorized declaration, endpoint realization, peer selection and observed policy decision. Address independence improves expressiveness, but it does not eliminate trust in metadata or substitute for authenticated application authority.

## Common pitfalls

> [!WARNING]
> Numeric network identity is not an API credential. Label-based policy requires trusted metadata and realized state, and broad entities can grant more reachability than narrow workload selectors.
