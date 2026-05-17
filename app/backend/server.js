const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST || 'postgres.three-tier-app.svc.cluster.local',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'appdb',
  user: process.env.DB_USER || 'appuser',
  password: process.env.DB_PASSWORD || 'supersecretpassword',
});

// Health endpoint
app.get('/api/health', async (req, res) => {
  let dbStatus = 'disconnected';
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT 1');
    client.release();
    if (result) dbStatus = 'connected';
  } catch (e) {
    console.error('Database Connectivity Failure:', e.message);
    dbStatus = 'error';
  }
  
  res.json({
    message: 'Backend API Engine Live',
    database: dbStatus,
    timestamp: new Date().toISOString(),
  });
});

// Added the missing route that the Frontend is explicitly hitting
app.get('/api/hello', async (req, res) => {
  let dbStatus = 'disconnected';
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT 1');
    client.release();
    if (result) dbStatus = 'connected';
  } catch (e) {
    console.error('Database Connectivity Failure inside hello route:', e.message);
    dbStatus = 'error';
  }

  res.json({
    message: 'Hello from the enterprise backend!',
    database: dbStatus,
    timestamp: new Date().toISOString(),
  });
});

app.use((req, res) => {
  res.status(404).json({ error: 'Route Configuration Not Found' });
});

app.listen(PORT, () => {
  console.log(`Backend core running on port ${PORT}`);
});