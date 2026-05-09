# Production Plan - Scalable System Design & Implementation

## 1. Purpose and Success Target
This plan is the execution baseline to complete **100% Deliverables** and maximize score in **Evaluation Criteria** defined in `requirements.md`.

Primary success target:
- Deliver full **Advanced Implementation (2.0 points)**:
  - Load Balancer + 2 API Nodes + Master-Slave Replication + Read/Write Splitting.
- Pass all scoring dimensions:
  - System Functionality (40%)
  - Read/Write Splitting (20%)
  - Fault Tolerance (10%)
  - Documentation Quality (15%)
  - Video Presentation (15%)

## 2. Scope

### In Scope
- Database replication (Master -> Slave).
- REST API with write to Master and read from Slave.
- 2 API nodes running concurrently.
- Nginx (or HAProxy) load balancer with request distribution.
- Test and verification scripts for normal and failure scenarios.
- Complete documentation package and demo script for video.

### Out of Scope (for now)
- Horizontal autoscaling with orchestrators (Kubernetes).
- Multi-region deployment.
- Advanced security hardening beyond assignment requirements.

## 3. Target Architecture (Implementation Baseline)
- **Entry point:** Load balancer (`nginx` preferred for simplicity).
- **Backend:** `api-node-1`, `api-node-2` (same codebase, different runtime identity).
- **Database:**
  - `db-master`: write source, also supports reads.
  - `db-slave`: read replica, synced from master.
- **API Behavior:**
  - `POST /products` -> always uses Master connection.
  - `GET /products` -> always uses Slave connection.
  - Include `processed_by` in GET response to prove LB behavior.

## 4. Execution Strategy
Project is executed in **5 sprints** (phase-based) with strict Definition of Done and acceptance checks after each sprint.

- Sprint 0: Foundation and project skeleton.
- Sprint 1: Database replication setup and validation.
- Sprint 2: API implementation + read/write splitting.
- Sprint 3: Load balancer + two-node deployment + failover behavior.
- Sprint 4: Final verification, deliverables hardening, and submission pack.

## 5. Way of Working (Per-Sprint Cycle)
Each sprint follows this mandatory workflow:

1. **Planning**
   - Confirm sprint goal and expected artifacts.
   - Break tasks into implementation, test, and docs updates.
   - Identify dependencies and risks.

2. **Implementation**
   - Build only sprint-scoped features.
   - Keep config reproducible (prefer Docker Compose).
   - Keep logs and evidence for documentation/video.

3. **Test**
   - Run smoke tests and sprint-specific test checklist.
   - Capture command outputs/screenshots as proof.
   - Validate against acceptance criteria table in this plan.

4. **Review**
   - Cross-check implementation against `requirements.md`.
   - Ensure no requirement regression from previous sprint.
   - Verify reproducibility from clean environment.

5. **Retro**
   - Record what worked, what blocked, and corrective actions.
   - Update next sprint plan based on issues found.

## 6. Sprint-by-Sprint Plan

## Sprint 0 - Foundation and Working Skeleton
### Objective
Create reproducible baseline structure to accelerate all next phases.

### Key Tasks
- Set up repository structure:
  - `infra/` for Nginx and DB configs.
  - `api/` for application source.
  - `docs/` for architecture and setup instructions.
  - `scripts/` for automated checks.
- Prepare `docker-compose.yml` draft with services placeholders:
  - `nginx`, `api-node-1`, `api-node-2`, `db-master`, `db-slave`.
- Define environment strategy using `.env` and service-specific env files.
- Add health endpoint design (`GET /health`) for API nodes.

### Outputs
- Bootstrapped project structure.
- Initial compose file and env templates.
- Sprint test checklist template.

### Exit Criteria
- Team can start all core containers (even if API/replication not complete yet).
- All service names and network aliases finalized.

## Sprint 1 - Database Replication Setup
### Objective
Build and verify Master-Slave replication.

### Key Tasks
- Configure Master DB:
  - Binary logging enabled.
  - Replication user created.
  - Server ID set.
- Configure Slave DB:
  - Distinct server ID.
  - Master host credentials.
  - Replication start command.
- Add initialization scripts:
  - Schema and `products` table.
  - Replication bootstrap if required.
- Verification:
  - Insert sample row in Master.
  - Query Slave and confirm synced data.

### Tests
- `SHOW MASTER STATUS` valid on master.
- `SHOW SLAVE STATUS` / replica status indicates healthy sync.
- Replication lag check in basic scenario.

### Outputs
- Working DB replication with reproducible config.
- Proof logs/screenshots for documentation.

### Exit Criteria
- Every inserted record on Master appears in Slave.
- Replication restarts correctly after container restart.

## Sprint 2 - API and Read/Write Splitting
### Objective
Implement API endpoints and strict query routing.

### Key Tasks
- Implement `POST /products`:
  - Validate payload (`name`, `price`).
  - Insert using **Master DB client only**.
- Implement `GET /products`:
  - Select using **Slave DB client only**.
  - Return `processed_by` metadata from node identity env var.
- Add error handling and structured API responses.
- Add `/health` endpoint including DB connectivity checks.

### Tests
- Unit/integration tests for input validation.
- Integration test verifies:
  - POST writes to Master.
  - GET reads from Slave.
- Negative test for invalid payload.

### Outputs
- Functional API service image.
- Test cases + pass evidence.

### Exit Criteria
- API endpoints match required behavior exactly.
- Query routing logic is explicit and test-proven.

## Sprint 3 - Load Balancing and Fault Tolerance
### Objective
Run two API nodes behind load balancer and validate resilience.

### Key Tasks
- Deploy `api-node-1` and `api-node-2` from same image.
- Configure Nginx upstream:
  - Round Robin (default) or Least Connections.
  - Proxy to both nodes.
- Add/enable health checks (recommended).
- Verify alternating `processed_by` from repeated GET calls.
- Chaos test:
  - Stop one node.
  - Confirm system still serves requests via remaining node.

### Tests
- Repeated GET calls through LB show both nodes in responses.
- During node failure:
  - No total outage.
  - Successful responses continue from healthy node.

### Outputs
- Stable load-balanced runtime.
- Fault tolerance proof logs.

### Exit Criteria
- LB functions as single entry point.
- Node failure does not break service availability.

## Sprint 4 - Final Verification and Deliverables
### Objective
Finalize artifacts for submission and scoring optimization.

### Key Tasks
- Compile technical documentation:
  - Architecture diagram.
  - Key config snippets (LB, DB replication, API split logic).
  - Reproducible setup guide.
- Build demo script for 5-10 minute video:
  - Code/config walkthrough.
  - POST to Master demo.
  - GET balanced response demo.
  - Chaos test demo.
- Run final end-to-end test suite from clean start.
- Prepare submission package format.

### Tests
- Full runbook test on clean environment.
- Checklist pass for all deliverables.

### Outputs
- Final docs + demo script.
- Submission-ready repository/ZIP assets.

### Exit Criteria
- 100% `requirements.md` deliverables checked off.
- Project is ready to record and submit.

## 7. Acceptance Criteria Matrix (Traceable to requirements.md)

## A. Functional and Architecture Acceptance
- **AC-01 (LB Entry Point):** All client traffic goes through load balancer URL only.
- **AC-02 (2 API Nodes):** Two API instances run simultaneously and are reachable by LB upstream.
- **AC-03 (Replication):** Data inserted into Master appears in Slave replica.
- **AC-04 (Write Path):** `POST /products` writes to Master DB.
- **AC-05 (Read Path):** `GET /products` reads from Slave DB.
- **AC-06 (LB Proof):** `GET /products` returns `processed_by` showing alternating nodes.
- **AC-07 (Fault Tolerance):** If one API node stops, system still serves requests.

## B. Deliverables Acceptance
- **AC-08 (Architecture Diagram):** Documentation contains a clear architecture diagram.
- **AC-09 (Config Snippets):** Documentation includes LB config, DB replication config, and API DB split logic.
- **AC-10 (Setup Guide):** Documentation has complete reproducible step-by-step setup.
- **AC-11 (Video Content):** Demo video includes walkthrough + POST demo + GET balancing demo + chaos test.
- **AC-12 (Submission Format):** Final package follows `[MSSV].zip` requirement with required links/files.

## C. Evaluation Alignment Acceptance
- **AC-13 (System Functionality 40%):** End-to-end stack works consistently in repeated tests.
- **AC-14 (Read/Write Splitting 20%):** Query routing is implemented and evidenced.
- **AC-15 (Fault Tolerance 10%):** One-node failure scenario validated live.
- **AC-16 (Documentation Quality 15%):** Docs are concise, accurate, and reproducible by peer.
- **AC-17 (Video Quality 15%):** Demo is clear, professional, and successfully executed.

## 8. Risks and Mitigation
- **Replication misconfiguration:** Use deterministic init scripts and explicit server IDs.
- **Replica read inconsistency timing:** Add tiny retry/wait in demo when validating immediately after write.
- **LB not showing both nodes predictably:** Use repeated calls loop and clear node ID field.
- **Last-minute demo failure:** Pre-record dry run and maintain rollback scripts.

## 9. Evidence Collection Plan
To maximize scoring and avoid disputes, keep evidence for each AC:
- Terminal outputs for replication checks.
- Curl/Postman collections for API and LB behavior.
- Screenshots of node failover behavior.
- Final checklist mapping artifact -> acceptance criteria.

## 10. Definition of Done (Project Level)
Project is done only when all are true:
- All `requirements.md` sections 2, 3, 4, 5 are implemented and validated.
- All acceptance criteria AC-01 to AC-17 are marked pass with evidence.
- Documentation and demo script are complete and polished.
- Repository/submission package is ready without missing dependencies.
