# ArgoCD Demo Feature Checklist

Use this checklist during your demo to ensure you cover all key features.

## Pre-Demo Verification 

- [ ] Minikube is running (`minikube status`)
- [ ] ArgoCD is installed (`kubectl get pods -n argocd`)
- [ ] Docker images are built (`docker images | grep argocd-demo`)
- [ ] Application is deployed (`kubectl get app -n argocd`)
- [ ] ArgoCD UI is accessible (port-forward running)
- [ ] Terminal and browser windows are organized

## Feature Demonstrations

### 1. Show Application Status & Health
**Duration:** 2 minutes
- [ ] Open ArgoCD UI → Applications tab
- [ ] Show application card:
  - [ ] Sync status (green = synced)
  - [ ] Health status (healthy/degraded/unknown)
  - [ ] Resource count
  - [ ] Last sync time
- [ ] Click on application → Details view
- [ ] Show all deployed resources
- [ ] Show pod health status

**Talking Points:**
- "Real-time visibility of deployment status"
- "ArgoCD continuously monitors health"
- "All resources in one view"

---

### 2. Git vs Live State Comparison
**Duration:** 2 minutes
- [ ] Show Git commit (what's desired)
- [ ] Show Live state (what's running)
- [ ] Click "Diff" to see three-way comparison
- [ ] Show they match (synced state)

**Talking Points:**
- "Git is source of truth"
- "ArgoCD constantly compares both"
- "No surprises, everything is visible"

---

### 3. Manual Sync Workflow
**Duration:** 3 minutes
- [ ] Show application with manual sync enabled
- [ ] Edit a k8s manifest locally (e.g., change replica count)
- [ ] Commit and push to Git
- [ ] Show ArgoCD detects change (out-of-sync)
- [ ] Click "Sync Now" button in UI
  - OR run: `argocd app sync argocd-demo-app`
- [ ] Watch pods update in real-time
- [ ] Show status changes to "Synced"

**Script:**
```bash
# Edit frontend replicas
sed -i 's/replicas: 2/replicas: 3/' argocd-demo-app/k8s/frontend.yaml
git add .
git commit -m "Scale frontend to 3 replicas"
git push

# Show out-of-sync in UI
# Click Sync or run:
argocd app sync argocd-demo-app
```

**Talking Points:**
- "Changes go through Git (audit trail)"
- "Controlled deployments (manual approval)"
- "No direct kubectl commands needed"

---

### 4. Auto-Sync Demonstration
**Duration:** 2 minutes
- [ ] Switch to second application with auto-sync enabled
- [ ] Edit manifest
- [ ] Commit and push
- [ ] Show ArgoCD syncs automatically (within 3 min or immediately with webhooks)
- [ ] No manual intervention needed

**Setup:**
```bash
# This is in app.yaml - show the config:
kubectl get app argocd-demo-app-auto-sync -n argocd -o yaml | grep -A 10 "automated:"
```

**Talking Points:**
- "True GitOps - Git is the single source of truth"
- "Automatic deployment on Git push"
- "Can add approval gates with Git PRs"

---

### 5. Drift Detection & Self-Healing
**Duration:** 3 minutes
- [ ] Manually change a pod/deployment (simulate configuration drift):
  ```bash
  kubectl scale deployment frontend -n argocd-demo --replicas=10
  ```
- [ ] Show ArgoCD UI detects out-of-sync status
- [ ] Show the diff (too many replicas)
- [ ] If self-heal is enabled, watch it auto-correct
- [ ] If manual, sync and watch it fix

**Talking Points:**
- "Prevents configuration drift"
- "Can automatically enforce desired state"
- "No rogue manual changes survive"
- "Great for compliance & governance"

---

### 6. Health Monitoring & Failed Resources
**Duration:** 2 minutes
- [ ] Show healthy deployment with green indicators
- [ ] Optionally: simulate a failure (scale to too many resources, trigger crashloop)
- [ ] Show health status changes to degraded/red
- [ ] Show which resources are unhealthy
- [ ] Discuss health checks

**Talking Points:**
- "Aggregate health from all resources"
- "Based on Kubernetes native health checks"
- "No separate monitoring system needed"

---

### 7. History & Rollback
**Duration:** 3 minutes
- [ ] Show application history:
  ```bash
  argocd app history argocd-demo-app
  ```
- [ ] Each entry shows commit, timestamp, author
- [ ] Click on revision number → detailed info
- [ ] Click "Rollback" button (or run command)
- [ ] Watch pods terminate and restart with old version
- [ ] Confirm rollback was successful

**Script:**
```bash
# View history
argocd app history argocd-demo-app

# Show rollback in UI, or CLI:
argocd app rollback argocd-demo-app 0  # Rollback to revision 0
```

**Talking Points:**
- "One-click rollback"
- "Complete deployment history"
- "Atomic rollback of all resources"
- "Works even for complex deployments"

---

### 8. Multi-Replica Rolling Updates
**Duration:** 2 minutes
- [ ] Show current deployment (e.g., 2 replicas of frontend)
- [ ] Scale up to 5 replicas (change in git)
- [ ] Watch pods gradually terminate and create new ones
- [ ] Show zero downtime (old pods still running while new ones start)
- [ ] Show rolling update strategy working

**Script:**
```bash
# Edit frontend replicas and commit
# Watch:
watch kubectl get pods -n argocd-demo -l app=frontend

# Or:
kubectl get deployment frontend -n argocd-demo -w
```

**Talking Points:**
- "Zero-downtime updates"
- "Gradual pod replacement"
- "Traffic seamlessly switches to new pods"

---

### 9. Resource Details & Logs
**Duration:** 2 minutes
- [ ] Click on individual pod in application view
- [ ] Show pod details (IP, node, resources)
- [ ] Show pod logs
- [ ] Click on backend pod
- [ ] Show how to debug failed deployments
- [ ] Show how to view resource YAML

**Talking Points:**
- "Single pane of glass for all resources"
- "Quick debugging without kubectl"
- "All useful information in UI"

---

### 10. Environment-Specific Configs (Optional)
**Duration:** 2 minutes (if time permits)
- [ ] Show how different environments use same repo with overlays
- [ ] Show dev, staging, prod applications
- [ ] Explain kustomize or values-{env}.yaml approach
- [ ] Show how environments diverge (different replicas, resources, etc.)

**Talking Points:**
- "DRY (Don't Repeat Yourself)"
- "Consistent deployment across environments"
- "Easy to add new environments"

---

### 11. RBAC & Multi-Tenancy (Optional)
**Duration:** 2 minutes (if time permits)
- [ ] Show project-based access control
- [ ] Explain how teams can have isolated repositories
- [ ] Show role-based permissions

**Talking Points:**
- "Enterprise-grade access control"
- "Teams can self-serve without platform team"
- "Compliance-friendly audit trails"

---

### 12. Notifications & Integrations (Optional)
**Duration:** 1 minute (if time permits)
- [ ] Show notification templates
- [ ] Explain Slack, email, webhook integrations
- [ ] Show how to trigger custom workflows

**Talking Points:**
- "Keep team informed of deployments"
- "Integrate with incident management"
- "Webhook support for custom workflows"

---

## Live Demo Variations

### Quick 5-Minute Demo
Cover: 1, 2, 3, 6, 7

### Standard 15-Minute Demo
Cover: 1, 2, 3, 4, 5, 7, 8

### Deep-Dive 30-Minute Demo
Cover: All 1-10

### Executive Summary (10 minutes)
Cover: 1, 2, 3, 7, 9
Focus on: Business benefits, reduced risk, faster deployment

---

## Emergency Fallback Plans

**If application won't sync:**
- Restart application controller:
  ```bash
  kubectl rollout restart deployment/argocd-application-controller -n argocd
  ```
- Check logs: `kubectl logs -n argocd -l app=argocd-application-controller`

**If pods won't start:**
- Check image availability in Minikube
- Check resource requests (may not fit in Minikube)
- Manually pull image: `docker pull image-name`

**If UI is slow:**
- Refresh browser or restart argocd-server:
  ```bash
  kubectl rollout restart deployment/argocd-server -n argocd
  ```

**If you need to start over:**
```bash
./scripts/cleanup.sh
./scripts/setup.sh
./scripts/build-images.sh
kubectl apply -f argocd-demo-config/applications/app.yaml
```

---

## Post-Demo Follow-Up

- [ ] Provide GitHub/GitLab repo link to customer
- [ ] Send QUICKSTART.md guide
- [ ] Offer PoC proposal
- [ ] Schedule technical deep-dive if needed
- [ ] Answer customer questions about their use case
- [ ] Discuss ArgoCD enterprise support (Argo Workflows, Argo Rollouts, etc.)

---

## Time Budget

- Setup: 5 min
- Feature demos: 20-30 min
- Q&A: 10-15 min
- **Total: ~45 minutes**

Adjust feature coverage based on available time.

---

**Pro Tips:**
- Have two browser windows: one for ArgoCD UI, one for git repo/GitHub
- Use `watch` command to show real-time updates
- Have talking points written on separate note card
- Practice transitions between demos
- Keep git commits ready to push for smooth transitions

Good luck! 
