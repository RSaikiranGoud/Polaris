# Polaris — Kubernetes security audit starter

This repository provides a deployable [Fairwinds Polaris](https://github.com/FairwindsOps/polaris) dashboard and a GitHub Actions audit for sample Kubernetes manifests. It uses the upstream Polaris engine; it is not a fork or reimplementation.

## Requirements

- Kubernetes cluster and configured `kubectl`
- Helm 3
- Docker (only for running the CI audit command locally)

## Install the dashboard

```bash
bash scripts/install.sh
kubectl -n polaris get svc
```

For local dashboard access, identify the dashboard service and port from `kubectl -n polaris get svc`, then run `kubectl port-forward` against that service. The Helm values do not enable public ingress or admission enforcement.

## Audit a sample workload

```bash
docker run --rm -v "$PWD/deploy:/manifests:ro" \
  us-docker.pkg.dev/fairwinds-ops/oss/polaris:v10.2.0 \
  polaris audit --audit-path /manifests --format=pretty
```

The GitHub Actions workflow runs this audit on commits to `main` and on pull requests. Inspect the results and adjust policies before applying them to production workloads.

## Repository structure

- `helm-values.yaml`: dashboard Helm settings; admission webhook disabled
- `scripts/install.sh`: install or upgrade Polaris in namespace `polaris`
- `deploy/example.yaml`: example deployment with baseline security controls
- `config/polaris.yaml`: placeholder for optional policy configuration
- `.github/workflows/polaris-audit.yml`: manifest audit CI
- `.gitignore`: local secret and temporary file exclusions

## Security notes

- Do not expose the dashboard to the internet without proper access controls.
- Review permissions, workload exemptions, and compliance checks before enabling any admission controls.
- Pin and review image, chart, and action versions as part of your change management.
- Passing an audit does not certify your cluster as secure.

## Attribution

Powered by the open-source Fairwinds Polaris project. Refer to the [upstream project](https://github.com/FairwindsOps/polaris) for its license and documentation.
