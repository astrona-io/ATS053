---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Summary

A CiliumNetworkPolicy states its subject in `endpointSelector`, its direction in `ingress` or `egress`, its peers in the `from` and `to` fields and its traffic in `toPorts`. The direction is relative to the subject, so an ingress rule names the source as its peer and an egress rule names the destination.

A peer is an endpoint selected by labels, an entity such as `world` or `cluster`, a CIDR block for external addresses, or a name for external destinations. Endpoint selectors use `matchLabels` and `matchExpressions`, and the namespace label limits or widens the match.

Ports are strings with a protocol and an optional `endPort`. Inside one rule all fields must match. Inside one list any item may match. Rules and policies add up, and a rule without ports allows every port for its peers.

Key facts:

- The field `nodeSelector` is valid only in a clusterwide policy.
- A namespace-only selector allows every pod in the namespace.
- A port written as a number is rejected because the field is a string.
- A rule can only add permissions, never remove them.

<!-- astrona:playground:destroy -->
