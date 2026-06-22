# ArgoCD Demo Application

This repository contains a sample web application with a backend service designed for ArgoCD demonstrations.

## Project Structure

- `backend/` - Node.js/Express backend service
- `frontend/` - React frontend application
- `k8s/` - Kubernetes manifests for deploying the application
- `docker/` - Dockerfiles for building container images

## Quick Start

### Build and Push Images

```bash
# Build backend image
docker build -f docker/backend.Dockerfile -t your-registry/argocd-demo-backend:latest backend/

# Build frontend image
docker build -f docker/frontend.Dockerfile -t your-registry/argocd-demo-frontend:latest frontend/

# Push to registry
docker push your-registry/argocd-demo-backend:latest
docker push your-registry/argocd-demo-frontend:latest
```

### Deploy with ArgoCD

ArgoCD will automatically deploy the application using the manifests in the `k8s/` directory. See the ArgoCD config repository for Application CRDs.

## Application Features

- **Frontend**: Simple React app showing greeting and data from backend
- **Backend**: Express.js API with health check and data endpoints
- **Kubernetes**: StatefulSet for backend, Deployment for frontend, Services, ConfigMaps

