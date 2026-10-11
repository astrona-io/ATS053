---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Default, Always And Never Policy Enforcement

An enforcement mode establishes when policy enforcement applies to endpoints. It is different from the content of one allow or deny rule. Cilium supports default, always and never modes, with direction-specific behavior and additional per-policy controls. Understanding those relationships is necessary before interpreting an unrestricted endpoint or planning a policy rollout.

## Default Mode Starts From Selection

In the default mode, ordinary endpoints initially have unrestricted access under that mode until applicable policy introduces enforcement. A rule selecting an endpoint with ingress content can move ingress into default deny, while egress is considered independently. An ingress restriction does not universally imply the same egress restriction.

Once a direction is isolated, the applicable allowed relationships determine permitted traffic, with supported deny precedence where relevant. A policy that selects the wrong labels may leave the intended endpoint outside that transition. Review realized endpoint enforcement, not just the presence of a policy object in a namespace.

## Always Mode Changes The Baseline

Always enables enforcement for endpoints even without a policy selecting each one. That can create a stronger default boundary, but required communication needs explicit support. DNS, health checking, management and application dependencies can be affected if their relationships are not allowed.

The mode does not mean that every application automatically has a suitable least-privilege policy. It establishes a baseline that the rule set must make operationally coherent. A broad allow added solely to recover connectivity can erase much of the intended boundary. Inventory dependencies before changing the baseline.

## Never Mode Disables The Described Enforcement

Never disables endpoint policy enforcement under that mode even if policy rules select the endpoints. Policies can remain stored while their expected protection is not active. A reviewer reading YAML without checking agent configuration can therefore overstate the effective boundary.

Other controls, such as application authentication or infrastructure filtering, can still operate. Their presence does not mean the Cilium endpoint policy is enforcing. State which mechanism provides the observed protection rather than attribute every denied connection to the policy object.

## Per-Policy Default-Deny Control Has Limits

The enableDefaultDeny setting can influence whether a policy contributes to the default-deny transition for a direction. This can support selected observation-oriented policy patterns. It is not a universal switch that makes every constraint non-enforcing.

Layer 7 rules have additional behavior: a restricted application-layer allow can cause drops even when default deny is disabled. A DNS observation policy or HTTP restriction must therefore be interpreted under the documented protocol and proxy semantics. Avoid promising an observe-only rollout based on one field without checking those limits.

## Plan Changes Through Dependencies

Suppose a service's egress is isolated but its database uses a DNS name. The policy may allow the database relationship while omitting access to the resolver, causing failure before the connection is attempted. Identify both name resolution and destination traffic. Health endpoints and node-related paths can introduce similar separate dependencies.

Review mode, selectors, directions, allowed and denied relationships, and realized endpoint state together. Observe the affected connection scope before adjusting rules. A timed-out application request may reflect enforcement, routing or destination behavior; the mode explains only part of that path.

## Common pitfalls

> [!WARNING]
> Stored policy is not proof of active enforcement. Default deny is direction-specific, and disabling its transition does not universally make Layer 7 constraints non-enforcing.
