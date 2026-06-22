#!/bin/bash
# ArgoCD Demo Setup Script
# This script sets up Minikube, installs ArgoCD, and prepares for demos

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== ArgoCD Demo Setup ===${NC}\n"

# 1. Start Minikube
echo -e "${BLUE}[1/6] Starting Minikube...${NC}"
if ! command -v minikube &> /dev/null; then
    echo -e "${YELLOW}Minikube not found. Please install it first:${NC}"
    echo "brew install minikube  # macOS"
    echo "choco install minikube  # Windows"
    exit 1
fi

minikube start --cpus=4 --memory=8192 --driver=docker
echo -e "${GREEN}✓ Minikube started${NC}\n"

# 2. Create argocd namespace
echo -e "${BLUE}[2/6] Creating ArgoCD namespace...${NC}"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
echo -e "${GREEN}✓ Namespace created${NC}\n"

# 3. Install ArgoCD
echo -e "${BLUE}[3/6] Installing ArgoCD...${NC}"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo -e "${GREEN}✓ ArgoCD components installing...${NC}"

# Wait for ArgoCD to be ready
echo -e "${BLUE}Waiting for ArgoCD to be ready...${NC}"
kubectl rollout status deployment/argocd-server -n argocd --timeout=5m
kubectl rollout status deployment/argocd-application-controller -n argocd --timeout=5m
echo -e "${GREEN}✓ ArgoCD ready${NC}\n"

# 4. Create argocd-demo namespace
echo -e "${BLUE}[4/6] Creating demo namespace...${NC}"
kubectl create namespace argocd-demo --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace argocd-demo-auto --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace argocd-demo-canary --dry-run=client -o yaml | kubectl apply -f -
echo -e "${GREEN}✓ Demo namespaces created${NC}\n"

# 5. Configure local git repository (optional - for local testing)
echo -e "${BLUE}[5/6] Setting up local repositories...${NC}"
cd "$(dirname "$0")/.."
if [ ! -d ".git" ]; then
    git init
    git config user.email "demo@argocd.local"
    git config user.name "ArgoCD Demo"
    git add .
    git commit -m "Initial commit - ArgoCD demo setup"
    echo -e "${GREEN}✓ Git repository initialized${NC}"
else
    echo -e "${GREEN}✓ Git repository already initialized${NC}"
fi
echo ""

# 6. Display next steps
echo -e "${BLUE}[6/6] Setup complete!${NC}\n"
echo -e "${GREEN}Next steps:${NC}"
echo ""
echo "1. Update git repository URLs in applications/app.yaml"
echo "   Replace: https://github.com/your-username/argocd-demo-app"
echo ""
echo "2. Build and push Docker images (optional - for using local images):"
echo "   docker build -f docker/backend.Dockerfile -t argocd-demo-backend:1.0.0 ."
echo "   docker build -f docker/frontend.Dockerfile -t argocd-demo-frontend:1.0.0 ."
echo ""
echo "3. Access ArgoCD UI:"
echo "   kubectl port-forward -n argocd svc/argocd-server 8080:443"
echo "   URL: https://localhost:8080"
echo "   Username: admin"
echo "   Password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""
echo ""
echo "4. Create an ArgoCD Application:"
echo "   kubectl apply -f argocd-demo-config/applications/app.yaml"
echo ""
echo "5. View Minikube dashboard (optional):"
echo "   minikube dashboard"
echo ""
echo -e "${BLUE}Demo ready! Run ./scripts/demo.sh to start the interactive demo.${NC}"
