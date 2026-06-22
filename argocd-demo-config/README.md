# ArgoCD Configuration

This repository contains the ArgoCD Application manifests and configurations for managing the sample application deployment using GitOps principles.

## Repository Structure

- `applications/` - ArgoCD Application CRDs
- `argocd-config/` - ArgoCD server configuration
- `environments/` - Environment-specific configurations (dev, staging, prod)
- `README.md` - This file

## Key ArgoCD Concepts

### 1. **Auto Sync vs Manual Sync**
- Applications can auto-sync changes from git (automatic deployment)
- Or manual sync for more controlled rollouts
- See `applications/auto-sync-app.yaml` vs `applications/manual-sync-app.yaml`

### 2. **Health & Sync Status**
- ArgoCD continuously monitors application health
- Shows diffs between desired (git) and actual (cluster) state
- Health checks based on Kubernetes resource status

### 3. **Sync Waves**
- Deploy resources in specific order using sync waves
- Useful for DB migrations before app deployments
- Example: `metadata.annotations.argocd.argoproj.io/sync-wave`

### 4. **Progressive Delivery**
- Canary deployments
- Blue-green deployments
- See `applications/progressive-delivery.yaml`

### 5. **Multi-Environment Management**
- Different configurations per environment
- Kustomize or ConfigMap overlays
- See `environments/` folder

## Quick Setup

```bash
# 1. Create ArgoCD namespace and install ArgoCD
kubectl apply -f argocd-config/namespace.yaml
kubectl apply -f argocd-config/install.yaml

# 2. Create the Application resource
kubectl apply -f applications/app.yaml

# 3. Access ArgoCD UI
kubectl port-forward -n argocd svc/argocd-server 8080:443

# 4. Login (default: admin, get password from secret)
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Demo Script

### Feature 1: Auto Sync
- Show app syncing automatically when git changes
- Modify image tag in git, watch ArgoCD detect and sync

### Feature 2: Manual Sync & Undo
- Set app to manual sync
- Make changes, manually sync
- Use ArgoCD UI to rollback to previous revision

### Feature 3: Health Monitoring
- Show resource health status in UI
- Demonstrate failed pod handling

### Feature 4: Multi-Replica Updates
- Show rolling updates with 0 downtime
- Watch pods terminate and recreate

### Feature 5: History & Rollback
- Access deployment history
- Rollback to specific revision via ArgoCD UI

## Command Cheatsheet

```bash
# Get all Application resources
kubectl get applications -A

# Describe an application
kubectl describe app argocd-demo-app -n argocd

# Manual sync
argocd app sync argocd-demo-app

# Force sync (ignore cache)
argocd app sync argocd-demo-app --force

# Get app status
argocd app get argocd-demo-app

# Rollback to previous revision
argocd app rollback argocd-demo-app 1

# Watch application sync
watch kubectl get app argocd-demo-app -n argocd
```

