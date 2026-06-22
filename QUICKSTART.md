# ArgoCD Demo - Quick Start Guide

## 🚀 Get Started in 10 Minutes

### Step 1: Initial Setup (5 minutes)
```bash
cd /home/vitas/dev/airflow_demo

# Run the automated setup
./scripts/setup.sh
```

This will:
- ✅ Start Minikube
- ✅ Install ArgoCD
- ✅ Create demo namespaces
- ✅ Print ArgoCD login credentials

### Step 2: Build Container Images (3 minutes)
```bash
# Build backend and frontend images in Minikube
./scripts/build-images.sh
```

### Step 3: Deploy the Application (2 minutes)
```bash
# Apply the ArgoCD Application resource
kubectl apply -f argocd-demo-config/applications/app.yaml

# Verify it was created
kubectl get app -n argocd
```

### Step 4: Access the Demo
```bash
# Open ArgoCD UI in browser
kubectl port-forward -n argocd svc/argocd-server 8080:443 &

# Open https://localhost:8080 in your browser
# Login with credentials shown during setup
```

```bash
# Forward frontend service (optional)
kubectl port-forward -n argocd-demo svc/frontend 3000:80 &

# Access app at http://localhost:3000
```

## 📊 Running the Interactive Demo

```bash
./scripts/demo.sh
```

This guide walks through 12 key ArgoCD features:

1. **Application Sync Status** - Real-time deployment status
2. **Git vs Cluster State** - Continuous comparison
3. **Manual Sync** - Controlled deployments
4. **Auto Sync** - True GitOps automation
5. **Health Monitoring** - Resource health tracking
6. **History & Rollback** - Instant deployment rollback
7. **Multi-Environment** - Managing multiple environments
8. **Sync Waves** - Ordered deployments
9. **Three-Way Diff** - State comparison
10. **Progressive Delivery** - Canary/Blue-green patterns
11. **Notifications** - Integration with external systems
12. **RBAC & Security** - Enterprise access control

## 🎯 Key Demo Scenarios

### Scenario 1: Show Git-Driven Deployments
```bash
# Edit k8s manifest
vi argocd-demo-app/k8s/frontend.yaml
# Change replicas: 2 → replicas: 3

# Commit and push
git add .
git commit -m "Scale frontend to 3 replicas"
git push

# Manually sync (or auto-sync will do it)
argocd app sync argocd-demo-app

# 👉 Show how change appears in cluster
kubectl get deployment -n argocd-demo
```

**Talking point:** "Everything is in Git. Change Git, change production. Audit trail included."

### Scenario 2: Demonstrate Drift Detection
```bash
# Make a manual cluster change (simulate drift)
kubectl scale deployment frontend -n argocd-demo --replicas=10

# Show it in ArgoCD UI - it shows out-of-sync
# Or via CLI:
argocd app get argocd-demo-app

# Sync to fix it
argocd app sync argocd-demo-app

# 👉 Show drift is resolved
kubectl get deployment -n argocd-demo
```

**Talking point:** "ArgoCD enforces the desired state. Manual changes get corrected automatically."

### Scenario 3: Show Instant Rollback
```bash
# View history
argocd app history argocd-demo-app

# Make a bad change and sync
kubectl set env deployment frontend -n argocd-demo BAD_VAR=true --record

# Show it's broken (or just simulate)
# Rollback with one command:
argocd app rollback argocd-demo-app 0

# 👉 Show it's instantly fixed
kubectl get deployment -n argocd-demo
```

**Talking point:** "Rollback takes seconds, not hours. One command fixes everything."

### Scenario 4: Multi-Cluster Management
```bash
# Show application resources (can point to different clusters)
kubectl get app -n argocd -o wide

# With multiple ArgoCD instances or federated setup:
# Same source repo, multiple clusters getting deployed automatically
```

**Talking point:** "Manage deployments across multiple Kubernetes clusters from one place."

## 📋 Useful Commands Reference

```bash
# View all applications
argocd app list
kubectl get app -A

# Get detailed status
argocd app get argocd-demo-app
kubectl describe app argocd-demo-app -n argocd

# Sync operations
argocd app sync argocd-demo-app          # Manual sync
argocd app sync argocd-demo-app --prune  # With resource cleanup

# Rollback
argocd app rollback argocd-demo-app 0    # Rollback to revision 0
argocd app history argocd-demo-app       # View history

# Diff
argocd app diff argocd-demo-app          # Show Git vs Live differences

# Watch
watch argocd app get argocd-demo-app     # Monitor application changes
watch kubectl get pods -n argocd-demo    # Monitor pods

# Logs
kubectl logs -n argocd -l app=argocd-application-controller
kubectl logs -n argocd-demo -l app=backend
kubectl logs -n argocd-demo -l app=frontend
```

## 🎨 Customization

### Update Git Repository URL
Edit `argocd-demo-config/applications/app.yaml`:
```yaml
source:
  repoURL: https://github.com/your-username/argocd-demo-app
  # Change this to point to your own repo if hosting on GitHub
```

### Update Docker Registry
Edit `argocd-demo-app/k8s/frontend.yaml` and `backend.yaml`:
```yaml
image: your-registry/argocd-demo-frontend:1.0.0  # Update registry
```

### Enable Auto-Sync
Uncomment in `argocd-demo-config/applications/app.yaml`:
```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

## 🔍 Troubleshooting

**Q: Can't connect to ArgoCD UI**
```bash
# Check if port-forward is running
kubectl port-forward -n argocd svc/argocd-server 8080:443

# Check if ArgoCD is ready
kubectl get pods -n argocd
```

**Q: Application shows "Unknown" health**
```bash
# Check application status
kubectl describe app argocd-demo-app -n argocd

# Check if namespace exists
kubectl get ns argocd-demo

# Check pod status
kubectl get pods -n argocd-demo
```

**Q: Image pull errors**
```bash
# Ensure images are built with Minikube Docker
./scripts/build-images.sh

# Update imagePullPolicy to IfNotPresent
# in k8s/frontend.yaml and backend.yaml
```

## 🧹 Cleanup

```bash
# Remove all demo resources
./scripts/cleanup.sh

# Or manually:
kubectl delete app -n argocd argocd-demo-app
kubectl delete ns argocd-demo
```

## 💡 Sales & Presentation Tips

**Open with:** "Let me show you how to reduce deployment errors and cut deployment time in half."

**Key Value Props:**
- ✅ Git is your deployment documentation
- ✅ Zero-downtime rollbacks
- ✅ Prevent configuration drift
- ✅ Audit every change
- ✅ Works across any number of clusters
- ✅ Developers use familiar Git workflows

**Close with:** "This reduces deployment risk, improves compliance, and enables faster innovation. Questions?"

---

Happy demoing! 🎉
