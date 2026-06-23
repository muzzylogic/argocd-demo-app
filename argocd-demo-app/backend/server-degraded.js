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
