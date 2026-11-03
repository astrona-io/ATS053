---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Prerequisites

Use `astrona`, `kubectl`, kind, Podman, Helm, curl and Python 3. The task runs in its own private kind cluster. 

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials that `kubectl`, the Kubernetes command-line tool, uses.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-053-capstone-020-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-053-capstone-020-01" || exit 1
```

