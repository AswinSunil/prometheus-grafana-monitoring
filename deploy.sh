#!/bin/bash

# === CONFIG ===
IMAGE="ghcr.io/YOUR_USERNAME/nodejs-monitoring-app:latest"
NAMESPACE="monitoring"

echo "✅ Pulling image from GitHub Container Registry..."
docker pull $IMAGE

echo "📦 Loading image into KinD cluster..."
kind load docker-image $IMAGE

echo "🚀 Applying Kubernetes manifests..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/prometheus-configmap.yaml
kubectl apply -f k8s/app-deployment.yaml
kubectl apply -f k8s/app-service.yaml
kubectl apply -f k8s/prometheus-deployment.yaml
kubectl apply -f k8s/prometheus-service.yaml
kubectl apply -f k8s/grafana-deployment.yaml
kubectl apply -f k8s/grafana-service.yaml

echo "✅ Deployment complete!"
echo "🔍 Access Prometheus: http://localhost:30090"
echo "📊 Access Grafana: http://localhost:30300 (admin / admin)"
