---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Reading And Changing An Endpoint Identity

This part reads the identity of two endpoints, changes a label, and reads the identity again. It shows the link between labels and identities with real data. The playground has no network policy, so you only observe.

## Connect to the playground

The first command points `kubectl` at the private cluster. The second command prints the current kubectl context so that you can confirm the cluster.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-020-01)"
kubectl config current-context
```

The context must be `kind-astro-ats-053-playground-020-01`. Do not continue in a different context.

## Read the identity from the CiliumEndpoint

The agent publishes one `CiliumEndpoint` resource for each pod. Its status holds the identity number and the identity labels. The command below prints the identity of `shuttle`.

```sh
kubectl -n starfleet get ciliumendpoint shuttle -o jsonpath='{.status.identity}'
```

The result is a JSON object with an `id` field and a `labels` list. The list contains labels with the source prefix, such as `k8s:app=shuttle` and the namespace label `k8s:io.kubernetes.pod.namespace=starfleet`. The exact number differs between clusters, so this page does not print it.

Read the same object for `drifter` in `outpost`.

```sh
kubectl -n outpost get ciliumendpoint drifter -o jsonpath='{.status.identity}'
```

The two pods have different numbers. They differ in `app` and in the namespace label.

## List all identities

The cluster stores each identity as a `CiliumIdentity` resource. Its name is the identity number, and its labels are in `security-labels`. The agent can also list identities with its own command.

```sh
kubectl get ciliumidentities
kubectl -n kube-system exec ds/cilium -- cilium-dbg identity list
```

The first command shows the identities allocated in the cluster. The second command shows the identities that the agent knows, including the reserved identities with small numbers. Compare the labels of one entry with the labels of the pod it belongs to.

## Change a label and observe the identity

Add a label to `drifter`. The label `team=bridge` is a new label that is not on the exclusion list, so it counts.

```sh
kubectl -n outpost label pod drifter team=bridge
kubectl -n outpost get ciliumendpoint drifter -o jsonpath='{.status.identity}'
```

The second command may show the old identity for a short time, because the agent needs a moment to allocate or find the identity for the new label set. Run it again after a few seconds. The `id` is now different, and the labels include `k8s:team=bridge`.

Now add a label that Cilium ignores. The label `pod-template-hash` is on the exclusion list.

```sh
kubectl -n outpost label pod drifter pod-template-hash=abc
kubectl -n outpost get ciliumendpoint drifter -o jsonpath='{.status.identity}'
```

The identity `id` does not change this time, and the labels list does not contain `pod-template-hash`. Remove both labels to return to the start state.

```sh
kubectl -n outpost label pod drifter team- pod-template-hash-
```

## Compare two pods that share labels

Pods with the same relevant labels share one identity. The Deployment `probe` in `starfleet` runs pods that all carry `app=probe`. Print the identity of every `probe` endpoint with a custom column list.

```sh
kubectl -n starfleet get ciliumendpoints -o custom-columns=NAME:.metadata.name,ID:.status.identity.id
```

Every endpoint that belongs to the `probe` Deployment shows the same number in the ID column. The `shuttle` endpoint shows a different number. If you scale the Deployment, the new endpoints join the existing number.

```sh
kubectl -n starfleet scale deployment probe --replicas=2
kubectl -n starfleet get ciliumendpoints -o custom-columns=NAME:.metadata.name,ID:.status.identity.id
kubectl -n starfleet scale deployment probe --replicas=1
```

The second pod is listed with the same identity number as the first one, even though it has a different name and a different IP address. This is the effect that makes identity-based rules stable when pods change.

## What this part showed

An identity number follows the relevant label set. A new relevant label gives a new identity, and an excluded label gives none. The `CiliumEndpoint` resource and the `cilium-dbg identity list` command show the same facts from two sides.

## Common pitfalls

> [!WARNING]
> The identity may need a few seconds to change after a label change. Do not copy identity numbers between clusters, because the numbers are allocated per cluster. Excluded labels never change the identity.
