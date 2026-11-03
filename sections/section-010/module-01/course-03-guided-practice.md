---
draft: true
exam_objectives:
- Interpret Cilium Network Polices and Intent
---
# Apply And Test An Ingress Policy

Reading a policy gives you a prediction. Testing it with real requests tells you whether the prediction is right. In this part you predict the result of a policy, apply it, and check both the allowed and the denied request.

The playground has no policy at the start. The `probe` Service in `starfleet` answers every client. The `shuttle` pod in `starfleet` and the `drifter` pod in `outpost` can both reach it. Each client runs Python, so the requests below use the Python standard library instead of `curl`.

## Connect to the playground

The first command points `kubectl` at the private kind cluster. The second command prints the kubectl context, so you can confirm that you work in the playground and not in another cluster.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-010-01)"
kubectl config current-context
```

The context name is `kind-astro-ats-053-playground-010-01`. If it shows a different name, stop and fix the `KUBECONFIG` variable before you apply anything.

## Check the baseline

Before a policy exists, both clients reach the `probe` Service. The application in the `probe` pod answers `probe-ready` on the path `/`, so a successful request prints that word.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
```

Both commands print `probe-ready`. The second one uses the full Service name `probe.starfleet.svc`, because `drifter` is in another namespace.

## Predict, then apply

The policy below selects `probe`, so `probe` enters default deny for ingress. It allows only endpoints of the `starfleet` namespace, on TCP port 8080. Predict the result before you apply it: `shuttle` is in `starfleet` and should still work, and `drifter` is in `outpost` and should time out.

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
      - port: "8080"
        protocol: TCP
```

Apply it:

```sh
kubectl apply -f ciliumnetworkpolicy-allow-shuttle.yaml
```

The Kubernetes API server stores the object. The Cilium operator and agents watch the object, and each agent compiles it into the kernel rules of the endpoints it selects. This takes a short time, so wait a few seconds before you test.

## Check that the agent realized the policy

Accepting the object is not the same as enforcing it. The command below asks the agent on the nodes for its endpoint list. The columns include the ingress and the egress policy enforcement state of each endpoint.

```sh
kubectl -n kube-system exec ds/cilium -- cilium-dbg endpoint list
```

Find the endpoint of the `probe` pod. Its ingress policy enforcement column shows `Enabled`. The `shuttle` endpoint stays `Disabled`, because no policy selects it. The command runs in one agent pod, so it lists only the endpoints on that node. The `probe` pod may be on the other node; run the command again against the other agent pod if you do not see it. This output is not printed here because the identifiers change on every start.

## Test the allowed and the denied request

Run each request separately. The denied request ends with an error after its timeout, and a shell that stops on the first error would hide the second test.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=3).read()"
```

The first request prints `probe-ready`. The second request fails after three seconds with an error that contains `timed out`. The agent dropped the packets silently, so the client gets no rejection message. A timeout, not a refusal, is the normal sign of a Layer 3 or Layer 4 policy drop.

## Change the prediction

Apply the policy again with the port changed from `"8080"` to `"9090"`. Predict first: the namespace still matches, but the port no longer does, so `shuttle` should now time out as well. This shows that the peer and the port in one rule are joined with AND. Change the port back to `"8080"` and apply the file again to restore the first behaviour.

You have now seen the whole loop: read, predict, apply, confirm that the agent realized the policy, and test with requests that should pass and requests that should fail. The next step is the graded task, which asks you to build such a policy on your own.

## Common pitfalls

> [!WARNING]
> A timeout and a refusal are different results. Layer 3 and Layer 4 drops produce timeouts. Test after the agent has realized the policy. Test the allowed and the denied request separately, and check the kubectl context before every change.
