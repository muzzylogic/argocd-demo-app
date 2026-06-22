# 🚀 START HERE - ArgoCD Demo Setup

Welcome! You're looking at a **production-ready ArgoCD demonstration** for sales and technical presentations.

## ⏱️ Time Required
- **Setup:** 5-10 minutes (one time)
- **Demo:** 5-30 minutes (depending on depth)
- **Total:** ~20 minutes to first successful demo

## 📖 Documentation Files (Read in This Order)

1. **This file** - Overview and quick start
2. [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Commands cheatsheet (print this!)
3. [QUICKSTART.md](QUICKSTART.md) - 10-minute getting started
4. [DEMO_CHECKLIST.md](DEMO_CHECKLIST.md) - Feature checklist for demos
5. [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) - Complete project structure
6. [README.md](README.md) - In-depth feature guide
7. [SETUP_SUMMARY.md](SETUP_SUMMARY.md) - Detailed summary

## 🎯 One-Minute Summary

**What:** ArgoCD - GitOps continuous deployment tool  
**Why:** Safe, audited, reversible deployments at scale  
**How:** Git is your deployment system  
**Demo:** Shows Git-driven updates, instant rollback, and drift detection  

## 🚀 30-Second Quick Start

```bash
cd /home/vitas/dev/airflow_demo
./scripts/setup.sh              # Setup (5 min)
./scripts/build-images.sh       # Build (2 min)
kubectl apply -f argocd-demo-config/applications/app.yaml
./scripts/demo.sh               # Demo (15+ min)
```

**URLs:**
- ArgoCD: https://localhost:8080
- Sample App: http://localhost:3000

## 📊 What You Get

### Two Separate Git Repos (Simulated)
1. **argocd-demo-app** - Sample application code & K8s manifests
2. **argocd-demo-config** - ArgoCD configuration & deployments

### Complete Microservices App
- **Backend:** Node.js/Express API with `/api/message` and `/health` endpoints
- **Frontend:** React UI that calls backend
- **K8s:** StatefulSet for backend (2 replicas), Deployment for frontend (2 replicas)
- **Docker:** Production-ready multi-stage builds

### 12 Core Features to Demo
All major ArgoCD capabilities: sync status, health, manual/auto sync, rollback, drift detection, multi-environment, and more.

### Professional Automation
- `setup.sh` - One-command Minikube + ArgoCD setup
- `build-images.sh` - Build Docker images in Minikube
- `demo.sh` - Interactive 12-feature demo guide
- `cleanup.sh` - Clean shutdown

## 🎬 Three Demo Paths

### Quick Demo (5 minutes)
```
1. Show application status in ArgoCD UI
2. Make git change
3. Show auto-sync
4. Demonstrate rollback
```

### Standard Demo (15 minutes)
Add to Quick:
```
5. Show drift detection & fixing
6. Show health monitoring
7. Show resources & logs
```

### Deep-Dive Demo (30 minutes)
Add to Standard:
```
8. Show manual sync workflow
9. Show multi-environment setup
10. Discuss sync waves & progressive delivery
11. Explain RBAC & security
12. Q&A
```

## ✅ Pre-Demo Checklist

- [ ] Read QUICK_REFERENCE.md
- [ ] Run: `./scripts/setup.sh`
- [ ] Run: `./scripts/build-images.sh`
- [ ] Run: `kubectl apply -f argocd-demo-config/applications/app.yaml`
- [ ] Verify: `kubectl get pods -n argocd-demo` (should see 2 backend, 2 frontend)
- [ ] Test: ArgoCD UI loads (https://localhost:8080)
- [ ] Test: Sample app loads (http://localhost:3000)
- [ ] Practice: Run `./scripts/demo.sh` once
- [ ] Prepare: Have git terminal + browser windows ready

## 🎤 Key Sales Messages

**Problem:** "How do you safely deploy 100 times a day across multiple clusters?"

**Solution:** "GitOps with ArgoCD - Git becomes your deployment system."

**Results:**
- ✅ Faster deployments (hours → minutes)
- ✅ Safer rollback (days → seconds)
- ✅ Complete audit trail (compliance)
- ✅ Prevents configuration drift
- ✅ Reduces ops burden
- ✅ Developer self-service

## 📁 Project Structure

```
argocd-demo/
├── argocd-demo-app/          ← Sample app (frontend + backend)
├── argocd-demo-config/       ← ArgoCD configuration
├── scripts/                  ← Automation (setup, demo, cleanup)
└── *.md                      ← Documentation
```

## 🔧 Common Commands During Demo

```bash
# View application status
kubectl get app -n argocd

# Make a change and sync
git commit -am "update"
git push
argocd app sync argocd-demo-app

# Rollback
argocd app history argocd-demo-app
argocd app rollback argocd-demo-app 0

# Show drift
kubectl scale deployment frontend -n argocd-demo --replicas=10
argocd app sync argocd-demo-app  # Fix it

# Watch pods update
watch kubectl get pods -n argocd-demo
```

## ❓ Common Questions

**Q: What is ArgoCD?**  
A: Git-based continuous deployment. It watches your Git repo and keeps your cluster in sync.

**Q: How is this different from Jenkins?**  
A: ArgoCD is **declarative** (Git is source of truth) vs **imperative** (step-by-step commands).

**Q: Can it do blue-green deployments?**  
A: Yes! Via Argo Rollouts (companion project).

**Q: What about multi-cluster?**  
A: ArgoCD can manage multiple clusters from one control plane.

**Q: How is rollback so fast?**  
A: It's just a Git revert - no re-running build/test pipeline.

## 🚨 Troubleshooting

| Issue | Fix |
|-------|-----|
| Minikube won't start | `minikube delete && minikube start` |
| ArgoCD UI won't load | Check: `kubectl get pods -n argocd` |
| Images won't build | Run: `./scripts/build-images.sh` |
| App won't deploy | Check: `kubectl describe app argocd-demo-app -n argocd` |

Full troubleshooting in [README.md](README.md)

## 📞 Next Steps

1. **Now:** Read [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
2. **Then:** Run `./scripts/setup.sh`
3. **Then:** Run `./scripts/demo.sh` to rehearse
4. **Finally:** Demo to your audience!

## 🎓 Learning Resources

- **ArgoCD Docs:** https://argo-cd.readthedocs.io
- **GitOps Principles:** https://www.gitops.tech
- **Argo Project:** https://argoproj.github.io

## 🧹 Cleanup When Done

```bash
./scripts/cleanup.sh
```

---

## 🎉 You're Ready!

This is a **production-quality demo** that shows ArgoCD's real value:

✅ Fully automated setup  
✅ Real microservices app  
✅ All 12 core features  
✅ Multiple demo paths  
✅ Professional documentation  

**Next: Print [QUICK_REFERENCE.md](QUICK_REFERENCE.md) and run the setup! 🚀**

---

*Last Updated: June 22, 2026*  
*Created for ArgoCD product demonstrations*
