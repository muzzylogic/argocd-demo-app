# ArgoCD Demo - Project Overview

```
📦 /home/vitas/dev/airflow_demo (624K, 87 files)
│
├── 📄 README.md                           ← START HERE: Complete feature guide
├── 📄 QUICKSTART.md                       ← 10-minute quick start guide
├── 📄 DEMO_CHECKLIST.md                   ← Feature checklist & talking points
├── 📄 SETUP_SUMMARY.md                    ← This project summary
├── 📄 .gitignore
│
├── 📁 argocd-demo-app/                    🎯 SAMPLE APPLICATION REPO
│   ├── 📄 README.md
│   │
│   ├── 📁 backend/                        Node.js/Express API
│   │   ├── 📄 server.js                   ← Express app with /api/message, /health
│   │   └── 📄 package.json                ← Dependencies: express, cors
│   │
│   ├── 📁 frontend/                       React Web App
│   │   ├── 📄 package.json
│   │   ├── 📁 src/
│   │   │   ├── 📄 App.js                  ← Main React component (calls backend)
│   │   │   ├── 📄 App.css                 ← Styled UI with gradient header
│   │   │   ├── 📄 index.js                ← React entry point
│   │   │   └── 📄 index.css               ← Global styles
│   │   └── 📁 public/
│   │       └── 📄 index.html              ← HTML template
│   │
│   ├── 📁 docker/                         Container Definitions
│   │   ├── 📄 backend.Dockerfile          ← Alpine Node 18, multi-stage
│   │   └── 📄 frontend.Dockerfile         ← React build + serve
│   │
│   └── 📁 k8s/                            Kubernetes Manifests
│       ├── 📄 backend.yaml                ← StatefulSet (2 replicas, ConfigMap)
│       └── 📄 frontend.yaml               ← Deployment (2 replicas, LoadBalancer)
│
├── 📁 argocd-demo-config/                 🎯 ARGOCD CONFIGURATION REPO
│   ├── 📄 README.md                       ← ArgoCD concepts & demo guide
│   │
│   ├── 📁 argocd-config/
│   │   ├── 📄 namespace.yaml              ← Creates 'argocd' namespace
│   │   └── 📄 config.yaml                 ← ArgoCD settings & defaults
│   │
│   └── 📁 applications/
│       ├── 📄 app.yaml                    ← TWO Applications:
│       │                                     - Manual sync version (default)
│       │                                     - Auto-sync version (demo)
│       └── 📄 progressive-delivery.yaml   ← Advanced patterns example
│
└── 📁 scripts/                            🎯 AUTOMATION & DEMOS
    ├── 📄 setup.sh                        ← 🚀 Start here: Setup in 5 min
    │                                        Installs Minikube, ArgoCD, creates NS
    │
    ├── 📄 build-images.sh                 ← Build Docker images in Minikube
    │                                        Creates argocd-demo-backend:1.0.0
    │                                        Creates argocd-demo-frontend:1.0.0
    │
    ├── 📄 demo.sh                         ← 📺 Interactive demo (12 features)
    │                                        Walks through: sync status, rollback,
    │                                        auto-sync, drift detection, etc.
    │
    └── 📄 cleanup.sh                      ← 🧹 Remove all demo resources
                                             (With confirmation)
```

---

## 🎬 How to Use This Demo

### Setup Phase (First Time)
```
1. Run: ./scripts/setup.sh
   → Starts Minikube + installs ArgoCD
   → Takes ~5 minutes
   
2. Run: ./scripts/build-images.sh
   → Builds backend + frontend images in Minikube
   → ~2 minutes
   
3. Deploy: kubectl apply -f argocd-demo-config/applications/app.yaml
   → Creates ArgoCD Application resources
   → ~1 minute to ready
```

### Demo Phase (For Customer)
```
1. Show ArgoCD UI: https://localhost:8080
   → Show application status, health, sync state
   
2. Show sample app: http://localhost:3000
   → Shows frontend calling backend API
   
3. Run: ./scripts/demo.sh
   → Walks through 12 features
   → Each with talking points and hands-on examples
```

### Practice Phase
```
1. Edit git (k8s manifests)
2. Commit + push
3. Watch ArgoCD sync automatically
4. Demonstrate rollback
5. Show drift detection
```

---

## 🎯 Feature Coverage

This demo showcases all 12 core ArgoCD features:

| # | Feature | File | Demo Command |
|---|---------|------|--------------|
| 1 | Application Status | UI | Show app card in Dashboard |
| 2 | Git vs Live State | UI/CLI | argocd app diff |
| 3 | Manual Sync | UI/CLI | Click Sync or argocd app sync |
| 4 | Auto-Sync | YAML | applications/app.yaml (auto-sync version) |
| 5 | Drift Detection | CLI | kubectl scale → watch detection |
| 6 | Health Monitoring | UI | Pod status in Resources tab |
| 7 | Rollback | UI/CLI | argocd app rollback |
| 8 | Rolling Updates | Watch | kubectl get pods -n argocd-demo -w |
| 9 | Resource Details | UI | Click pod → view logs/YAML |
| 10 | Multi-Environment | YAML | applications/ folder structure |
| 11 | Sync Waves | YAML | annotations: sync-wave |
| 12 | Notifications | YAML | argocd-config/config.yaml |

---

## 🎤 Key Talking Points

### Opening
"Let me show you how to deploy code 100 times a day safely and predictably."

### Feature 1-2: Git-Driven Everything
"Git is your deployment system. Every change tracked, audited, reversible."

### Feature 3-4: Control vs Automation
"You choose: manual gates for safety, or auto-sync for speed. Both available."

### Feature 5-7: Reliability & Recovery
"Automatic drift detection. Instant rollback. Never stuck in bad state."

### Feature 8-10: Developer Experience
"Developers use Git. No kubectl commands needed. Self-service deployments."

### Closing
"This reduces risk, enables speed, and provides complete audit trails. Questions?"

---

## 📊 Time Estimates

| Activity | Duration |
|----------|----------|
| Initial Setup | 5 min |
| Build Images | 2 min |
| App Deployment | 1 min |
| UI Verification | 2 min |
| Quick Demo (5 features) | 5 min |
| Standard Demo (8 features) | 15 min |
| Deep-Dive Demo (all 12) | 30 min |
| Q&A | 10-15 min |
| **Total for Standard** | **~45 min** |

---

## 🔄 Demo Workflows

### Workflow 1: Show Git-Driven Deployment
```bash
# Prep: Have git terminal + ArgoCD UI side-by-side
1. Edit k8s/frontend.yaml (increase replicas)
2. Commit and push to git
3. Show ArgoCD UI detects "out of sync"
4. Manually sync (or auto-sync will do it)
5. Show pods updating in real-time

Result: "See? Code change in git → automatic deployment"
```

### Workflow 2: Demonstrate Rollback
```bash
# Prep: Have multiple revisions (make changes, sync multiple times)
1. Show deployment working fine
2. Show "bad update" (hypothetically)
3. Access history: argocd app history argocd-demo-app
4. Click "Rollback" on previous revision
5. Watch pods instantly revert
6. Show it working again

Result: "Back to working state. In seconds. One click."
```

### Workflow 3: Show Drift Detection
```bash
# Prep: Manual CLI terminal
1. Show application synced (green)
2. Make manual cluster change: kubectl scale ...
3. Show ArgoCD immediately shows "out of sync"
4. Click sync to fix, or let self-heal fix it automatically
5. Show cluster state matches git again

Result: "Any manual changes are automatically caught and corrected."
```

### Workflow 4: Multi-Environment
```bash
# Prep: Show k8s folder structure
1. Explain: Same repo, different overlays per environment
2. Show: applications/app.yaml pointing to k8s/ (base)
3. Explain: Can point overlays/dev/, overlays/staging/, overlays/prod/
4. Show: Each can have different configs (replicas, resources, etc.)

Result: "Manage dev, staging, prod from single source, with variation."
```

---

## 🎓 What You're Selling

### Business Value
✅ Reduce deployment time from hours to minutes  
✅ Enable 100x deployments per day safely  
✅ Reduce ops team burden (automation)  
✅ Complete audit trail (compliance)  
✅ Zero-downtime rollback (reliability)  

### Technical Value
✅ Git as source of truth  
✅ Kubernetes-native (works with any distro)  
✅ Multi-cluster support  
✅ Enterprise RBAC  
✅ Open source (no vendor lock-in)  

### Developer Value
✅ Use Git, not kubectl  
✅ Self-service deployments  
✅ Familiar workflows  
✅ No special permissions needed  

---

## 🚀 Getting Started NOW

1. **Right now:** Read `README.md` (5 min)
2. **Then:** Run `./scripts/setup.sh` (5 min)
3. **Next:** Run `./scripts/build-images.sh` (2 min)
4. **Then:** `kubectl apply -f argocd-demo-config/applications/app.yaml` (1 min)
5. **Finally:** `./scripts/demo.sh` to rehearse

**Total time to first demo-ready state: ~18 minutes**

---

## 📞 Questions or Customization

- **Change git repository?** Edit `applications/app.yaml` → `source.repoURL`
- **Change image registry?** Edit `k8s/backend.yaml` and `k8s/frontend.yaml` → `image:`
- **Enable auto-sync?** Uncomment `automated:` block in `applications/app.yaml`
- **Add more features?** See `README.md` for advanced examples

---

## 📚 Additional Resources

**In this project:**
- README.md - Comprehensive guide
- QUICKSTART.md - Getting started
- DEMO_CHECKLIST.md - Feature checklist
- All YAML files have extensive comments

**External:**
- ArgoCD Docs: https://argo-cd.readthedocs.io
- GitOps: https://www.gitops.tech
- Argo Project: https://argoproj.github.io

---

## ✅ You're Ready!

This complete ArgoCD demo is production-ready:

✅ Fully automated setup  
✅ Professional sample application  
✅ All 12 core features included  
✅ Multiple demo paths (5, 15, 30 min)  
✅ Comprehensive documentation  
✅ Easy to customize for your use case  
✅ Git repository ready  

**Next: Run `./scripts/setup.sh` and start demoing! 🎉**

---

*Happy demoing!* 🚀
