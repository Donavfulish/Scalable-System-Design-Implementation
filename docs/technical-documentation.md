# Technical Documentation

## 1) Architecture Overview
See diagram: `docs/architecture.md`.

System components:
- Load balancer: Nginx (`nginx-lb`)
- Application nodes: `api-node-1`, `api-node-2`
- Database nodes: `mysql-master`, `mysql-slave`
- Replication bootstrap: `replication-setup`

## 2) Request/Data Flow
1. Client sends requests to Nginx (`localhost:8080` by default).
2. Nginx proxies requests to one of two API nodes.
3. `POST /products` writes to Master.
4. `GET /products` reads from Slave.
5. Master binary log replication keeps Slave synchronized.

## 3) Read/Write Splitting Logic
- Write connection is configured by:
  - `DB_WRITE_HOST=mysql-master`
- Read connection is configured by:
  - `DB_READ_HOST=mysql-slave`

Implementation file:
- `api/src/server.js`
- `api/src/db.js`

## 4) Replication Setup Summary
- Master:
  - `server-id=1`
  - binary log enabled
  - replication user provisioned
- Slave:
  - `server-id=2`
  - read-only mode
  - `CHANGE REPLICATION SOURCE TO ...`

Bootstrap script:
- `infra/mysql/scripts/setup-replication.sh`

## 5) Verification Procedure
1. `docker compose up -d --build`
2. `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`
3. `powershell -ExecutionPolicy Bypass -File .\scripts\chaos-test.ps1`

Expected outcomes:
- Product creation succeeds.
- GET responses include `processed_by` and alternate across nodes.
- Service continues when one node is stopped.

## 6) Evidence to Capture for Submission
- Container status (`docker compose ps`)
- Replication status logs (`docker compose logs replication-setup`)
- API output showing alternating `processed_by`
- Chaos test output showing continuous availability
