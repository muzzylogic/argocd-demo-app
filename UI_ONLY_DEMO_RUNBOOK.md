# ArgoCD Demo Runbook (UI + kubectl + git Only)

This runbook avoids the ArgoCD CLI and uses only:
- ArgoCD Web UI
- kubectl
- git

## 1) Prep (2-3 min)

Run each command in a terminal from the repo root.

```bash
cd /home/vitas/dev/argocd-demo-app
```

```bash
kubectl get pods -n argocd
```

```bash
kubectl get app -n argocd -o custom-columns=NAME:.metadata.name,SYNC:.status.sync.status,HEALTH:.status.health.status
```

Start ArgoCD UI port-forward in a separate terminal:

```bash
kubectl port-forward -n argocd svc/argocd-server 8080:443
```

Open:
- https://localhost:8080
- Optional sample app: https://demo.argocd/app/

## 2) Status + Health (2 min)

In UI:
- Open Applications
- Click your app and show Sync + Health + Resources

Terminal checks:

```bash
kubectl get app -n argocd
```

```bash
kubectl get pods -n argocd-demo
```

## 3) Manual Sync Demo (3 min)

Replace `YOUR_MANUAL_APP` with your app name.

Set manual sync mode:

```bash
kubectl patch app YOUR_MANUAL_APP -n argocd --type merge -p '{"spec":{"syncPolicy":{"automated":null}}}'
```

Make a small Git change (example scales frontend to 3 replicas):

```bash
sed -i 's/replicas: 2/replicas: 3/' argocd-demo-app/k8s/frontend.yaml
```

```bash
git add .
```

```bash
git commit -m "demo: manual sync change"
```

```bash
git push
```

In UI:
- Show app becomes OutOfSync
- Click Sync
- Show app returns to Synced/Healthy

Verify in terminal:

```bash
kubectl get deploy frontend -n argocd-demo
```

## 4) Auto Sync Demo (2 min)

Replace `YOUR_AUTO_APP` with your app name.

Enable auto-sync:

```bash
kubectl patch app YOUR_AUTO_APP -n argocd --type merge -p '{"spec":{"syncPolicy":{"automated":{"prune":true,"selfHeal":true}}}}'
```

Make another small Git change and push:

```bash
sed -i 's/replicas: 3/replicas: 2/' argocd-demo-app/k8s/frontend.yaml
```

```bash
git add .
```

```bash
git commit -m "demo: auto sync change"
```

```bash
git push
```

In UI:
- Show reconciliation happens without clicking Sync

Verify policy:

```bash
kubectl get app YOUR_AUTO_APP -n argocd -o yaml | grep -A 6 automated
```

## 5) Drift Detection + Self-Heal (3 min)

Create drift directly in cluster:

```bash
kubectl scale deployment frontend -n argocd-demo --replicas=10
```

In UI:
- Show app becomes OutOfSync
- Open Diff view
- If manual app: click Sync
- If auto app with self-heal: show auto-correction

Verify:

```bash
kubectl get deploy frontend -n argocd-demo
```

## 6) History + Rollback (3 min)

After at least one synced change exists:

In UI:
- Open app
- Go to History
- Select previous revision
- Click Rollback

Watch pods roll:

```bash
kubectl get pods -n argocd-demo -l app=frontend -w
```

Stop watch with `Ctrl+C` when complete.

## 7) Quick End-State Check (30 sec)

```bash
kubectl get app -n argocd
```

```bash
kubectl get pods -n argocd-demo
```

## Optional: Reset Manifest Back to Original

If you changed replicas during demo and want to reset to 2:

```bash
sed -i 's/replicas: 3/replicas: 2/' argocd-demo-app/k8s/frontend.yaml
```

```bash
git add .
```

```bash
git commit -m "demo: reset frontend replicas to 2"
```

```bash
git push
```

If app is manual mode, click Sync in UI.
