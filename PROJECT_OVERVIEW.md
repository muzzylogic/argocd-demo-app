# Project Overview

## Top-level structure

- [argocd-demo-app](argocd-demo-app): demo application code + manifests
- [argocd-demo-config](argocd-demo-config): ArgoCD `Application` resources and config
- [scripts](scripts): setup, build, demo, cleanup automation
- Markdown guides in repo root

## Deployment model

1. Build images in Minikube Docker daemon
2. ArgoCD watches Git repository for manifests
3. ArgoCD syncs desired state to cluster
4. Demo shows sync, drift correction, and rollback

## Key files

- [argocd-demo-app/k8s/backend.yaml](argocd-demo-app/k8s/backend.yaml)
- [argocd-demo-app/k8s/frontend.yaml](argocd-demo-app/k8s/frontend.yaml)
- [argocd-demo-config/applications/app.yaml](argocd-demo-config/applications/app.yaml)
- [scripts/setup.sh](scripts/setup.sh)
- [scripts/build-images.sh](scripts/build-images.sh)
- [scripts/demo.sh](scripts/demo.sh)
