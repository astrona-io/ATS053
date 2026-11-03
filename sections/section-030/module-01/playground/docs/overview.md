---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Guided Practice: Observe Default Enforcement On Selected Endpoints

Use a host shell with the private kubeconfig for this module playground. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-030-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-playground-030-01" || exit 1
node_name="astro-ats-053-playground-030-01-control-plane"
worker_name="astro-ats-053-playground-030-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Inspect And Explain

Cilium manages the private two-node cluster. Hubble Relay and the BGP control plane are enabled. The probe and two clients are healthy; no learner policy or evidence report exists. This baseline uses kube-proxy and tunnelling.

Inspect the current objects before changing them:

```sh
kubectl -n starfleet get pods -o wide
kubectl get nodes -o wide
```

Keep global enable-policy at default and apply an ingress-selecting policy. Verify both permitted and denied traffic; never mode would invalidate this result.

Save this as `ciliumnetworkpolicy-allow-shuttle.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: allow-shuttle
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
  ingress:
  - fromEndpoints:
    - matchLabels:
        k8s:io.kubernetes.pod.namespace: starfleet
    toPorts:
    - ports:
      - port: '8080'
        protocol: TCP
```

Apply the scoped correction:

```sh
kubectl apply -f ciliumnetworkpolicy-allow-shuttle.yaml
```

## Verify The Result

Observe the actual result. A denied request returns a nonzero status when the denial works, so run it separately from a shell sequence that stops on error. Status convergence and a successful request establish different parts of the result.

```sh
kubectl -n starfleet exec shuttle -- python -c 'import urllib.request; print(urllib.request.urlopen('"'"'http://probe:8080/'"'"',timeout=4).read().decode())'
kubectl -n outpost exec drifter -- python -c 'import urllib.request; urllib.request.urlopen('"'"'http://probe.starfleet.svc:8080/'"'"',timeout=3).read()'
```

Permit the trusted client while denying the untrusted client. The commands above deliberately target one environment. Keep its remaining components available so an unrelated failure cannot stand in for the required denial or correction. No example command output is presented as evidence of a completed run. A matching field alone does not establish that a process used it or that a controller reconciled it.


## Common pitfalls

> [!WARNING]
> Confirm the private context and exact node names before a change. Check the stated scope and live result. Do not change unrelated components to hide the original fault.
