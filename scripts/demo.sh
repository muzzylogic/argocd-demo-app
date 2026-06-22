#!/bin/bash
# ArgoCD Interactive Demo Script
# This script walks through key ArgoCD features with step-by-step instructions

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

pause() {
    echo ""
    read -p "Press Enter to continue..."
    echo ""
}

header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

subheader() {
    echo -e "\n${YELLOW}→ $1${NC}\n"
}

success() {
    echo -e "${GREEN}✓ $1${NC}"
}

info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════╗"
echo "║     ArgoCD Product Demo - Interactive Tour         ║"
echo "║                                                    ║"
echo "║  Demonstrating GitOps Continuous Deployment       ║"
echo "╚════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Feature 1: Application Sync Status
header "FEATURE 1: Application Sync Status & Health"
subheader "Monitor deployment status in real-time"

info "Showing all ArgoCD Applications in the cluster:"
echo "$ kubectl get applications -A"
kubectl get applications -A
pause

subheader "Detailed Application Status"
info "Viewing detailed application information:"
echo "$ argocd app list"
echo "(or in UI: Applications page)"
pause

# Feature 2: Git vs Cluster State
header "FEATURE 2: Git vs Cluster State Comparison"
subheader "ArgoCD continuously compares desired (Git) vs actual (Cluster) state"

info "Application details showing sync status:"
echo "$ kubectl describe app argocd-demo-app -n argocd | grep -A 20 Status"
kubectl describe app argocd-demo-app -n argocd 2>/dev/null | grep -A 20 "Status:" || echo "(Application may not be created yet)"
pause

# Feature 3: Manual Sync
header "FEATURE 3: Manual Sync"
subheader "Controlled deployments - sync only when you approve"

info "Syncing application manually:"
echo "$ kubectl patch app argocd-demo-app -n argocd --type merge -p '{\"spec\":{\"syncPolicy\":{\"automated\":null}}}'"
info "Then manually sync:"
echo "$ argocd app sync argocd-demo-app --prune"
pause

# Feature 4: Auto Sync
header "FEATURE 4: Auto Sync - GitOps in Action"
subheader "Automatic synchronization when Git changes"

info "Applications can be configured to auto-sync:"
echo "syncPolicy:"
echo "  automated:"
echo "    prune: true      # Delete removed resources"
echo "    selfHeal: true   # Fix drifted state"
pause

subheader "Demo: Making a Git change triggers automatic deployment"
info "1. Modify image tag in k8s/frontend.yaml"
info "2. Push to Git"
info "3. ArgoCD detects change automatically"
info "4. Application syncs without manual intervention"
pause

# Feature 5: Health Monitoring
header "FEATURE 5: Health & Resource Status"
subheader "ArgoCD monitors application health"

info "Viewing resource health:"
echo "$ kubectl get pods -n argocd-demo"
kubectl get pods -n argocd-demo 2>/dev/null || echo "(Namespace may be empty until application is synced)"
pause

info "ArgoCD evaluates health based on:"
echo "  • Pod status (Running, CrashLoopBackOff, etc.)"
echo "  • Resource readiness"
echo "  • Custom health rules"
echo "  • Application-defined health checks"
pause

# Feature 6: History & Rollback
header "FEATURE 6: History & Rollback"
subheader "Complete deployment history with instant rollback"

info "Viewing application revisions:"
echo "$ argocd app history argocd-demo-app"
info "List shows:"
echo "  • Deployment timestamp"
echo "  • Git commit hash"
echo "  • Synced resources"
pause

subheader "Rolling back to previous version"
info "Rollback to revision 1 (previous deployment):"
echo "$ argocd app rollback argocd-demo-app 1"
echo ""
info "Or from UI: Click revision → Rollback"
pause

# Feature 7: Multi-Environment Management
header "FEATURE 7: Multi-Environment Management"
subheader "Deploy to multiple environments from same repo"

info "Example structure:"
echo "argocd-demo-app/"
echo "├── k8s/"
echo "│   ├── base/              # Common configs"
echo "│   ├── overlays/"
echo "│   │   ├── dev/"
echo "│   │   ├── staging/"
echo "│   │   └── prod/          # Kustomize overlays"
echo "│   └── values-{env}.yaml  # Helm values per env"
pause

subheader "Creating environment-specific applications"
info "Each environment has its own Application resource:"
echo "argocd-demo-config/"
echo "├── applications/app-dev.yaml"
echo "├── applications/app-staging.yaml"
echo "└── applications/app-prod.yaml"
pause

# Feature 8: Sync Waves
header "FEATURE 8: Sync Waves - Ordered Deployments"
subheader "Deploy resources in specific order"

info "Use sync waves for dependency management:"
echo "metadata:"
echo "  annotations:"
echo "    argocd.argoproj.io/sync-wave: '0'  # Deploy first"
echo ""
echo "Example order:"
echo "  Wave 0: Namespace, ConfigMaps, Secrets"
echo "  Wave 1: Database"
echo "  Wave 2: Application"
echo "  Wave 3: Ingress/Network policies"
pause

# Feature 9: Diff & Comparison
header "FEATURE 9: Three-Way Diff"
subheader "Compare Git, Live, and Last Applied configs"

info "Three-way diff shows:"
echo "  • Git desired state (what's in repository)"
echo "  • Live state (what's running)"
echo "  • Previous state (what was last deployed)"
echo ""
info "Command:"
echo "$ argocd app diff argocd-demo-app"
pause

# Feature 10: Progressive Delivery
header "FEATURE 10: Progressive Delivery (Canary/Blue-Green)"
subheader "Safe rollouts with traffic management"

info "Integrate with Argo Rollouts for:"
echo "  • Canary deployments (gradual traffic shift)"
echo "  • Blue-green deployments (instant switch)"
echo "  • Analysis runs (validate new versions)"
pause

# Feature 11: Notifications & Webhooks
header "FEATURE 11: Notifications & Webhooks"
subheader "Integration with external systems"

info "Webhook support enables:"
echo "  • GitHub/GitLab push triggers"
echo "  • Slack notifications on sync"
echo "  • Custom event handlers"
echo "  • CI/CD pipeline integration"
pause

# Feature 12: RBAC & Multi-Tenancy
header "FEATURE 12: RBAC & Security"
subheader "Fine-grained access control"

info "ArgoCD provides:"
echo "  • Project-based access control"
echo "  • Repository-level permissions"
echo "  • Namespace restrictions"
echo "  • SSO/OIDC integration"
pause

# Wrap up
header "Demo Summary"

echo -e "${GREEN}Key Benefits of ArgoCD:${NC}\n"
echo "✓ Git as single source of truth"
echo "✓ Automated, consistent deployments"
echo "✓ Audit trail (all changes in Git)"
echo "✓ Easy rollback capability"
echo "✓ Multi-environment management"
echo "✓ Declarative configuration"
echo "✓ Real-time status visibility"
echo "✓ Progressive delivery patterns"
echo ""

echo -e "${GREEN}Use Cases:${NC}\n"
echo "✓ Continuous deployment pipelines"
echo "✓ Multi-cloud/cluster management"
echo "✓ Disaster recovery"
echo "✓ Compliance & audit"
echo "✓ Developer self-service"
echo ""

echo -e "${GREEN}Next Steps:${NC}\n"
echo "1. Explore ArgoCD UI dashboard"
echo "   kubectl port-forward -n argocd svc/argocd-server 8080:443"
echo ""
echo "2. Try manual changes:"
echo "   kubectl scale deployment frontend -n argocd-demo --replicas=5"
echo "   Watch ArgoCD detect and fix the drift!"
echo ""
echo "3. Test rollback:"
echo "   argocd app rollback argocd-demo-app 0"
echo ""
echo "4. Modify git and see auto-sync:"
echo "   Edit k8s/frontend.yaml → push → watch sync"
echo ""

echo -e "${BLUE}Thank you for exploring ArgoCD! 🚀${NC}\n"
