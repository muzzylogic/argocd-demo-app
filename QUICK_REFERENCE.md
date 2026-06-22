# ArgoCD Demo - Quick Reference Card

## 📍 Location
```
/home/vitas/dev/airflow_demo
```

## 🚀 Quick Commands

### Initial Setup (One Time)
```bash
cd /home/vitas/dev/airflow_demo
./scripts/setup.sh              # 5 min: Minikube + ArgoCD
./scripts/build-images.sh       # 2 min: Build Docker images
kubectl apply -f argocd-demo-config/applications/app.yaml  # 1 min: Deploy
```

### Accessing the Demo
```bash
# ArgoCD UI
kubectl port-forward -n argocd svc/argocd-server 8080:443 &
# https://localhost:8080 (admin / password from setup)

# Sample App
kubectl port-forward -n argocd-demo svc/frontend 3000:80 &
# http://localhost:3000
```

### Running the Demo
```bash
./scripts/demo.sh               # Interactive 12-feature demo
```

### Useful Commands During Demo
```bash
# View application status
kubectl get app -n argocd
argocd app list
argocd app get argocd-demo-app

# Manual sync
argocd app sync argocd-demo-app
argocd app sync argocd-demo-app --prune --force

# Rollback
argocd app history argocd-demo-app
argocd app rollback argocd-demo-app 0    # Rollback to revision 0

# Diff
argocd app diff argocd-demo-app

# Watch for changes
watch kubectl get pods -n argocd-demo
watch argocd app get argocd-demo-app

# View logs
kubectl logs -n argocd-demo -l app=backend
kubectl logs -n argocd-demo -l app=frontend
kubectl logs -n argocd -l app=argocd-application-controller
```

## 📊 12 Features to Demo

1. **Application Status** → Show UI dashboard
2. **Git vs Live State** → Run `argocd app diff`
3. **Manual Sync** → Click sync button or run `argocd app sync`
4. **Auto-Sync** → Show app.yaml config
5. **Drift Detection** → `kubectl scale` → watch detection
6. **Health Monitoring** → Show pod status in UI
7. **Rollback** → `argocd app rollback`
8. **Rolling Updates** → `watch kubectl get pods`
9. **Resource Details** → Show logs/YAML in UI
10. **Multi-Environment** → Show overlays structure
11. **Sync Waves** → Show annotations in YAML
12. **Notifications** → Show config in config.yaml

## 📁 Key Files

| File | Purpose |
|------|---------|
| `README.md` | Complete feature guide |
| `QUICKSTART.md` | 10-minute guide |
| `PROJECT_OVERVIEW.md` | This project overview |
| `DEMO_CHECKLIST.md` | Feature checklist |
| `argocd-demo-app/k8s/backend.yaml` | Backend deployment |
| `argocd-demo-app/k8s/frontend.yaml` | Frontend deployment |
| `argocd-demo-config/applications/app.yaml` | ArgoCD Applications |
| `scripts/setup.sh` | Setup automation |
| `scripts/demo.sh` | Interactive demo |

## 🎤 Elevator Pitch

> "ArgoCD is Git-based continuous deployment. It treats Git as the source of truth and keeps your cluster in sync automatically. One-click rollback, zero-downtime updates, complete audit trail. All from Git."

## 🎯 Demo Flow (15 min)

1. **Show Status** (2 min) - ArgoCD dashboard
2. **Make Change** (2 min) - Edit git, commit, push
3. **Show Sync** (2 min) - ArgoCD detects and syncs
4. **Demonstrate Rollback** (3 min) - Roll back to previous
5. **Show Drift** (2 min) - Manual change, auto-fix
6. **Q&A** (5 min+)

## 💰 Business Benefits

- ✅ Faster deployments (minutes vs hours)
- ✅ Safer rollback (seconds vs days)
- ✅ Audit trail (compliance)
- ✅ Prevents drift (configuration management)
- ✅ Reduces ops toil (automation)
- ✅ Developer self-service (no ops team gating)

## 🔧 Troubleshooting

| Problem | Solution |
|---------|----------|
| Minikube won't start | `minikube delete && minikube start` |
| ArgoCD not ready | `kubectl get pods -n argocd` and wait |
| Images not found | `./scripts/build-images.sh` |
| App won't sync | `argocd app sync --force` or check logs |
| Port-forward fails | Kill old process: `pkill port-forward` |

## 📞 Next Steps After Demo

1. Answer technical questions
2. Discuss their use case
3. Send QUICKSTART.md
4. Propose 2-week PoC
5. Schedule technical deep-dive
6. Discuss ArgoCD Pro/Enterprise features

## 🧹 Cleanup

```bash
./scripts/cleanup.sh             # Remove demo resources
```

---

**Print this page and keep it handy during your demo!**

Last Updated: June 22, 2026
