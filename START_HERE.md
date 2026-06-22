# START HERE - ArgoCD Demo Setup

This repository contains a local ArgoCD demo on Minikube.

## Fast Start

```bash
cd /home/vitas/dev/airflow_demo
./scripts/setup.sh
./scripts/build-images.sh
kubectl apply -f argocd-demo-config/applications/app.yaml
```

Then open ArgoCD:

```bash
kubectl port-forward -n argocd svc/argocd-server 8080:443
```

URL: https://localhost:8080

## What to Read

1. [QUICKSTART.md](QUICKSTART.md)
2. [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
3. [DEMO_CHECKLIST.md](DEMO_CHECKLIST.md)
4. [ADVANCED_SCENARIOS.md](ADVANCED_SCENARIOS.md)

## Important Note

The Application manifest uses placeholder `repoURL` values. Replace them in [argocd-demo-config/applications/app.yaml](argocd-demo-config/applications/app.yaml) before expecting ArgoCD to sync/deploy.
