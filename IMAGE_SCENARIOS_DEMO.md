# Image Scenario Demo - Steps to Switch Versions

This guide shows how to build and deploy different backend scenarios to demonstrate ArgoCD drift detection, health monitoring, and auto-remediation.

## Available Scenarios

| Scenario | Dockerfile | Image Tag | Status | Behavior |
|----------|-----------|-----------|--------|----------|
| Working | backend.Dockerfile | 1.0.0 | Healthy | Fast responses |
| Degraded | backend-degraded.Dockerfile | 1.0.2 | Degraded | Slow (3-5s) responses, health passes |
| Broken | backend-broken.Dockerfile | 1.0.1 | Unhealthy | Health checks fail, 500/503 errors |

## Prerequisite

Ensure Minikube Docker is active:

```bash
eval $(minikube docker-env)
```

---

## Scenario 1: Working Version (1.0.0)

Build the working image:

```bash
docker build -f argocd-demo-app/docker/backend.Dockerfile \
  -t argocd-demo-backend:1.0.0 \
  argocd-demo-app
```

Update k8s manifest to use it:

```bash
sed -i 's|argocd-demo-backend:.*|argocd-demo-backend:1.0.0|' argocd-demo-app/k8s/backend.yaml
```

Commit and push:

```bash
git add argocd-demo-app/k8s/backend.yaml
```

```bash
git commit -m "demo: deploy working backend 1.0.0"
```

```bash
git push
```

Sync (or auto-sync if enabled):

```bash
kubectl patch app argocd-demo-app -n argocd --type merge -p '{"spec":{"syncPolicy":{"automated":null}}}'
```

Then in UI: click Sync, OR if auto-sync enabled, wait for reconciliation.

Verify:

```bash
kubectl get pods -n argocd-demo -l app=backend
```

```bash
kubectl logs -n argocd-demo -l app=backend | tail -n 5
```

Show in UI:
- Application Sync Status → Synced
- Health Status → Healthy
- Pod logs show "Backend 1.0.0 WORKING VERSION"

---

## Scenario 2: Degraded Version (1.0.2)

Build degraded image:

```bash
docker build -f argocd-demo-app/docker/backend-degraded.Dockerfile \
  -t argocd-demo-backend:1.0.2 \
  argocd-demo-app
```

Update manifest:

```bash
sed -i 's|argocd-demo-backend:.*|argocd-demo-backend:1.0.2|' argocd-demo-app/k8s/backend.yaml
```

Commit and push:

```bash
git add argocd-demo-app/k8s/backend.yaml
```

```bash
git commit -m "demo: deploy degraded backend 1.0.2"
```

```bash
git push
```

Sync:

```bash
kubectl patch app argocd-demo-app -n argocd --type merge -p '{"spec":{"syncPolicy":{"automated":null}}}'
```

In UI: click Sync or wait for auto-sync.

Watch rollout (in separate terminal):

```bash
kubectl get pods -n argocd-demo -l app=backend -w
```

Stop watch with `Ctrl+C`.

Observe:
- Health status may show "Degraded" or "Progressing" initially
- Pod logs show "Backend 1.0.2 DEGRADED VERSION"
- API calls now take 3-5 seconds (show in frontend https://demo.argocd/app/)
- Health check eventually passes after 3s delay

Check logs:

```bash
kubectl logs -n argocd-demo -l app=backend | tail -n 5
```

---

## Scenario 3: Broken Version (1.0.1)

Build broken image:

```bash
docker build -f argocd-demo-app/docker/backend-broken.Dockerfile \
  -t argocd-demo-backend:1.0.1 \
  argocd-demo-app
```

Update manifest:

```bash
sed -i 's|argocd-demo-backend:.*|argocd-demo-backend:1.0.1|' argocd-demo-app/k8s/backend.yaml
```

Commit and push:

```bash
git add argocd-demo-app/k8s/backend.yaml
```

```bash
git commit -m "demo: deploy broken backend 1.0.1"
```

```bash
git push
```

Sync:

```bash
kubectl patch app argocd-demo-app -n argocd --type merge -p '{"spec":{"syncPolicy":{"automated":null}}}'
```

In UI: click Sync or wait for auto-sync.

Watch (in separate terminal):

```bash
kubectl get pods -n argocd-demo -l app=backend -w
```

Observe:
- Pods will restart repeatedly (CrashLoopBackOff)
- Health status shows "Unhealthy" or "Degraded"
- Frontend shows API errors

Check logs (they will show failures):

```bash
kubectl logs -n argocd-demo -l app=backend | tail -n 10
```

Watch health checks fail:

```bash
kubectl describe pod -n argocd-demo -l app=backend | grep -A 5 "Events:"
```

---

## Recovery: Go Back to Working (1.0.0)

To stop showing a broken/degraded app and return to working state:

```bash
sed -i 's|argocd-demo-backend:.*|argocd-demo-backend:1.0.0|' argocd-demo-app/k8s/backend.yaml
```

```bash
git add argocd-demo-app/k8s/backend.yaml
```

```bash
git commit -m "demo: rollback to working backend 1.0.0"
```

```bash
git push
```

In UI: click Sync (or wait for auto-sync).

Verify:

```bash
kubectl get pods -n argocd-demo -l app=backend
```

---

## Demo Flow (Full Scenario)

### Step 1: Show Working (2 min)
1. Deploy 1.0.0 (working version above)
2. Show healthy status in UI
3. Show fast API response in frontend

### Step 2: Demo Drift → Degradation (3 min)
1. Deploy 1.0.2 (degraded version above)
2. Show ArgoCD detects OutOfSync
3. Show Health status changes to Degraded
4. Show slow responses in frontend
5. Explain: "ArgoCD detects and displays health without leaving Kubernetes"

### Step 3: Demo Failure & Auto-Remediation (3 min)
1. Deploy 1.0.1 (broken version above)
2. Show Health status is Unhealthy
3. Show pods CrashLoopBackOff in Kubernetes
4. Explain: "ArgoCD shows exactly what's broken"
5. Optional: show self-heal would recycle the pod infinitely (if enabled)

### Step 4: Recovery (1 min)
1. Rollback to 1.0.0 (working version above)
2. Show pods recover
3. Show health returns to Healthy

---

## One-Liner: Fast Switch Between Versions

If you want to quickly swap versions without full git ceremony:

Switch to 1.0.0:
```bash
sed -i 's|argocd-demo-backend:.*|argocd-demo-backend:1.0.0|' argocd-demo-app/k8s/backend.yaml && git add argocd-demo-app/k8s/backend.yaml && git commit -m "demo: version 1.0.0" && git push
```

Switch to 1.0.2:
```bash
sed -i 's|argocd-demo-backend:.*|argocd-demo-backend:1.0.2|' argocd-demo-app/k8s/backend.yaml && git add argocd-demo-app/k8s/backend.yaml && git commit -m "demo: version 1.0.2" && git push
```

Switch to 1.0.1:
```bash
sed -i 's|argocd-demo-backend:.*|argocd-demo-backend:1.0.1|' argocd-demo-app/k8s/backend.yaml && git add argocd-demo-app/k8s/backend.yaml && git commit -m "demo: version 1.0.1" && git push
```

Then in UI: click Sync.

---

## Talking Points

- **Working (1.0.0):** "Baseline healthy application running normally."
- **Degraded (1.0.2):** "ArgoCD shows when performance degrades. Health is visible without leaving Kubernetes. Self-healing can restart if threshold is met."
- **Broken (1.0.1):** "Failures are immediately visible. ArgoCD reports exact health status. Combined with self-heal, pods restart automatically."
