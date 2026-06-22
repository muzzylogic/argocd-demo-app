#!/bin/bash
# Cleanup script - removes all ArgoCD demo resources

set -e

# Colors
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}This will delete all ArgoCD demo resources!${NC}"
read -p "Are you sure? (type 'yes' to confirm): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

echo -e "${BLUE}Cleaning up...${NC}\n"

# Delete applications
echo "Deleting Applications..."
kubectl delete app -n argocd argocd-demo-app argocd-demo-app-auto-sync argocd-demo-canary --ignore-not-found=true

# Delete demo namespaces
echo "Deleting demo namespaces..."
kubectl delete namespace argocd-demo argocd-demo-auto argocd-demo-canary --ignore-not-found=true

# Optional: Delete ArgoCD (keep if testing multiple demos)
read -p "Also delete ArgoCD? (yes/no): " delete_argocd

if [ "$delete_argocd" == "yes" ]; then
    echo "Deleting ArgoCD..."
    kubectl delete namespace argocd --ignore-not-found=true
fi

echo -e "${BLUE}Cleanup complete!${NC}"
