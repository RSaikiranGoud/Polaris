#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm repo update
kubectl create namespace polaris --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install polaris fairwinds-stable/polaris \
  --namespace polaris --values helm-values.yaml --wait
kubectl -n polaris get pods,svc
