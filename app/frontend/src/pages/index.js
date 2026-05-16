import { useState, useEffect } from 'react';

export default function Home() {
  const [backendMessage, setBackendMessage] = useState('Connecting to System Control...');
  const [dbStatus, setDbStatus] = useState('Checking...');

  useEffect(() => {
    fetch('/api/hello')
      .then((res) => res.json())
      .then((data) => {
        setBackendMessage(data.message || 'Active');
        setDbStatus(data.database || 'Unknown');
      })
      .catch(() => {
        setBackendMessage('Backend API Gateway Unreachable');
        setDbStatus('Disconnected');
      });
  }, []);

  return (
    <div style={{ padding: '3rem', fontFamily: 'Segoe UI, Arial', backgroundColor: '#f4f6f9', minHeight: '100vh' }}>
      <div style={{ backgroundColor: '#fff', padding: '2rem', borderRadius: '8px', boxShadow: '0 4px 6px rgba(0,0,0,0.1)' }}>
        <h1 style={{ color: '#1e293b' }}>🚀 Enterprise Three-Tier GitOps Platform</h1>
        <hr style={{ border: '0.5px solid #e2e8f0' }} />
        <p style={{ fontSize: '1.2rem' }}>API Gateway Status: <strong style={{ color: '#2563eb' }}>{backendMessage}</strong></p>
        <p style={{ fontSize: '1.2rem' }}>PostgreSQL Database State: <strong style={{ color: dbStatus === 'connected' ? '#16a34a' : '#dc2626' }}>{dbStatus}</strong></p>
      </div>
    </div>
  );
}