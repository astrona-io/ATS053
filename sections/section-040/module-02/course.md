---
draft: true
exam_objectives:
- Policy Rule Structure
---
# Application, DNS And Deny Rules

Layer 3 and Layer 4 rules decide by identity and port. Many requirements go further: allow one HTTP path and not another, allow queries for some names, or block one client that a broad rule would otherwise allow. This module covers the Layer 7 rules for HTTP and DNS and the deny rules, with the order in which Cilium applies them.

The module uses a private playground with the `probe` Service and the `shuttle` pod in `starfleet` and the `drifter` pod in `outpost`. The playground has no policy at the start.

## Learning Goals

- Write an HTTP rule with a method and a path and predict the response to a request that does not match.
- Write DNS and `toFQDNs` rules and explain why they depend on each other.
- Write a deny rule and explain why it wins over every allow rule.
- State the limits of deny rules and of Layer 7 rules.

## Before You Start

You need to read the fields of a CiliumNetworkPolicy, including peers and `toPorts`, and to know that allow rules add up. You need `kubectl` and the `astrona` command.

The module has two parts. The first part covers HTTP and DNS rules. The second part covers deny rules and precedence. A summary closes the module.

<!-- astrona:playground -->
