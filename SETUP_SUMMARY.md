# Setup Summary

## What is included

- Sample app repository: [argocd-demo-app](argocd-demo-app)
  - Backend (Node.js)
  - Frontend (React)
  - Kubernetes manifests
  - Dockerfiles
- ArgoCD config repository: [argocd-demo-config](argocd-demo-config)
  - Application manifests
  - ArgoCD namespace/config examples
- Scripts: [scripts](scripts)
  - `setup.sh`
  - `build-images.sh`
  - `build-images-variants.sh`
  - `setup-hostname.sh`
  - `setup-git-webhook.sh`
  - `demo.sh`
  - `cleanup.sh`

## Verified setup flow

```bash
./scripts/setup.sh
./scripts/build-images.sh
kubectl apply -f argocd-demo-config/applications/app.yaml
```

## Common blockers

1. Placeholder repo URL in app manifests
2. Image names in k8s manifests not matching local built images
3. Minikube ingress/hosts not configured for custom hostname

## Main docs

- [README.md](README.md)
- [QUICKSTART.md](QUICKSTART.md)
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- [DEMO_CHECKLIST.md](DEMO_CHECKLIST.md)
- [ADVANCED_SCENARIOS.md](ADVANCED_SCENARIOS.md)
