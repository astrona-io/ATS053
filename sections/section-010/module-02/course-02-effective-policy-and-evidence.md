---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Effective Policy And Evidence

When a request fails, the YAML you wrote is only one suspect. The policy may select different pods than you intended, another policy may add or remove access, the agent may not have realized the change yet, or the application itself may be at fault. This part shows how to collect evidence from the Cilium agent so that you decide on facts.

The tool for this is `cilium-dbg`, the command line interface that is built into every Cilium agent pod. You run it with `kubectl exec` against the agent pod of the node that hosts the pod you investigate.

## Find the agent that hosts the pod

Every node has one agent pod. The `-o wide` output of `kubectl get pods` shows the node of each pod, and the same output for the agent pods shows which agent runs on which node.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-010-02)"
kubectl -n starfleet get pods -o wide
kubectl -n kube-system get pods -l k8s-app=cilium -o wide
```

Match the NODE column of the `probe` pod with the NODE column of an agent pod. Use that agent pod name in the commands below. The command `kubectl -n kube-system exec ds/cilium` picks one agent pod of the DaemonSet, which may be the wrong node. Use the explicit pod name when it matters.

## List endpoints and their enforcement state

The agent keeps one record per endpoint. The list shows the endpoint number, the security identity, the labels, and whether policy enforcement is on for ingress and for egress.

```sh
kubectl -n kube-system exec <AGENT_POD> -- cilium-dbg endpoint list
```

Replace `<AGENT_POD>` with the pod name you found. For each endpoint, the ingress and egress policy enforcement columns tell you whether a policy selects it in that direction. An endpoint with enforcement `Disabled` in a direction allows all traffic in that direction. An endpoint with `Enabled` allows only what the realized rules allow. This directly tests your reading of "which endpoints does the policy select".

## Read the realized rules of one endpoint

The endpoint number from the list identifies one endpoint. The command below prints the labels of the policies that the agent derived the rules for. The expression is the one the Cilium troubleshooting guide uses for the ingress direction.

```sh
kubectl -n kube-system exec <AGENT_POD> -- cilium-dbg endpoint get <ENDPOINT_ID> -o jsonpath='{range ..status.policy.realized.l4.ingress[*].derived-from-rules}{@}{"\n"}{end}'
```

Each printed line is a set of rule labels such as the policy name and namespace. Pass those labels to `cilium-dbg policy get` to print the policy rule that produced them. Repeat with `egress` instead of `ingress` for the other direction. The output is not shown here, because the endpoint numbers and revisions differ in every cluster.

If a policy you applied does not appear in this list for the endpoint, the agent did not select that endpoint with the policy. The problem is then the selector, the namespace or the labels, and not the network.

## Watch drops as they happen

The agent can report dropped packets. The command below streams only drop events from that agent and stops when you press Control and C. Run it in one terminal, and send the failing request from another terminal.

```sh
kubectl -n kube-system exec <AGENT_POD> -- cilium-dbg monitor --type drop
```

A drop event names the source and destination endpoint and the reason. A line that says the packet was dropped because of policy confirms that Cilium policy caused the failure. If the request fails and no drop event appears, the cause is not a Cilium policy decision on that node.

## Hubble verdicts

Hubble is the Cilium observability layer. It records each flow with a verdict: `FORWARDED`, `DROPPED` or, in audit mode, `AUDIT`. The playground enables Hubble Relay, so the `hubble observe` command from a machine with the Hubble client can list recent flows, for example with `--verdict DROPPED`. A dropped flow shows the source, destination, port and the policy direction.

Use drop evidence in this order. Find the drop, read the source and destination identity, find the policies that select the destination, and compare the rules with the request. A failure with no drop points to routing, the application or a missing service endpoint.

## Worked example of reading the evidence

Suppose the request from `drifter` to `probe` times out, and the intent was that `drifter` is allowed. Start with the drop stream on the agent of the node that hosts `probe`, and send the request again. If a drop event appears, read its source identity and its destination identity, and compare the source identity with the identities in the `identity list` output. If the source identity is the identity of `drifter`, policy dropped the request in the direction named in the event.

Next, read the enforcement state of the `probe` endpoint. If ingress shows `Enabled`, read the realized rules and look for a rule that matches the identity of `drifter` and TCP port 8080. If no such rule exists, the selector in the policy does not match `drifter`, and the fix is the selector, for example a missing namespace label.

If no drop event appears at all, the policy is not the cause. The request may fail because the Service has no ready endpoints, because the name does not resolve, or because the application is not listening. Check those causes before you edit any policy.

## Egress evidence

The same method works for egress. A drop event from the `drifter` endpoint to the DNS pods on port 53 shows that the lookup was dropped, even if the policy allows the destination. The enforcement columns of the `drifter` endpoint show whether egress is enforced. The realized egress rules show which destinations and ports the agent allows.

## What the evidence cannot tell you

The agent shows the state of one node at one moment. A policy that was applied a second ago may not be realized yet, and an endpoint that was recreated has a new number. Repeat a check after a short wait before you trust a negative result. Repeat the whole method after every change.

## Keeping a record

Write down each check and its result as you go. A record of the commands, the agent that answered, and the time makes it possible to compare the state before and after a change.

## A short method

First, reproduce the failure with one request. Second, check the drop stream. Third, check the enforcement state of both endpoints. Fourth, read the realized rules. Fifth, change one thing, wait for the agent, and test again. Changing several things at once destroys the evidence.

You can now read what the agent enforces instead of what you meant to write. The rest of the course builds on this method for identities, enforcement modes and rule types.

## Common pitfalls

> [!WARNING]
> An agent shows only the endpoints on its own node. Check the policy status after the agent realized the change, not before. Do not widen a policy to fix a timeout until a drop event or the enforcement state shows that policy is the cause.
