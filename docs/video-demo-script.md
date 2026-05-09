# Video Demonstration Script (5-10 Minutes)

## Segment 1 - Architecture and Code Walkthrough (1-2 min)
- Show `docs/architecture.md`.
- Explain request flow:
  - Client -> Nginx -> API Node 1/2
  - POST -> Master
  - GET -> Slave
  - Master replicates to Slave
- Open and briefly show:
  - `docker-compose.yml`
  - `infra/nginx/nginx.conf`
  - `api/src/server.js`

## Segment 2 - Live Demo Core Flow (2-3 min)
1. Start stack:
   - `docker compose up -d --build`
2. Run verification script:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`
3. Highlight:
   - POST creates product.
   - GET returns products from slave path.
   - `processed_by` alternates between Node_1 and Node_2.

## Segment 3 - Chaos Test (1-2 min)
1. Stop one node:
   - `docker compose stop api-node-1`
2. Send repeated GET requests via load balancer.
3. Show requests still succeed through remaining node.
4. Start node back:
   - `docker compose start api-node-1`

## Segment 4 - Close with Requirement Mapping (1-2 min)
- Deliverables:
  - Architecture diagram
  - Config snippets
  - Setup guide
- Evaluation criteria:
  - Functionality
  - Read/write splitting
  - Fault tolerance
  - Documentation completeness
