---
draft: true
exam_objectives:
- Policy Rule Structure
---
# HTTP And DNS Rules

A Layer 4 rule can allow port 8080 to a client, and the client may then call every path and method of the application. Often the requirement is narrower: one path, one method, or a fixed set of names. Cilium can enforce these Layer 7 rules, because it sends the traffic through a proxy that understands the protocol. This part covers HTTP rules and DNS rules.

## How Layer 7 enforcement works

A rule with a `rules` block under `toPorts` tells the agent to redirect the matching traffic to a proxy. For HTTP, the proxy is Envoy, which runs in the agent or next to it, depending on the installation. Envoy reads each request, compares it with the rules, and either forwards it or answers with an error.

The Layer 3 and Layer 4 parts of the rule are still enforced in the kernel. The kernel decides whether the flow may reach the proxy. The proxy then decides about the content. A Layer 7 rule needs the proxy to be healthy, and it adds latency compared with a plain port rule.

## HTTP rules

An HTTP rule lives in `toPorts[].rules.http`, a list. Each item may have `method`, `path`, `host` and `headers`. The `method`, `path` and `host` values are extended POSIX regular expressions. If a field is omitted, all values match for that field. A path must begin with `/`.

Fields in one item are joined with AND, and items in the list are joined with OR. The rule below allows only `GET` requests to `/public`.

```yaml
toPorts:
- ports:
  - port: "8080"
    protocol: TCP
  rules:
    http:
    - method: GET
      path: /public
```

Because a path is a regular expression, `/public/.*` allows everything below `/public/`. Escape special characters when you mean a literal character, and prefer a narrow expression.

## What the client sees

A request that does not match a Layer 7 rule is answered by the proxy with HTTP status 403, which means access denied. A request that is dropped by a Layer 3 or Layer 4 rule gets no answer, so the client waits until its own timeout. This difference is a reliable way to tell the two cases apart from the client side.

## Apply and test an HTTP rule

Renew the playground and connect. Then apply a policy that allows `shuttle` to send `GET` requests to `/public` of the `probe` pods.

<!-- astrona:playground:renew -->

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-playground-040-02)"
kubectl config current-context
```

Save this as `ciliumnetworkpolicy-http-public.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: http-public
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: shuttle
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
      rules:
        http:
        - method: GET
          path: /public
```

Apply it:

```sh
kubectl apply -f ciliumnetworkpolicy-http-public.yaml
```

Then check the result. The request to `/public` passes the proxy, and the request to `/private` is answered with status 403, which Python reports as an HTTP error.

```sh
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/public',timeout=4).read()"
kubectl -n starfleet exec shuttle -- python -c "import urllib.request; urllib.request.urlopen('http://probe.starfleet.svc:8080/private',timeout=4).read()"
```

The second command ends with an error that contains `403`. The probe application may answer the first request with its own status, such as 404 for a path it does not serve. That is an application answer and not a policy decision, and the point of the test is that the `/private` request never reaches the application.

## DNS rules

A DNS rule lives under `toPorts[].rules.dns` and filters the queries that an endpoint may send. It has `matchName` for one exact name and `matchPattern` for a pattern. In a pattern, the wildcard `*` matches zero or more valid DNS characters except the dot. The pattern `*.example.com` matches `sub.example.com` and does not match `example.com`. A pattern that is only `*` matches all names.

A DNS rule goes into an egress rule that allows the DNS service on port 53. The agent then runs a DNS proxy that sees each query and each answer.

## toFQDNs

A `toFQDNs` egress rule allows connections to the addresses that the DNS proxy has seen in answers for the named domains. It has `matchName` and `matchPattern` fields too. The rule has no effect without the DNS rule that lets the proxy see the answers.

The DNS rule and the `toFQDNs` rule do different jobs. The DNS rule decides which names a pod may look up. The `toFQDNs` rule decides to which addresses the pod may connect afterwards. A pod can look up a name that the DNS rule allows and still fail to connect, if no `toFQDNs` rule selects that name.

## Kubernetes names need their own rule

In a cluster, the lookups of cluster names must also pass the DNS rule. A name such as `probe.starfleet.svc.cluster.local` must match a pattern such as `*.*.svc.cluster.local.`. A short name like `probe` is completed by the search list of the pod, and the completed name must be allowed as well.

## What this part showed

HTTP rules filter by method, path and host through a proxy, and a request that does not match gets status 403. DNS rules filter lookups, and `toFQDNs` rules allow connections to the addresses that the lookups returned. Both are Layer 7 features and depend on the proxy in the agent. The next part adds deny rules.

## Common pitfalls

> [!WARNING]
> A path is a regular expression, so a path that omits the end can match more than you intend. A `toFQDNs` rule without a DNS rule allows nothing. A client timeout means a Layer 3 or Layer 4 drop, and status 403 means a Layer 7 rule answered.
