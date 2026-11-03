---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Reading And Changing The Mode

A policy that behaves in an unexpected way can have a simple reason: the cluster runs in a different mode than the author assumed. This part shows where the mode is set, how to read it from the running agent, and what changes when a cluster runs in `always` mode.

## Where the mode is set

The mode belongs to the Cilium agent, so it applies to every endpoint on every node that runs that agent configuration. An installation sets it with the Helm value `policyEnforcementMode`. Helm is the package manager for Kubernetes, and Cilium ships a chart. The chart writes the value into the agent configuration map as `enable-policy`.

The agent reads the value when it starts. A change in the configuration map therefore takes effect only after the agent pods restart. A rollout restart of the `cilium` DaemonSet in `kube-system` restarts them one node at a time.

## Read the mode from the cluster

Renew the playground and connect. Then read the value from the configuration map that the agent uses. The map is named `cilium-config` in `kube-system`.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-030-01)"
kubectl -n kube-system get configmap cilium-config -o jsonpath='{.data.enable-policy}'
```

The command prints the mode name. In the playground it is `default`. An empty result means the chart did not set the value, and the agent uses its built-in default, which is also `default`.

## Read the state of each endpoint

The mode is global, but the flags are per endpoint. The agent lists them. Run the command against the agent pod, and read the two enforcement columns.

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg endpoint list
```

In `default` mode with no policy, both columns show `Disabled` for the workload endpoints. After a policy selects an endpoint for ingress, its ingress column shows `Enabled`, and its egress column stays `Disabled` unless a policy with an egress section selects it as well. The command shows only the endpoints on the node of the chosen agent, so run it on the node that hosts the pod you check.

## What `always` mode does to cluster services

In `always` mode, the pods of the cluster services are also in default deny. This includes CoreDNS, which answers name lookups, and the pods of other system components. Without explicit rules, these services cannot receive requests, and the clients cannot send them.

The host is treated separately. Cilium allows traffic from the local node to local endpoints by default, so kubelet health probes keep working in `always` mode. The ingress to endpoints from other nodes and the egress from endpoints to anything still need rules.

A cluster that moves to `always` mode therefore needs a baseline of policies first: DNS egress for every workload, ingress to the DNS service from every workload, and rules for each system component that carries traffic. A clusterwide policy is the right tool for the baseline, because it is one object for every namespace.

## Safe ways to move to a stricter mode

Switching a running cluster directly to `always` drops traffic that no rule allows. The safer path has three steps. First, write the baseline and the application policies while the mode is `default`. Second, check the flows with the agent monitor and Hubble for flows that are forwarded only because the endpoint is open. Third, switch the mode in a maintenance window and watch for drops.

Audit mode also covers a similar need for single endpoints: it reports what a policy would drop without dropping it.

## The mode and the other policy kinds

The mode applies to all policy kinds: CiliumNetworkPolicy, CiliumClusterwideNetworkPolicy and Kubernetes NetworkPolicy. In `never` mode, none of them is enforced. In `always` mode, endpoints without any policy deny all traffic regardless of which kind would have selected them.

## A worked example of the baseline

A baseline for `always` mode has at least two clusterwide policies. The first allows egress from every endpoint to the DNS pods on port 53. The second allows ingress to the DNS pods from every endpoint on port 53. Each policy is a CiliumClusterwideNetworkPolicy with an `endpointSelector` that selects the subject and a rule for the DNS peer.

Application policies then add the rules for each service. Because the baseline exists, an application policy does not need to repeat the DNS rule. Cilium builds the allowed set from the union of all policies that select an endpoint, so the baseline and the application rules add up.

## Failure cases to expect

After a move to `always` mode, the first symptom is usually a name resolution error in applications. Pods cannot send a lookup to the DNS service, so every request by name fails, even if the destination is allowed. Drop events from the agent show the lookups as dropped.

The second symptom is a pod that cannot be reached from another node. The host rule covers only the local node, so a request from a pod on another node needs an explicit ingress rule.

## Checking the result of a change

After the agents restart in a new mode, check the mode again with the same configuration map command, and check the endpoint list on at least one agent. In `always` mode, every workload endpoint shows both columns as `Enabled`. If a column still shows `Disabled`, the agent on that node has not restarted yet or it reads a different configuration.

Then send one request that a rule allows and one that no rule allows. The first must succeed and the second must time out. Evidence from both sides is the proof that enforcement works as intended.

## Operating notes

Keep the old and new values of the mode in the change record, because a wrong mode is hard to guess later. The mode is global, so it affects every team that shares the cluster. Tell those teams before the change.

## Per-endpoint overrides

The agent can also change the enforcement option of a single endpoint for tests. The option is part of the endpoint configuration that `cilium-dbg endpoint config` shows. Such a change lasts only until the endpoint is recreated, so it is a debugging tool and not a way to run a cluster.

## What this part showed

The mode is a startup setting of the agent that the Helm chart writes as `enable-policy`. The endpoint list shows the per-direction flags that follow from the mode and the policies. A move to `always` needs a baseline for DNS and system services first. The next part applies a policy and checks the flags.

## Common pitfalls

> [!WARNING]
> A change to the mode needs an agent restart before it applies. The mode `always` also puts cluster services such as DNS into default deny. Do not switch a shared cluster to `always` before the baseline policies exist.
