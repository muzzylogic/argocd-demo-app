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
