#!/bin/bash
# Build and push Docker images for local Minikube testing

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Building Docker images for ArgoCD demo...${NC}\n"

# Get the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$DIR")"

# For Minikube, we can use the Docker daemon inside Minikube
echo "Setting up Docker environment for Minikube..."
eval $(minikube docker-env)
echo -e "${GREEN} Docker environment configured${NC}\n"

# Build backend
echo -e "${BLUE}Building backend image...${NC}"
docker build -f "$PROJECT_ROOT/argocd-demo-app/docker/backend.Dockerfile" \
  -t argocd-demo-backend:1.0.0 \
  "$PROJECT_ROOT/argocd-demo-app"
echo -e "${GREEN} Backend image built${NC}\n"

# Build frontend
echo -e "${BLUE}Building frontend image...${NC}"
docker build -f "$PROJECT_ROOT/argocd-demo-app/docker/frontend.Dockerfile" \
  -t argocd-demo-frontend:1.0.0 \
  "$PROJECT_ROOT/argocd-demo-app"
echo -e "${GREEN} Frontend image built${NC}\n"

# List images
echo -e "${BLUE}Built images:${NC}"
docker images | grep argocd-demo

echo ""
echo -e "${GREEN}Images ready in Minikube!${NC}"
echo ""
echo "Update the image references in k8s manifests:"
echo "  - Change image pull policy to IfNotPresent"
echo "  - Use image names: argocd-demo-backend:1.0.0"
echo "                    argocd-demo-frontend:1.0.0"
