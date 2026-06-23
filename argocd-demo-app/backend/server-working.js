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
