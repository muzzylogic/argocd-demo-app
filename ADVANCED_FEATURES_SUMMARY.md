# Advanced Features Summary

This demo includes three optional advanced capabilities.

## 1) Multi-version image scenarios

Build versions for normal, broken, and degraded behavior:

```bash
./scripts/build-images-variants.sh
```

Use this to demonstrate rollback and failure handling quickly.

## 2) Custom hostname

Configure local domain routing:

```bash
./scripts/setup-hostname.sh
```

Then access:
- `http://demo.argocd`
- `http://demo.argocd/app/`

## 3) Git trigger options

ArgoCD supports:
- polling (default)
- webhook triggers
- SSH/self-hosted repos

Reference helper:
- [scripts/setup-git-webhook.sh](scripts/setup-git-webhook.sh)

## Suggested sequence

```bash
./scripts/setup.sh
./scripts/build-images.sh
./scripts/build-images-variants.sh
./scripts/setup-hostname.sh
kubectl apply -f argocd-demo-config/applications/app.yaml
```

See full walkthrough in [ADVANCED_SCENARIOS.md](ADVANCED_SCENARIOS.md).
