#!/bin/bash
# Build and push Docker images for local Minikube testing

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Building Docker images for ArgoCD demo...${NC}\n"

# Preflight: Docker daemon access is required for both minikube and image builds.
if ! docker info >/dev/null 2>&1; then
  echo -e "${YELLOW}Docker daemon is not accessible for user '$USER'.${NC}"
  echo "This usually means your user is not in the 'docker' group or Docker is not running."
  echo ""
  echo "Fix (Linux):"
  echo "  sudo usermod -aG docker $USER"
  echo "  newgrp docker"
  echo ""
  echo "Then ensure minikube is running and re-run this script."
  exit 1
fi

# Preflight: require an active minikube profile since we build into its Docker daemon.
if ! minikube status >/dev/null 2>&1; then
  echo -e "${YELLOW}Minikube is not running or not accessible.${NC}"
  echo "Start it and re-run this script:"
  echo "  minikube start"
  exit 1
fi

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
