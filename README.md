# ArgoCD Demo - Complete Setup & Feature Guide

## Overview

This demo showcases ArgoCD as a production-grade GitOps continuous deployment solution. It includes:

- **Sample Application**: A web app with frontend (React) and backend (Node.js)
- **ArgoCD Setup**: Complete configuration for deploying with GitOps
- **Interactive Demo**: Step-by-step feature demonstration script
- **Two Git Repositories**: Separated concerns (app code vs deployment config)

## Quick Start

### Prerequisites

- Minikube (or any Kubernetes cluster)
- Docker
- kubectl
- git

### Setup (5 minutes)

```bash
cd /home/vitas/dev/airflow_demo

# 1. Make scripts executable
chmod +x scripts/*.sh

# 2. Run setup
./scripts/setup.sh

# 3. Build images (for local Minikube)
./scripts/build-images.sh

# 4. Create the application
kubectl apply -f argocd-demo-config/applications/app.yaml

# 5. Access ArgoCD UI
kubectl port-forward -n argocd svc/argocd-server 8080:443 &
```

Login to ArgoCD:
- URL: `https://localhost:8080`
- Username: `admin`
- Password: (printed during setup)

## Repository Structure

```
/home/vitas/dev/airflow_demo/
├── argocd-demo-app/          # Sample application repo
│   ├── backend/               # Node.js express server
│   ├── frontend/              # React application
│   ├── docker/                # Dockerfiles
│   ├── k8s/                   # Kubernetes manifests
│   └── README.md
│
├── argocd-demo-config/        # ArgoCD configuration repo
│   ├── argocd-config/         # ArgoCD setup
│   ├── applications/          # Application CRDs
│   ├── environments/          # Env-specific configs
│   └── README.md
│
├── scripts/
│   ├── setup.sh               # Initial setup
│   ├── demo.sh                # Interactive demo
│   ├── build-images.sh        # Build Docker images
│   └── cleanup.sh             # Cleanup resources
│
└── README.md                  # This file
```

## Key Features to Demonstrate

### 1. **Application Health & Sync Status**
Show real-time status of deployment in ArgoCD UI:
```bash
# View application status
kubectl get app -n argocd
argocd app list
```

**Demo talking points:**
- ArgoCD constantly monitors application health
- Shows sync status between Git and cluster
- Color-coded indicators (green=synced, yellow=out-of-sync, red=error)

### 2. **Manual vs Auto Sync**

**Manual Sync** - Controlled deployments:
```bash
# Change Application to manual sync
kubectl patch app argocd-demo-app -n argocd --type merge \
  -p '{"spec":{"syncPolicy":{"automated":null}}}'

# Manually sync when ready
argocd app sync argocd-demo-app --prune
```

**Auto Sync** - True GitOps:
```bash
# Edit git repo, push changes
# ArgoCD automatically syncs within 3 minutes (or faster with webhooks)
```

**Demo talking points:**
- Manual provides control and safety gates
- Auto sync enables true continuous deployment
- Can combine with other tools for approval workflows

### 3. **Git-Driven Deployments**
Make a change in git and watch it deploy:

```bash
# In argocd-demo-app/k8s/frontend.yaml
# Change replicas: 2 → replicas: 5

git commit -am "Scale frontend to 5 replicas"
git push

# Watch ArgoCD detect and apply the change (manual sync required)
argocd app sync argocd-demo-app --prune
```

**Demo talking points:**
- All changes tracked in Git (audit trail)
- Declarative configuration
- GitOps workflow (PRs for approvals, git hooks, etc.)

### 4. **Drift Detection & Remediation**
Demonstrate self-healing:

```bash
# Make cluster change (drift from git)
kubectl scale deployment frontend -n argocd-demo --replicas=10

# Watch ArgoCD detect drift
kubectl describe app argocd-demo-app -n argocd | grep "Sync Status"

# Auto-sync will fix it, or manually sync
argocd app sync argocd-demo-app
```

**Demo talking points:**
- ArgoCD detects when cluster differs from Git
- Self-heal flag continuously enforces desired state
- Prevents configuration drift
- Provides security and compliance

### 5. **Rollback & History**
Show instant rollback capability:

```bash
# View deployment history
argocd app history argocd-demo-app

# Rollback to previous revision
argocd app rollback argocd-demo-app 1

# Or from UI: Application → History → Click revision → Rollback
```

**Demo talking points:**
- Complete deployment history
- Instant rollback (seconds, not minutes)
- No need for blue-green infrastructure
- Works with any Kubernetes resource

### 6. **Multi-Environment Management**
Show managing multiple environments:

```bash
# Applications in different namespaces/clusters
kubectl get app -n argocd

# Same source repo, different overlays
argocd-demo-app/
├── k8s/
│   ├── base/
│   └── overlays/
│       ├── dev/
│       ├── staging/
│       └── prod/
```

**Demo talking points:**
- DRY (Don't Repeat Yourself) with overlays
- Different settings per environment
- Consistent deployment process
- Easy to add new environments

### 7. **Resource Health Monitoring**
Show application resource health:

```bash
# Check pod status
kubectl get pods -n argocd-demo

# ArgoCD shows aggregate health
argocd app get argocd-demo-app
```

**Demo talking points:**
- Monitors all resources (Deployments, StatefulSets, Services, etc.)
- Custom health rules supported
- Failed resources highlighted
- Health checks from readiness probes

### 8. **Sync Waves - Ordered Deployments**
Demonstrate deployment ordering:

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"  # Deploy in order
```

**Demo talking points:**

### 9. **Three-Way Diff**
Compare states:

```bash
# Git vs Cluster vs Last Applied
argocd app diff argocd-demo-app
```

**Demo talking points:**
- See exactly what changed
- Compare across three views
- Understand drift at a glance

## Advanced Features (Optional)

### Progressive Delivery with Argo Rollouts
```bash
# Deploy canary or blue-green via Argo Rollouts
# (Requires Argo Rollouts installation)
```

### Webhooks & GitOps Integration
```bash
# GitHub webhooks for instant sync (instead of 3-min polling)
# Configure in ArgoCD settings
```

### RBAC & Multi-Tenancy
```bash
# Projects provide namespace and repository isolation
# Fine-grained access control
```

## Demo Script Flow

Run the interactive demo:
```bash
./scripts/demo.sh
```

This walks through all features with explanations and hands-on commands.

## Troubleshooting

### Application not syncing
```bash
# Check application status
kubectl describe app argocd-demo-app -n argocd

# View application logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller
```

### Cannot connect to backend
```bash
# Ensure backend pod is running
kubectl get pods -n argocd-demo

# Check logs
kubectl logs -n argocd-demo -l app=backend
```

### Image pull errors
```bash
# Build and use local images with Minikube
./scripts/build-images.sh

# Update k8s manifests to use local images
# Change imagePullPolicy: IfNotPresent
```

## Cleanup

Remove all demo resources:
```bash
./scripts/cleanup.sh
```

## Further Reading

- **ArgoCD Documentation**: https://argo-cd.readthedocs.io
- **GitOps Best Practices**: https://www.gitops.tech
- **Argo Project**: https://argoproj.github.io

## Sales Talking Points

✅ **"Single Source of Truth"** - Git is the authoritative configuration source  
✅ **"Audit Trail"** - Every change tracked in Git commits  
✅ **"Instant Rollback"** - Seconds, not hours  
✅ **"Multi-Cluster Ready"** - Manage multiple Kubernetes clusters  
✅ **"Developer Friendly"** - Simple Git workflows, no kubectl needed  
✅ **"Enterprise Ready"** - RBAC, SSO, audit logging  
✅ **"Open Source"** - Community-driven, no vendor lock-in  
✅ **"Cloud Native"** - Works with any Kubernetes distribution  

---

**Questions?** Refer to the feature explanations above or check ArgoCD documentation.
