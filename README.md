# Scalable Backend Infrastructure - Assignment 2

This project implements:
- Nginx load balancer (single entry point)
- 2 API nodes (Node.js + Express)
- MySQL master-slave replication
- Read/write splitting:
  - `POST /products` -> Master
  - `GET /products` -> Slave

## Quick Start
1. Start stack:
   - `docker compose up -d --build`
2. Verify:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`
3. Chaos test:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\chaos-test.ps1`
4. One-click video flow:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\video-demo.ps1`

## Main Files
- `docker-compose.yml`
- `infra/nginx/nginx.conf`
- `infra/mysql/master/init/01-master-init.sql`
- `infra/mysql/scripts/setup-replication.sh`
- `api/src/server.js`
- `docs/setup-guide.md`
- `docs/architecture.md`
- `docs/configuration-snippets.md`
- `docs/video-demo-script.md`
- `docs/acceptance-checklist.md`
