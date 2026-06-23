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
