# Advanced Demo Scenarios & Setup

This guide covers advanced features for your ArgoCD demo:
- Watching local/remote Git repos with webhooks
- Pre-built image scenarios (working, broken, degraded)
- Custom hostname access (demo.argocd instead of localhost)
- CI/CD integration strategies

##  Part 1: ArgoCD Git Watching

### How ArgoCD Watches Git

ArgoCD can watch **any Git repository** - GitHub, GitLab, self-hosted, local repos, etc.

#### Option A: Polling (Default - Simple)
```
 No setup needed
 ArgoCD checks git every 3 minutes
 Delay: ~3 minutes until sync
```

**Demo workflow:**
```bash
# 1. Make a change to k8s manifest
vi argocd-demo-app/k8s/frontend.yaml

# 2. Commit and push
git add .
git commit -m "Update replicas"
git push

# 3. Watch ArgoCD detect it (3 min) OR manually sync
argocd app sync argocd-demo-app

# 4. Pods update automatically
watch kubectl get pods -n argocd-demo
```

#### Option B: GitHub Webhook (Fast)
```
 Instant sync on push
 Delay: <1 second
 Requires webhook configuration
```

**Setup steps:**
```bash
./scripts/setup-git-webhook.sh
```

Then in GitHub:
1. Go to repo → Settings → Webhooks → Add webhook
2. Payload URL: `http://YOUR-ARGOCD-IP:80/api/webhook`
3. Content type: `application/json`
4. Trigger on: Push events

**Demo workflow:**
```bash
# Push change to GitHub
git push origin main

# ArgoCD syncs INSTANTLY (no wait!)
# Show the automatic sync in UI
```

#### Option C: SSH for Self-Hosted Git
```bash
# 1. Generate SSH key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/argocd-repo -N ''

# 2. Add to git server authorized_keys
cat ~/.ssh/argocd-repo.pub >> /path/to/git/server/.ssh/authorized_keys

# 3. Add repository to ArgoCD
argocd repo add git@your-git-server:user/argocd-demo-app.git \
  --ssh-private-key-path ~/.ssh/argocd-repo

# 4. Update applications/app.yaml
# repoURL: git@your-git-server:user/argocd-demo-app.git
```

### Which Should You Use for Demo?

- **Default (Polling)**: Best for simple demos - no webhook needed
- **GitHub Webhook**: Best for GitHub.com repos - shows instant sync
- **SSH**: Best for self-hosted GitLab/Gitea - professional setup
- **Local Git**: Best for offline demos - file:// protocol

---

##  Part 2: Multi-Scenario Image Variants

### Pre-Build Multiple Image Versions

Build 3 versions before the demo to show different scenarios:

```bash
./scripts/build-images-variants.sh
```

This creates:

| Version | Status | Health Check | Response | Use Case |
|---------|--------|--------------|----------|----------|
| **1.0.0** |  Working | PASS | Fast (50ms) | Normal operation |
| **1.0.1** |  Broken | FAIL | 500 errors | Show failure recovery |
| **1.0.2** |  Degraded | PASS (slow) | Slow (5s) | Show performance issue |

### Demo Scenario 1: Failure & Recovery

```bash
# 1. Start with 1.0.0 (working)
kubectl set image -n argocd-demo sts/backend \
  backend=argocd-demo-backend:1.0.0 --record

# 2. Show everything healthy
kubectl get pods -n argocd-demo          # All running
argocd app get argocd-demo-app           # Healthy

# 3. Switch to 1.0.1 (broken)
kubectl set image -n argocd-demo sts/backend \
  backend=argocd-demo-backend:1.0.1 --record

# 4. Show the failure (pods crashing)
watch kubectl get pods -n argocd-demo
# Notice: CrashLoopBackOff status

# 5. Show in ArgoCD UI
# Application shows: Degraded/Unknown health

# 6. ROLLBACK in ArgoCD UI
argocd app history argocd-demo-app
argocd app rollback argocd-demo-app 0

# 7. Watch recovery (pods become healthy again)
watch kubectl get pods -n argocd-demo
```

**Talking Points:**
- "Broken deployment detected automatically"
- "One-click rollback reverts all changes"
- "Pods healthy again in seconds"

### Demo Scenario 2: Performance Degradation

```bash
# 1. Start with 1.0.0
kubectl set image -n argocd-demo sts/backend \
  backend=argocd-demo-backend:1.0.0

# 2. Show fast responses
curl http://backend:3001/api/message          # ~50ms

# 3. Switch to 1.0.2 (degraded)
kubectl set image -n argocd-demo sts/backend \
  backend=argocd-demo-backend:1.0.2

# 4. Show slow responses
curl http://backend:3001/api/message          # ~5 seconds!
# Pods still running, but degraded

# 5. Health shows: degraded/warning
kubectl get pods -n argocd-demo -o wide

# 6. Rollback to fixed version
argocd app rollback argocd-demo-app 0
```

**Talking Points:**
- "Not all failures are crashes"
- "Performance regressions detected by monitoring"
- "Automated rollback before customers notice"

### Demo Scenario 3: Gradual Rollout (Using Rollback)

```bash
# 1. Update deployment to 1.0.2 in git
sed -i 's/1.0.0/1.0.2/' argocd-demo-app/k8s/backend.yaml

# 2. Commit and push
git add .
git commit -m "Upgrade to v1.0.2"
git push

# 3. ArgoCD syncs (or manually sync)
argocd app sync argocd-demo-app

# 4. Show degradation happening
kubectl get pods -n argocd-demo
# Response time shows as 5 seconds

# 5. Quickly rollback
git revert HEAD
git push

argocd app sync argocd-demo-app

# 6. Show normal performance restored
```

---

##  Part 3: Custom Hostname (demo.argocd)

### Why Use Custom Hostname?

- **Professional**: Shows real URLs (not localhost)
- **Minikube**: Works with Minikube directly
- **Easy**: Just add to /etc/hosts
- **Multi-service**: ArgoCD + App on same domain

### Setup demo.argocd

```bash
./scripts/setup-hostname.sh
```

This:
1. Gets Minikube IP
2. Adds `demo.argocd` to `/etc/hosts`
3. Enables Minikube Ingress addon
4. Creates Ingress resources
5. Tests connectivity

### Access the Demo

After setup:

```
ArgoCD UI:
  http://demo.argocd
  https://demo.argocd

Sample App:
  http://demo.argocd/app/
```

### Manual Setup (If script fails)

```bash
# 1. Get Minikube IP
MINIKUBE_IP=$(minikube ip)
echo $MINIKUBE_IP              # e.g., 192.168.49.2

# 2. Add to /etc/hosts (requires sudo)
echo "$MINIKUBE_IP demo.argocd" | sudo tee -a /etc/hosts

# 3. Enable Ingress
minikube addons enable ingress

# 4. Create Ingress (see setup-hostname.sh for manifests)
kubectl apply -f - << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server
  namespace: argocd
spec:
  ingressClassName: nginx
  rules:
  - host: demo.argocd
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              number: 443
EOF

# 5. Test
curl http://demo.argocd
```

### Troubleshooting

**Can't reach demo.argocd:**
```bash
# 1. Check /etc/hosts
grep demo.argocd /etc/hosts

# 2. Verify Minikube IP
minikube ip

# 3. Check Ingress status
kubectl get ingress -n argocd

# 4. Check Ingress controller
kubectl get pods -n ingress-nginx
```

**Use port-forward instead (fallback):**
```bash
# Skip Ingress, use port-forward
kubectl port-forward -n argocd svc/argocd-server 443:443 &
kubectl port-forward -n argocd-demo svc/frontend 80:80 &

# Access via localhost
https://localhost
http://localhost
```

---

##  Part 4: CI/CD Integration Strategy

### Option A: No CI/CD (Simplest)

**For pure GitOps demo:**
```
Developer → Git Push → ArgoCD watches Git → Sync to Cluster
```

**Use this for:**
- Quick demos
- Showing pure GitOps
- No build artifacts needed

**Setup:**
```bash
# Just use pre-built images
./scripts/build-images.sh
# Deploy and demo
```

### Option B: GitHub Actions (Recommended)

**For realistic GitOps with CI/CD:**
```
Developer → Git Push → GitHub Actions (build image) 
  → Push to registry → ArgoCD syncs new image
```

**Create `.github/workflows/build.yml`:**
```yaml
name: Build and Push Image

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Build and push backend
        run: |
          docker build -f docker/backend.Dockerfile \
            -t ${{ secrets.REGISTRY }}/argocd-demo-backend:${{ github.sha }} .
          docker push ${{ secrets.REGISTRY }}/argocd-demo-backend:${{ github.sha }}
      
      - name: Update image tag in k8s
        run: |
          sed -i "s|image:.*|image: ${{ secrets.REGISTRY }}/argocd-demo-backend:${{ github.sha }}|" \
            k8s/backend.yaml
          git config user.name "github-actions"
          git config user.email "actions@github.com"
          git add k8s/backend.yaml
          git commit -m "Update image to ${{ github.sha }}"
          git push
```

**Demo workflow:**
```bash
# 1. Push code change
git push

# 2. GitHub Actions builds image
# 3. Updates k8s manifest in git
# 4. ArgoCD detects update
# 5. Syncs automatically
```

### Option C: Manual Local Build (For demo.argocd)

**For complete control:**
```bash
# 1. Make code change
vi backend/server.js

# 2. Build image locally
docker build -f docker/backend.Dockerfile -t argocd-demo-backend:v2 .

# 3. Push to registry
docker push myregistry.com/argocd-demo-backend:v2

# 4. Update k8s manifest
sed -i 's/1.0.0/v2/' k8s/backend.yaml

# 5. Commit and push
git add .
git commit -m "Upgrade backend to v2"
git push

# 6. ArgoCD syncs
# 7. Show new version running
```

---

##  Complete Demo Flow with All Features

### Pre-Demo Setup (15 min)
```bash
# 1. Build all image variants
./scripts/build-images-variants.sh

# 2. Setup custom hostname
./scripts/setup-hostname.sh

# 3. Setup git webhook (optional)
./scripts/setup-git-webhook.sh

# 4. Deploy app
kubectl apply -f argocd-demo-config/applications/app.yaml

# 5. Verify everything works
kubectl get pods -n argocd-demo
curl http://demo.argocd/app/
```

### Demo Flow (20-30 min)

**Part 1: Show Git-Driven Deployment (5 min)**
```bash
# 1. Open both:
#    - https://demo.argocd (ArgoCD)
#    - http://demo.argocd/app/ (Sample app)
#    - git terminal

# 2. Edit manifest
sed -i 's/replicas: 2/replicas: 4/' argocd-demo-app/k8s/frontend.yaml

# 3. Commit and push
git add .
git commit -m "Scale to 4 replicas"
git push

# 4. Show in ArgoCD: detects change
# 5. Manually sync or wait 3 min
argocd app sync argocd-demo-app

# 6. Watch pods scale in Terminal
watch kubectl get pods -n argocd-demo

# 7. Show sample app still working
```

**Part 2: Show Failure & Recovery (7 min)**
```bash
# 1. Explain: "What if a bad update gets deployed?"

# 2. Switch to broken version
kubectl set image -n argocd-demo sts/backend \
  backend=argocd-demo-backend:1.0.1 --record

# 3. Show in terminal: pods crashing
watch kubectl get pods -n argocd-demo
# CrashLoopBackOff status

# 4. Show in ArgoCD UI: health degraded

# 5. Say: "One-click rollback..."
# 6. Rollback in ArgoCD UI or CLI:
argocd app rollback argocd-demo-app 0

# 7. Show pods recovering
watch kubectl get pods -n argocd-demo
# Running again

# 8. Access app: working again
```

**Part 3: Show Drift Detection (5 min)**
```bash
# 1. Manual cluster change
kubectl scale sts backend -n argocd-demo --replicas=10

# 2. Show in ArgoCD: out-of-sync
argocd app get argocd-demo-app

# 3. Say: "This change isn't in git, so it's a drift"

# 4. Sync to fix:
argocd app sync argocd-demo-app

# 5. Show pods back to original count (2)
```

**Part 4: Q&A**
```
Key messages:
 Git is source of truth
 Instant rollback capability
 Prevents configuration drift
 Works across multiple clusters
 Complete audit trail
```

---

##  Scripts Reference

| Script | Purpose | Time |
|--------|---------|------|
| `setup.sh` | Initial Minikube + ArgoCD | 5 min |
| `build-images.sh` | Build standard images | 2 min |
| `build-images-variants.sh` | Build 3 scenario versions | 3 min |
| `setup-hostname.sh` | Configure demo.argocd | 2 min |
| `setup-git-webhook.sh` | Setup GitHub webhook | Info only |
| `demo.sh` | Interactive demo guide | 20 min |
| `cleanup.sh` | Remove all resources | 1 min |

---

##  Sales Pitch (Updated)

> "Let me show you how to deploy safely and recover from failures in seconds."

**[Open demo.argocd in browser]**

> "Here's our microservices application, deployed via ArgoCD. Git is our source of truth. When developers push code changes, ArgoCD watches the repository and automatically syncs the cluster."

**[Make a git change and push]**

> "Notice how ArgoCD detected the change and is syncing it now. Pods are updating automatically with zero downtime."

**[Wait for sync, show pods]**

> "Now let me show you what happens when a bad update gets deployed."

**[Switch to broken version]**

> "See the pods crashing? Health checks are failing. ArgoCD is detecting this automatically."

**[Click rollback in UI]**

> "One button. And we're back to the working version. In seconds. This is what you get with GitOps - the ability to revert entire deployments instantly."

**[Pods recover]**

> "Complete recovery. And because everything is in Git, we have a complete audit trail. Every change, who made it, when it was deployed, and how long it took."

---

Good luck with your demo! 
