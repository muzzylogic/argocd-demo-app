#!/bin/bash
# Build multiple image versions for demo scenarios
# - Version 1.0.0: Working normally
# - Version 1.0.1: Simulated crash (fails health check)
# - Version 1.0.2: Degraded (slow responses)

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Building multiple image versions for demo scenarios...${NC}\n"

# Setup Minikube Docker environment
echo "Setting up Docker environment for Minikube..."
eval $(minikube docker-env)
echo -e "${GREEN} Docker environment configured${NC}\n"

# Get project root
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$DIR")"

# ============================================================================
# Version 1.0.0 - WORKING VERSION (Default)
# ============================================================================
echo -e "${BLUE}[1/3] Building WORKING version (1.0.0)...${NC}"

# Backend working version
cat > "$PROJECT_ROOT/argocd-demo-app/backend/server-working.js" << 'BACKEND_EOF'
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', version: '1.0.0' });
});

// API endpoint that returns data
app.get('/api/message', (req, res) => {
  res.json({
    message: ' Backend is working normally!',
    version: '1.0.0',
    environment: 'production',
    status: 'healthy',
    timestamp: new Date().toISOString(),
    replica: process.env.HOSTNAME || 'unknown'
  });
});

// Status endpoint
app.get('/api/status', (req, res) => {
  res.json({
    uptime: process.uptime(),
    status: 'operational',
    version: '1.0.0'
  });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(` Backend 1.0.0 running on port ${PORT}`);
});
BACKEND_EOF

docker build -f "$PROJECT_ROOT/argocd-demo-app/docker/backend.Dockerfile" \
  -t argocd-demo-backend:1.0.0 \
  "$PROJECT_ROOT/argocd-demo-app"

echo -e "${GREEN} Backend 1.0.0 built${NC}\n"

# ============================================================================
# Version 1.0.1 - BROKEN VERSION (Simulate crash)
# ============================================================================
echo -e "${BLUE}[2/3] Building BROKEN version (1.0.1 - Crashed)...${NC}"

# Backend broken version - fails health checks
cat > "$PROJECT_ROOT/argocd-demo-app/backend/server-broken.js" << 'BACKEND_BROKEN_EOF'
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// Health check endpoint - FAILS
app.get('/health', (req, res) => {
  res.status(500).json({ 
    status: 'unhealthy',
    error: 'Critical service failure',
    version: '1.0.1'
  });
});

// API endpoint - Returns error
app.get('/api/message', (req, res) => {
  res.status(500).json({
    error: ' Backend service is DOWN',
    version: '1.0.1',
    message: 'Database connection failed',
    status: 'error'
  });
});

// Status endpoint - Reports down
app.get('/api/status', (req, res) => {
  res.status(503).json({
    status: 'unavailable',
    error: 'Service crashed',
    version: '1.0.1'
  });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(` Backend 1.0.1 BROKEN VERSION running on port ${PORT}`);
  console.log('  This version fails health checks');
});
BACKEND_BROKEN_EOF

# Create Dockerfile for broken version with same content
cat > "$PROJECT_ROOT/argocd-demo-app/docker/backend-broken.Dockerfile" << 'DOCKERFILE_EOF'
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY backend/package*.json ./

# Install dependencies
RUN npm install --omit=dev

# Copy BROKEN application code
COPY backend/server-broken.js server.js

# Expose port
EXPOSE 3001

# Health check - will fail for broken version
HEALTHCHECK --interval=5s --timeout=3s --start-period=2s --retries=2 \
  CMD node -e "require('http').get('http://localhost:3001/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Start application
CMD ["node", "server.js"]
DOCKERFILE_EOF

docker build -f "$PROJECT_ROOT/argocd-demo-app/docker/backend-broken.Dockerfile" \
  -t argocd-demo-backend:1.0.1 \
  "$PROJECT_ROOT/argocd-demo-app"

echo -e "${GREEN} Backend 1.0.1 (Broken) built${NC}\n"

# ============================================================================
# Version 1.0.2 - DEGRADED VERSION (Slow responses)
# ============================================================================
echo -e "${BLUE}[3/3] Building DEGRADED version (1.0.2 - Slow)...${NC}"

# Backend degraded version - slow responses
cat > "$PROJECT_ROOT/argocd-demo-app/backend/server-degraded.js" << 'BACKEND_DEGRADED_EOF'
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// Health check endpoint - slow but works
app.get('/health', (req, res) => {
  setTimeout(() => {
    res.json({ status: 'degraded', version: '1.0.2', responseTime: '3000ms' });
  }, 3000);
});

// API endpoint - responds but slowly
app.get('/api/message', (req, res) => {
  setTimeout(() => {
    res.json({
      message: ' Backend responding slowly (performance issue)',
      version: '1.0.2',
      environment: 'production',
      status: 'degraded',
      responseTime: '5000ms',
      timestamp: new Date().toISOString(),
      replica: process.env.HOSTNAME || 'unknown',
      warning: 'High latency detected'
    });
  }, 5000);
});

// Status endpoint - slow
app.get('/api/status', (req, res) => {
  setTimeout(() => {
    res.json({
      uptime: process.uptime(),
      status: 'degraded',
      version: '1.0.2',
      latency: 'high'
    });
  }, 3000);
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`  Backend 1.0.2 DEGRADED VERSION running on port ${PORT}`);
  console.log(' Simulating slow responses');
});
BACKEND_DEGRADED_EOF

# Create Dockerfile for degraded version
cat > "$PROJECT_ROOT/argocd-demo-app/docker/backend-degraded.Dockerfile" << 'DOCKERFILE_DEGRADED_EOF'
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY backend/package*.json ./

# Install dependencies
RUN npm install --omit=dev

# Copy DEGRADED application code
COPY backend/server-degraded.js server.js

# Expose port
EXPOSE 3001

# Health check - slow but will eventually pass
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=2 \
  CMD node -e "require('http').get('http://localhost:3001/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Start application
CMD ["node", "server.js"]
DOCKERFILE_DEGRADED_EOF

docker build -f "$PROJECT_ROOT/argocd-demo-app/docker/backend-degraded.Dockerfile" \
  -t argocd-demo-backend:1.0.2 \
  "$PROJECT_ROOT/argocd-demo-app"

echo -e "${GREEN} Backend 1.0.2 (Degraded) built${NC}\n"

# ============================================================================
# Summary
# ============================================================================
echo -e "${BLUE}${NC}"
echo -e "${GREEN} All image versions built successfully!${NC}"
echo -e "${BLUE}${NC}\n"

echo -e "${GREEN}Available images:${NC}\n"
docker images | grep argocd-demo-backend

echo ""
echo -e "${YELLOW}Demo Scenarios:${NC}\n"

echo " WORKING VERSION (1.0.0)"
echo "  - Health checks pass"
echo "  - Fast responses"
echo "  - All endpoints work normally"
echo "  - Use: kubectl set image deployment/backend backend=argocd-demo-backend:1.0.0"
echo ""

echo " BROKEN VERSION (1.0.1)"
echo "  - Health checks FAIL"
echo "  - Returns 500 errors"
echo "  - Pods will CrashLoopBackOff"
echo "  - DEMO: Show pods crashing, then rollback"
echo "  - Use: kubectl set image deployment/backend backend=argocd-demo-backend:1.0.1"
echo ""

echo " DEGRADED VERSION (1.0.2)"
echo "  - Health checks pass (slowly)"
echo "  - Extremely slow responses (5-10 seconds)"
echo "  - Health shows as degraded"
echo "  - DEMO: Show slow response times, monitoring alert"
echo "  - Use: kubectl set image deployment/backend backend=argocd-demo-backend:1.0.2"
echo ""

echo -e "${BLUE}Demo Workflow:${NC}\n"
echo "1. Start with 1.0.0 (working)"
echo "2. Show everything green and healthy"
echo "3. Switch to 1.0.1 (broken)"
echo "4. Show pods failing health checks"
echo "5. Show ArgoCD detecting the issue"
echo "6. ROLLBACK to 1.0.0 in ArgoCD UI"
echo "7. Watch pods recover in seconds"
echo ""
echo "Alternative: Try 1.0.2 to show performance degradation"
echo ""

echo -e "${YELLOW}Or use argocd app commands:${NC}"
echo "  argocd app sync argocd-demo-app --force"
echo "  kubectl set image -n argocd-demo sts/backend backend=argocd-demo-backend:1.0.1"
echo "  argocd app rollback argocd-demo-app 0"
echo ""
