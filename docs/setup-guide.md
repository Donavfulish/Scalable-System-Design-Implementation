# Setup Guide

## Prerequisites
- Docker Desktop (with `docker compose` enabled)
- PowerShell 7+ (or Windows PowerShell)

## 1) Project Setup
1. Open terminal at project root.
2. (Optional) copy env file:
   - `Copy-Item .env.example .env`
3. Start all services:
   - `docker compose up -d --build`

## 2) Verify Service Status
- Check containers:
  - `docker compose ps`
- Check replication setup logs:
  - `docker compose logs replication-setup`

Expected:
- `mysql-master`, `mysql-slave`, `api-node-1`, `api-node-2`, `nginx-lb` are running.
- Replication setup completes successfully.

## 3) API Verification (Normal Flow)
- Run:
  - `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`

This script validates:
- Health endpoint.
- Write path via `POST /products`.
- Read path via `GET /products`.
- `processed_by` toggles between nodes through load balancer.

## 4) Chaos Test (Fault Tolerance)
- Run:
  - `powershell -ExecutionPolicy Bypass -File .\scripts\chaos-test.ps1`

This test:
- Stops `api-node-1`.
- Sends repeated requests to verify service still works.
- Restarts `api-node-1`.

## 5) Shutdown
- `docker compose down`

To remove volumes (clean database):
- `docker compose down -v`
