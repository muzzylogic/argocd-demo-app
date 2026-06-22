const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', version: process.env.APP_VERSION || '1.0' });
});

// API endpoint that returns data
app.get('/api/message', (req, res) => {
  const version = process.env.APP_VERSION || '1.0';
  const environment = process.env.ENVIRONMENT || 'development';
  
  res.json({
    message: 'Hello from ArgoCD Demo Backend!',
    version: version,
    environment: environment,
    timestamp: new Date().toISOString(),
    replica: process.env.HOSTNAME || 'unknown'
  });
});

// Status endpoint
app.get('/api/status', (req, res) => {
  res.json({
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    deployment: process.env.ENVIRONMENT || 'development'
  });
});

// Endpoint to simulate some processing
app.post('/api/process', (req, res) => {
  res.json({
    status: 'processed',
    data: req.body,
    processedAt: new Date().toISOString()
  });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Backend server running on port ${PORT}`);
  console.log(`Environment: ${process.env.ENVIRONMENT || 'development'}`);
  console.log(`Version: ${process.env.APP_VERSION || '1.0'}`);
});
