#!/bin/bash
# Setup custom hostname demo.argocd instead of localhost

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Setting up demo.argocd custom hostname ===${NC}\n"

# ============================================================================
# Step 1: Add to /etc/hosts
# ============================================================================
echo -e "${YELLOW}Step 1: Adding demo.argocd to /etc/hosts${NC}"

MINIKUBE_IP=$(minikube ip)
echo "Minikube IP: $MINIKUBE_IP"

# Check if already in hosts
if grep -q "demo.argocd" /etc/hosts; then
    echo " demo.argocd already in /etc/hosts"
else
    echo "Adding demo.argocd to /etc/hosts (requires sudo)..."
    echo "$MINIKUBE_IP demo.argocd" | sudo tee -a /etc/hosts > /dev/null
    echo -e "${GREEN} Added to /etc/hosts${NC}"
fi

echo ""

# ============================================================================
# Step 2: Enable Minikube Ingress
# ============================================================================
echo -e "${YELLOW}Step 2: Enabling Minikube Ingress addon${NC}"

if minikube addons list | grep -q "ingress.*enabled"; then
    echo " Ingress addon already enabled"
else
    minikube addons enable ingress
    echo -e "${GREEN} Ingress addon enabled${NC}"
fi

echo ""

# ============================================================================
# Step 3: Create Ingress resources
# ============================================================================
echo -e "${YELLOW}Step 3: Creating Ingress resources${NC}"

kubectl apply -f - << 'INGRESS_EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
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
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: backend-api
  namespace: argocd-demo
spec:
  ingressClassName: nginx
  rules:
  - host: demo.argocd
    http:
      paths:
      - path: /api/message
        pathType: Exact
        backend:
          service:
            name: backend-public
            port:
              number: 3001
      - path: /api/status
        pathType: Exact
        backend:
          service:
            name: backend-public
            port:
              number: 3001
      - path: /api/process
        pathType: Exact
        backend:
          service:
            name: backend-public
            port:
              number: 3001
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-app-redirect
  namespace: argocd-demo
  annotations:
    nginx.ingress.kubernetes.io/permanent-redirect: /app/
spec:
  ingressClassName: nginx
  rules:
  - host: demo.argocd
    http:
      paths:
      - path: /app
        pathType: Exact
        backend:
          service:
            name: frontend
            port:
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-app
  namespace: argocd-demo
  annotations:
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  ingressClassName: nginx
  rules:
  - host: demo.argocd
    http:
      paths:
      - path: /app/(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: frontend
            port:
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-manual-redirect
  namespace: argocd-demo-manual
  annotations:
    nginx.ingress.kubernetes.io/permanent-redirect: /manual/
spec:
  ingressClassName: nginx
  rules:
  - host: demo.argocd
    http:
      paths:
      - path: /manual
        pathType: Exact
        backend:
          service:
            name: frontend
            port:
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-manual
  namespace: argocd-demo-manual
  annotations:
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  ingressClassName: nginx
  rules:
  - host: demo.argocd
    http:
      paths:
      - path: /manual/(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: frontend
            port:
              number: 80
INGRESS_EOF

echo -e "${GREEN} Ingress resources created${NC}"

echo ""

# ============================================================================
# Step 4: Test connectivity
# ============================================================================
echo -e "${YELLOW}Step 4: Testing connectivity${NC}"

echo ""
echo -e "${BLUE}URLs are now available:${NC}"
echo ""
echo "  ArgoCD UI:"
echo "   http://demo.argocd"
echo "   https://demo.argocd"
echo ""
echo "  Sample App:"
echo "   http://demo.argocd/app/"
echo "   http://demo.argocd/manual/"
echo ""

echo -e "${YELLOW}Note: You may need to accept self-signed certificate for HTTPS${NC}"
echo ""

# ============================================================================
# Step 5: Show status
# ============================================================================
echo -e "${YELLOW}Step 5: Checking Ingress status${NC}"

echo ""
kubectl get ingress -n argocd
echo ""
kubectl get ingress -n argocd-demo
echo ""
kubectl get ingress -n argocd-demo-manual
echo ""

echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo -e "${YELLOW}What to do next:${NC}"
echo ""
echo "1. Wait for Ingress to get an external IP:"
echo "   watch kubectl get ingress -n argocd"
echo ""
echo "2. Open in browser:"
echo "   http://demo.argocd  (or https://demo.argocd)"
echo ""
echo "3. If it doesn't work, check:"
echo "   - /etc/hosts has correct entry: grep demo.argocd /etc/hosts"
echo "   - Ingress controller is running:"
echo "     kubectl get pods -n ingress-nginx"
echo "   - ArgoCD service is running:"
echo "     kubectl get pods -n argocd"
echo ""
echo -e "${BLUE}Alternative: Use port-forward (no Ingress needed)${NC}"
echo "  kubectl port-forward -n argocd svc/argocd-server 443:443 &"
echo "  kubectl port-forward -n argocd-demo svc/frontend 80:80 &"
echo "  # Then use https://localhost / http://localhost"
echo ""
