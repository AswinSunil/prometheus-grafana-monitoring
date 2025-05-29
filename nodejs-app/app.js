const express = require('express');
const client = require('prom-client');
const app = express();
const port = 3000;

// Create a Registry to register the metrics
const register = new client.Registry();

// Create a custom counter metric
const httpRequestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status'],
});
register.registerMetric(httpRequestCounter);

// Middleware to collect metrics
app.use((req, res, next) => {
  res.on('finish', () => {
    httpRequestCounter.labels(req.method, req.path, res.statusCode).inc();
  });
  next();
});

// A test endpoint
app.get('/hello', (req, res) => {
  res.send('Hello, world!');
});

// Metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
