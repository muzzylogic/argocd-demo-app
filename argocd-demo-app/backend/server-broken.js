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
