#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-http://localhost:8080}"

echo "== Health check =="
curl -s "${BASE_URL}/health"
echo

echo "== Create product (write to master) =="
curl -s -X POST "${BASE_URL}/products" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Mouse-$(date +%s)\",\"price\":149.99}"
echo

echo "== Read products multiple times via load balancer =="
for i in {1..8}; do
  curl -s "${BASE_URL}/products"
  echo
  sleep 0.4
done

echo "Verification run complete."
