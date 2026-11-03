---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Default Deny Control And Rollout

Audit mode works per endpoint and needs an agent command. Sometimes the team wants a policy object that carries the allow rules in advance and that does not change enforcement yet. Cilium supports this with the `enableDefaultDeny` field. This part explains the field and combines it with audit mode into a rollout order.

## The enableDefaultDeny field

A CiliumNetworkPolicy or CiliumClusterwideNetworkPolicy can set `spec.enableDefaultDeny` with two booleans, `ingress` and `egress`. Both default to `true`, which is the normal behaviour: a policy with a section for a direction turns on default deny for that direction.

When a direction is set to `false`, the policy does not turn on default deny for it. The rules of that direction are still stored, and they apply when another policy turns on enforcement for the same endpoint. If nothing else enforces, the endpoint stays open, and the rules do not restrict anything.

```yaml
spec:
  enableDefaultDeny:
    ingress: false
```

## Why this field exists

Some policies should add permissions without closing anything. A clusterwide policy that allows an entity for all endpoints is an example: it must not put every endpoint into default deny just because it has an ingress section. The field gives the author control over that side effect.

The field is also a rollout tool. A team can apply the full set of allow rules with `enableDefaultDeny` set to `false`, check that they are complete, and later switch the field to `true`. The switch is one change, and it is the moment where enforcement starts.

## Apply a policy that does not enforce

Renew the playground and connect. Then apply a policy with the `shuttle` rule and `enableDefaultDeny.ingress` set to `false`.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-030-02)"
kubectl config current-context
```

Save this as `ciliumnetworkpolicy-observe-shuttle.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: observe-shuttle
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
  enableDefaultDeny:
    ingress: false
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: shuttle
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
```

Apply it:

```sh
kubectl apply -f ciliumnetworkpolicy-observe-shuttle.yaml
```

Then check the result. Both clients still reach the probe, because ingress enforcement is not on.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
kubectl -n outpost exec drifter -- python -c "import urllib.request; print(urllib.request.urlopen('http://probe.starfleet.svc:8080/',timeout=4).read().decode())"
```

Both requests print `probe-ready`. The endpoint list of the agent that hosts the probe shows the ingress enforcement column as `Disabled`.

## Switch to enforcement

Change the field to `true` and apply the file again. Edit the file, so that the spec has `ingress: true`, or remove the `enableDefaultDeny` block, and apply it.

```sh
kubectl apply -f ciliumnetworkpolicy-observe-shuttle.yaml
```

After the agent realizes the change, the request from `drifter` times out and the request from `shuttle` still prints `probe-ready`.

## A rollout order

A staged rollout has five steps. First, write the policy with all allow rules the team knows. Second, apply it with `enableDefaultDeny` set to `false` for the directions to protect, or with audit mode on the endpoints. Third, collect audit events or Hubble flows for a full application cycle. Fourth, add rules for each flow that is wanted. Fifth, switch to enforcement for one workload and watch for drops, then repeat for the next workload.

The two tools overlap. Audit mode reports what would be dropped, and `enableDefaultDeny: false` does not enforce at all, so it does not report. Use audit mode when you need the report, and use the field when you need to carry the rules in advance.

## Rolling back

Rollback is the reverse step. Set the field back to `false` or delete the policy that enforces. Deleting the last policy with an ingress section turns the flag off, and the endpoint becomes open. Keep the rollback command written down before enforcement starts, because an outage is a bad time to look for it.

## What this part showed

The `enableDefaultDeny` field decouples storing allow rules from turning on enforcement. Together with audit mode, it gives a rollout that moves from reporting to enforcement one workload at a time. A rollback is a single field change or a policy delete.

## Common pitfalls

> [!WARNING]
> A policy with `enableDefaultDeny` set to `false` protects nothing by itself. Another policy that selects the same endpoint for the same direction can still turn enforcement on, and then the stored rules apply. Do not delete the last enforcing policy during a rollback unless you want the endpoint open.
