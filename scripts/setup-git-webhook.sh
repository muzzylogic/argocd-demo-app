#!/bin/bash
# Setup ArgoCD to watch local GitHub repository with webhook support

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== ArgoCD Git Webhook Setup ===${NC}\n"

echo -e "${BLUE}Option 1: Using GitHub.com (Remote)${NC}"
echo "1. Push your repo to GitHub"
echo "2. Update repo URL in applications/app.yaml:"
echo "   repoURL: https://github.com/muzzylogic/argocd-demo-app"
echo "3. Add GitHub Webhook:"
echo "   - Go to repo Settings → Webhooks → Add webhook"
echo "   - Payload URL: http://<your-argocd-server>:80/api/webhook"
echo "   - Content type: application/json"
echo "   - Trigger on push events"
echo ""

echo -e "${BLUE}Option 2: Using Local Git Server${NC}"
echo "1. Create a bare git repository:"
echo "   mkdir /path/to/argocd-demo-app.git"
echo "   cd /path/to/argocd-demo-app.git"
echo "   git init --bare"
echo ""
echo "2. Add post-receive hook for webhooks:"
echo "   echo '#!/bin/bash' > hooks/post-receive"
echo "   echo 'curl -X POST http://localhost:8080/api/webhook -d @-' >> hooks/post-receive"
echo "   chmod +x hooks/post-receive"
echo ""
echo "3. Add as git remote:"
echo "   git remote add local /path/to/argocd-demo-app.git"
echo "   git push local master"
echo ""
echo "4. Update repo URL in applications/app.yaml:"
echo "   repoURL: /path/to/argocd-demo-app.git  # or file:// URL"
echo ""

echo -e "${BLUE}Option 3: Using SSH (Recommended for Self-Hosted)${NC}"
echo "1. Generate SSH key for ArgoCD:"
echo "   ssh-keygen -t rsa -b 4096 -f ~/.ssh/argocd-repo -N ''"
echo ""
echo "2. Add public key to git server authorization"
echo ""
echo "3. Update repo URL in applications/app.yaml:"
echo "   repoURL: git@github.com:muzzylogic/argocd-demo-app.git"
echo ""

echo -e "${BLUE}Option 4: Webhook-less (Polling)${NC}"
echo "ArgoCD polls git repository every 3 minutes by default"
echo "No webhook needed - just push changes"
echo "Delay: ~3 minutes before sync (configurable)"
echo ""

echo -e "${YELLOW}How to enable Webhook in ArgoCD:${NC}"
echo ""
echo "1. Check ArgoCD webhook service:"
echo "   kubectl get svc -n argocd | grep webhook"
echo ""
echo "2. Port-forward webhook service (if needed):"
echo "   kubectl port-forward -n argocd svc/argocd-webhook 8080:80 &"
echo ""
echo "3. Add repo to ArgoCD with SSH key:"
echo "   argocd repo add git@github.com:YOUR-USER/argocd-demo-app.git \\"
echo "     --ssh-private-key-path ~/.ssh/argocd-repo"
echo ""

echo -e "${BLUE}For this demo:${NC}"
echo " We'll use polling (simple, no webhook needed)"
echo " ArgoCD checks git every 3 minutes"
echo " Or manually sync with: argocd app sync argocd-demo-app"
echo ""

echo -e "${YELLOW}Pro Tip for faster sync:${NC}"
echo "Enable webhook for instant sync on push:"
echo "1. Get webhook URL:"
echo "   kubectl get svc -n argocd argocd-server"
echo ""
echo "2. Use GitHub → Settings → Webhooks:"
echo "   URL: https://YOUR-ARGOCD-DOMAIN/api/webhook"
echo ""

echo -e "${GREEN}ArgoCD git watching is ready!${NC}"
echo ""
echo "Test it:"
echo "  1. Make a git change"
echo "  2. git push"
echo "  3. Either wait 3 min (polling) or manually: argocd app sync"
echo "  4. Watch ArgoCD sync automatically!"
