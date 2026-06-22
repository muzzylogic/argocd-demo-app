import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [backendData, setBackendData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchBackendData();
    // Refresh every 5 seconds for demo purposes
    const interval = setInterval(fetchBackendData, 5000);
    return () => clearInterval(interval);
  }, []);

  const fetchBackendData = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/message');
      if (!response.ok) throw new Error('Failed to fetch');
      const data = await response.json();
      setBackendData(data);
      setError(null);
    } catch (err) {
      setError(err.message);
      setBackendData(null);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>🎯 ArgoCD Demo Application</h1>
        <p>GitOps Continuous Deployment Example</p>
      </header>

      <main className="container">
        <section className="card">
          <h2>Backend Status</h2>
          {loading && <p>Loading...</p>}
          {error && <p className="error">Error: {error}</p>}
          {backendData && (
            <div className="data">
              <p><strong>Message:</strong> {backendData.message}</p>
              <p><strong>Version:</strong> {backendData.version}</p>
              <p><strong>Environment:</strong> {backendData.environment}</p>
              <p><strong>Replica:</strong> {backendData.replica}</p>
              <p><strong>Timestamp:</strong> {new Date(backendData.timestamp).toLocaleString()}</p>
            </div>
          )}
          <button onClick={fetchBackendData}>Refresh</button>
        </section>

        <section className="card">
          <h2>Demo Features</h2>
          <ul>
            <li>✅ Automated Deployments from Git</li>
            <li>✅ Multi-Environment Support</li>
            <li>✅ Real-time Synchronization</li>
            <li>✅ Rollback Capabilities</li>
            <li>✅ Progressive Delivery</li>
            <li>✅ Application Health Monitoring</li>
          </ul>
        </section>

        <section className="card">
          <h2>ArgoCD Features to Explore</h2>
          <ul>
            <li>Auto Sync vs Manual Sync</li>
            <li>Sync Waves for ordered deployments</li>
            <li>Health monitoring and status</li>
            <li>Diff and history tracking</li>
            <li>Multi-repo and multi-cluster support</li>
            <li>Progressive delivery strategies</li>
          </ul>
        </section>
      </main>
    </div>
  );
}

export default App;
