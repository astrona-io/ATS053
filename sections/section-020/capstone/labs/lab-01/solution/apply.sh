#!/usr/bin/env bash
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-053-capstone-020-01" ]]; then
  printf 'Refusing to operate on another Kubernetes context\n' >&2
  exit 1
fi
lab_directory="$(cd "$(dirname "$0")/.." && pwd)"
solution_directory="$lab_directory/solution"
kubectl -n starfleet label pod shuttle team=bridge --overwrite
kubectl -n outpost label pod drifter team=bridge --overwrite
kubectl apply -f "$solution_directory/ciliumclusterwidenetworkpolicy-allow-bridge-team-everywhere.yaml"
