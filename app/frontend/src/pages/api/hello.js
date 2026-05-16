export default async function handler(req, res) {
  try {
    const backendUrl = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://backend.three-tier-app.svc.cluster.local:4000';
    const response = await fetch(`${backendUrl}/api/health`);
    const data = await response.json();
    res.status(200).json({ message: data.message, database: data.database });
  } catch (error) {
    res.status(500).json({ message: 'BFF Proxy Connection Failed', database: 'error' });
  }
}