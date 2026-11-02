---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Interpreting A Cilium Policy As A Communication Contract

Reading a Cilium policy means translating its fields into a communication contract. The contract has a subject, a direction, peers and protocol constraints. A correct interpretation also considers the enforcement mode and other applicable policies. Looking at one familiar allow entry is insufficient to establish the effective relationship.

## Identify The Subject First

The endpointSelector identifies the endpoints governed by a workload policy. Ingress describes traffic arriving at those endpoints, while egress describes traffic leaving them. A selector for checkout does not automatically mean checkout is the remote peer; its position in the rule determines its role.

Namespace scope and label meaning affect the selected population. A namespaced CiliumNetworkPolicy and a cluster-wide policy can have different scope. Inspect the actual endpoint labels and the resource's context rather than infer selection from an application name in a comment. A policy that selects no intended endpoints cannot protect them merely because its title sounds correct.

## Combine Constraints Within A Relationship

A rule can describe peers through endpoint selectors, entities or supported address-related mechanisms. Port and protocol constraints narrow the relationship. Layer 7 rules can further constrain a supported application operation, such as an HTTP method or path, through the appropriate proxy path.

For example, allowing a checkout endpoint to reach selected database endpoints on a particular TCP port does not grant access to every port at those peers. Adding an HTTP constraint is meaningful only for traffic and a feature path that can interpret that protocol. Network permission also does not provide the database credentials or business authorization required by the application.

## Read The Effective Policy Set

Allowed relationships can combine across applicable policies. A broad allow can therefore defeat the narrow intent of another allow-only rule by adding more permitted traffic. Review the union of allowed relationships rather than assume the most restrictive-looking document wins automatically.

Cilium also supports explicit deny rules in its extended policy model. An applicable deny takes precedence over allow. This differs from treating policies as a simple ordered firewall file where the last line replaces earlier state. Check the selected endpoint, direction and matching deny relationship before explaining a rejected flow.

## Include Necessary Dependencies

An application may need DNS before reaching a named dependency. Allowing the dependency's application port while denying DNS can leave the request unable to determine an address. Observability, authentication and other runtime dependencies can also require narrow communication relationships. The solution is an explicit justified dependency, not an unrestricted egress exception added without analysis.

FQDN-aware policy relies on supported DNS observation and address handling. A name in application configuration does not automatically become a permanent network identity. Address changes, DNS responses and supported policy behavior need review. Preserve the difference between a logical hostname and the actual endpoint or external address currently used.

## Confirm Realization And Behavior

Kubernetes accepting the policy confirms storage and validation within its contract. The agent must still select endpoints and realize the relevant policy state. An allowed flow can then fail because routing, destination readiness or application authorization is broken. Use endpoint and flow evidence to identify the policy decision, and application evidence to assess useful service.

Interpret policy intent as a precise bounded relationship, then compare it with effective enforcement. That avoids broad changes based on a timeout whose cause has not been established.

## A Bounded Egress Declaration

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: checkout-to-database
  namespace: shop
spec:
  endpointSelector:
    matchLabels:
      app: checkout
  egress:
  - toEndpoints:
    - matchLabels:
        app: database
    toPorts:
    - ports:
      - port: "5432"
        protocol: TCP
```

This illustrative resource governs checkout endpoints in shop and permits the supported selected database relationship. It omits separate DNS and other dependencies, so it is not a complete application policy. The effective result still includes other applicable policies and the active enforcement mode.

## Common pitfalls

> [!WARNING]
> Selection and direction define the policy subject. Allowed policies combine, applicable denies take precedence, and network permission does not guarantee DNS, routing or application authorization.
