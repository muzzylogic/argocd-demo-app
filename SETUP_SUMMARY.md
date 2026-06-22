# ArgoCD Demo Setup - Complete Summary

**Created:** June 22, 2026  
**Location:** `/home/vitas/dev/airflow_demo`  
**Status:** ✅ Ready for Demo

---

## 🎯 What's Been Set Up

Your ArgoCD demo environment is fully scaffolded with:

### 1. **Sample Application** (`argocd-demo-app/`)
A complete microservices demo app:
- **Backend**: Node.js/Express API with health checks
- **Frontend**: React web app that calls the backend
- **Kubernetes**: StatefulSet for backend, Deployment for frontend
- **Docker**: Production-ready multi-stage Dockerfiles

**Key Files:**
- `backend/server.js` - Express API with `/api/message`, `/health` endpoints
- `frontend/src/App.js` - React UI showing backend data
- `docker/backend.Dockerfile`, `docker/frontend.Dockerfile` - Container images
- `k8s/backend.yaml` - StatefulSet with 2 replicas, health checks
- `k8s/frontend.yaml` - Deployment with rolling update strategy

### 2. **ArgoCD Configuration** (`argocd-demo-config/`)
Production-ready ArgoCD setup:
- **Applications**: Two sample ArgoCD Applications
  - Manual sync version (default)
  - Auto-sync version (for comparison)
- **Config**: ArgoCD namespace and settings
- **Progressive Delivery**: Canary deployment example

**Key Files:**
- `argocd-config/namespace.yaml` - ArgoCD namespace
- `applications/app.yaml` - Main Application CRD (manual sync)
- `applications/progressive-delivery.yaml` - Advanced patterns example

### 3. **Automation Scripts** (`scripts/`)
Four executable bash scripts:
- `setup.sh` - Initial Minikube + ArgoCD installation (5 min)
- `build-images.sh` - Build Docker images in Minikube
- `demo.sh` - Interactive feature demonstration (12 features)
- `cleanup.sh` - Remove all demo resources

### 4. **Documentation** (Root level)
- `README.md` - Complete guide with features and demo scenarios
- `QUICKSTART.md` - 10-minute getting started guide
- `DEMO_CHECKLIST.md` - Feature checklist and talking points

---

## 📂 Directory Structure

```
/home/vitas/dev/airflow_demo/
│
├── README.md                    # Main guide
├── QUICKSTART.md                # Quick start (10 min)
├── DEMO_CHECKLIST.md            # Feature checklist for demos
├── .gitignore                   # Git ignore file
│
├── argocd-demo-app/             # Sample application repo
│   ├── README.md
│   ├── backend/
│   │   ├── server.js            # Node.js/Express API
│   │   └── package.json
│   ├── frontend/
│   │   ├── src/
│   │   │   ├── App.js           # React main component
│   │   │   ├── App.css
│   │   │   ├── index.js
│   │   │   └── index.css
│   │   ├── public/
│   │   │   └── index.html
│   │   └── package.json
│   ├── docker/
│   │   ├── backend.Dockerfile
│   │   └── frontend.Dockerfile
│   └── k8s/
│       ├── backend.yaml         # StatefulSet + Services
│       └── frontend.yaml        # Deployment + LoadBalancer Service
│
├── argocd-demo-config/          # ArgoCD configuration repo
│   ├── README.md
│   ├── argocd-config/
│   │   ├── namespace.yaml       # ArgoCD namespace
│   │   └── config.yaml          # ArgoCD settings
│   └── applications/
│       ├── app.yaml             # Main Application (manual & auto-sync)
│       └── progressive-delivery.yaml  # Advanced example
│
└── scripts/
    ├── setup.sh                 # Setup automation (5 min)
    ├── build-images.sh          # Build Docker images
    ├── demo.sh                  # Interactive demo (12 features)
    └── cleanup.sh               # Cleanup resources
```

---

## 🚀 Quick Start (Next 10 Minutes)

### Step 1: Run Setup
```bash
cd /home/vitas/dev/airflow_demo
./scripts/setup.sh
```
✅ Installs Minikube, ArgoCD, creates namespaces

### Step 2: Build Images
```bash
./scripts/build-images.sh
```
✅ Builds backend and frontend Docker images in Minikube

### Step 3: Deploy Application
```bash
kubectl apply -f argocd-demo-config/applications/app.yaml
```
✅ Creates ArgoCD Application resources

### Step 4: Access ArgoCD UI
```bash
kubectl port-forward -n argocd svc/argocd-server 8080:443 &
# Open: https://localhost:8080
# Username: admin
# Password: (printed by setup.sh)
```

### Step 5: Access Sample App
```bash
kubectl port-forward -n argocd-demo svc/frontend 3000:80 &
# Open: http://localhost:3000
```

---

## 📊 12 Features You Can Demo

1. **Application Status & Health** - Real-time deployment monitoring
2. **Git vs Cluster State** - Three-way diff comparison
3. **Manual Sync** - Controlled deployments with approval gates
4. **Auto-Sync** - True GitOps automation
5. **Drift Detection** - Enforce desired state automatically
6. **Health Monitoring** - Resource and pod health tracking
7. **History & Rollback** - One-click instant rollback
8. **Rolling Updates** - Zero-downtime deployments
9. **Resource Details** - Pod logs, YAML, debugging info
10. **Multi-Environment** - Dev/staging/prod from same repo
11. **Sync Waves** - Ordered deployments with dependencies
12. **Notifications** - Slack, email, webhook integrations

Run interactive demo:
```bash
./scripts/demo.sh
```

---

## 💡 Key Demo Scenarios

### Scenario 1: Git-Driven Deployment
```bash
# Edit manifest
sed -i 's/replicas: 2/replicas: 3/' argocd-demo-app/k8s/frontend.yaml

# Commit and push
git add .
git commit -m "Scale to 3 replicas"
git push

# ArgoCD detects → syncs → updates running pods
```

**Talking Point:** "Everything in Git. Change Git, change production. Every change audited."

### Scenario 2: Drift Detection
```bash
# Manual cluster change
kubectl scale deployment frontend -n argocd-demo --replicas=10

# ArgoCD detects it (shows out-of-sync)
# Self-heal fixes it automatically OR manual sync
argocd app sync argocd-demo-app
```

**Talking Point:** "Prevents configuration drift. Enforce desired state automatically."

### Scenario 3: Instant Rollback
```bash
# View history
argocd app history argocd-demo-app

# Rollback to previous version
argocd app rollback argocd-demo-app 0

# Pods update instantly (seconds, not hours)
```

**Talking Point:** "One command rollback. Works for any failure. Complete audit trail."

---

## 🎯 What Makes This a Great Demo

✅ **Complete end-to-end** - Frontend, backend, Kubernetes, ArgoCD  
✅ **Production-like** - Health checks, rolling updates, StatefulSets  
✅ **GitOps principles** - Git as source of truth  
✅ **Real features** - Not just toy examples  
✅ **Multiple demo paths** - Quick (5 min), Standard (15 min), Deep-dive (30 min)  
✅ **Automation scripts** - No manual setup errors  
✅ **Documentation** - Easy to hand off or train others  
✅ **Sellable features** - All 12 core ArgoCD capabilities  

---

## 🔧 Troubleshooting

### Minikube won't start
```bash
minikube delete
minikube start --cpus=4 --memory=8192 --driver=docker
```

### ArgoCD not ready
```bash
kubectl rollout status deployment/argocd-application-controller -n argocd
kubectl get pods -n argocd
```

### Images won't build
```bash
eval $(minikube docker-env)
./scripts/build-images.sh
```

### Application won't sync
```bash
# Check logs
kubectl logs -n argocd -l app=argocd-application-controller

# Try force sync
argocd app sync argocd-demo-app --force
```

Full troubleshooting guide in `README.md`

---

## 📚 Documentation Files

| File | Purpose | Audience |
|------|---------|----------|
| `README.md` | Complete feature guide & scenarios | Technical leads, architects |
| `QUICKSTART.md` | 10-minute getting started | Anyone running the demo |
| `DEMO_CHECKLIST.md` | Feature checklist & talking points | Demo practitioners |
| `DEMO_CHECKLIST.md` | Fallback plans & time budget | Demo practitioners |

---

## 🎓 Learning Resources

Inside the repo:
- `argocd-demo-app/README.md` - Application architecture
- `argocd-demo-config/README.md` - ArgoCD configuration details
- Extensive comments in all YAML files

External:
- [ArgoCD Official Docs](https://argo-cd.readthedocs.io)
- [GitOps Best Practices](https://www.gitops.tech)
- [Argo Project](https://argoproj.github.io)

---

## 🎤 Sales Talking Points

**Problem:** "How do you deploy 100 times a day safely?"  
**Solution:** "GitOps with ArgoCD - Git is your deployment system."

**Key Benefits:**
- ✅ **Audit Trail** - Every change in Git commits
- ✅ **Zero-Downtime Rollback** - Fix production in seconds
- ✅ **Prevent Configuration Drift** - Enforce desired state
- ✅ **Multi-Cluster Ready** - Manage 1 or 100 clusters
- ✅ **Developer Friendly** - Use Git, not kubectl
- ✅ **Enterprise Ready** - RBAC, SSO, audit logging
- ✅ **Open Source** - No vendor lock-in
- ✅ **Cloud Native** - Works with any Kubernetes

---

## ✅ Pre-Demo Checklist

Before showing to a customer:

- [ ] Run setup: `./scripts/setup.sh`
- [ ] Build images: `./scripts/build-images.sh`
- [ ] Deploy app: `kubectl apply -f argocd-demo-config/applications/app.yaml`
- [ ] Verify ArgoCD UI loads: `https://localhost:8080`
- [ ] Verify sample app loads: `http://localhost:3000`
- [ ] Check both pods are running: `kubectl get pods -n argocd-demo`
- [ ] Have git repository ready to push changes
- [ ] Have browser windows arranged (ArgoCD UI + git repo)
- [ ] Test one manual change to verify workflow
- [ ] Review DEMO_CHECKLIST.md for talking points

---

## 🧹 Cleanup

When done:
```bash
./scripts/cleanup.sh
```

Or keep running for additional demos:
```bash
# To reuse, just:
./scripts/cleanup.sh --keep-argocd
# Then redeploy app
```

---

## 📞 Next Steps

1. **Immediate:** Run `./scripts/setup.sh` to get Minikube ready
2. **Practice:** Run through `./scripts/demo.sh` once before showing customer
3. **Customize:** Update Git repo URLs in `applications/app.yaml`
4. **Extend:** Add more services/environments to expand demo scope
5. **Close:** Have PoC proposal ready to send after demo

---

**You're all set! This demo showcases ArgoCD's core value proposition:**

> "Git as your deployment system. Automated, audited, rollback-ready."

Good luck with your demo! 🚀

---

*Created with ❤️ for ArgoCD product demos*
