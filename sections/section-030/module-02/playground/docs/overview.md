---
draft: true
exam_objectives:
- Policy Enforcement Modes
---
# Playground Overview

Cilium manages a private two-node kind cluster. The `probe` Deployment and Service in `starfleet` listen on port 8080. The pod `shuttle` runs in `starfleet` and the pod `drifter` runs in `outpost`. No CiliumNetworkPolicy exists yet.

Use this environment with the reading pages of the module. Connect with `export KUBECONFIG="$(astrona kubeconfig ats-053-playground-030-02)"`. The Cilium agent runs as the DaemonSet `cilium` in `kube-system`, so run agent commands with `kubectl -n kube-system exec ds/cilium -- cilium-dbg ...`. The environment has no grading.
