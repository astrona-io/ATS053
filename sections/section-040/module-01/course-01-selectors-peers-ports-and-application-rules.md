---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Selectors, Peers, Ports And Application Rules

A policy document contains fields with different roles. Some select the endpoint being governed, some describe the other side of communication, and others constrain protocol or operation. Reading the fields in that order helps avoid reversing the policy's subject and peer or assuming that one address mechanism has every identity property.

## Subject And Direction

The endpointSelector identifies the managed workload endpoints to which a rule applies. Ingress describes traffic entering those endpoints; egress describes traffic leaving them. A namespaced CiliumNetworkPolicy has a namespace context, while CiliumClusterwideNetworkPolicy supports broader scope and additional supported selection patterns.

Within an ingress relationship, fromEndpoints identifies allowed source endpoints. Within egress, toEndpoints identifies destination endpoints. The labels in those peer selectors do not replace the subject selector. A policy can govern checkout and allow database peers, or govern database and allow checkout sources; these are related but distinct enforcement points.

## Peer Mechanisms Have Different Meaning

Endpoint selectors use managed workload labels. Entities represent documented classes such as particular host or external contexts. CIDR rules describe address ranges. FQDN rules connect supported DNS observations and resulting destination addresses to a logical name policy. Choose the mechanism that fits the peer and its lifecycle.

An external IP range is not proof of application identity, and a DNS name does not automatically authenticate the server. Certificate validation or another application mechanism can supply that assurance. A broad entity or range may permit more endpoints than a narrow workload label relationship, so review its actual scope.

## Add Transport Constraints

Port rules constrain a supported protocol and destination port. A TCP port and the corresponding UDP port are different relationships. DNS can require both supported transport forms depending on traffic behavior. Application dependency access also needs correct direction and destination selection.

A rule's peer and port fields work together according to the policy's documented structure. Separate peer entries can describe alternatives, while nested constraints within one relationship narrow that alternative. Do not import an intuitive English and-or interpretation without checking the field structure.

## Layer 7 Adds Operation Context

Supported application rules can constrain HTTP methods, paths or other protocol-specific behavior. They rely on the implementation's application-aware processing path, often involving a proxy. Encrypted application payloads cannot be interpreted merely because the network sees their packets; termination or another supported visibility arrangement matters.

A workload allowed to open TCP to a server may still be denied a particular HTTP operation by Layer 7 policy. Conversely, a matching application rule cannot repair a missing route or incorrect Service backend. Diagnose protocol and transport relationships separately.

## Denies And Other Policies Matter

The effective result includes other applicable allowed relationships and supported explicit denies. A broad allow elsewhere can expand an allow-only boundary, while an applicable deny takes precedence. Namespace labels, reserved contexts and host-related paths can alter which relationships actually match.

Compare the desired rule with endpoint labels, enforcement mode and realized policy. Then inspect the relevant connection and application operation. Acceptance of the YAML demonstrates only the resource contract; useful enforcement needs supported prerequisites and correct interpretation of the complete applicable rule set.

Cilium explicit deny rules have supported scope limits: they do not express Layer 7 URL-specific denies or FQDN-specific denies. Do not turn an application allow example into a deny example by merely changing a field name. Use the documented model for the exact relationship.

## Common pitfalls

> [!WARNING]
> Subject selectors and peer selectors serve different roles. FQDNs and CIDRs do not authenticate application identity, and Layer 7 rules require a supported protocol-processing path.
