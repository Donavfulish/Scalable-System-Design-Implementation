# Scalable System Design & Implementation Requirements

## Project Information
- **Project Level:** Intermediate
- **Focus Area:** Infrastructure, Load Balancing, and Database Scaling (Read/Write Splitting)
- **Objective:** Build a functional scalable backend infrastructure from scratch, focusing on traffic distribution and data consistency across multiple nodes.

## 1) Project Overview
This project goes beyond basic application development and emphasizes infrastructure design.  
The system must support:
- Load-balanced traffic across multiple API nodes.
- Database replication with master-slave architecture.
- Correct query routing for read/write splitting.

## 2) Required System Architecture
The implementation must include the following components:

### A. Load Balancer (Nginx or HAProxy)
- Acts as the **single entry point** for client requests.
- Distributes traffic to backend API nodes using:
  - **Round Robin**, or
  - **Least Connections** algorithm.
- Health checks are optional but recommended.

### B. Application Layer (2 API Nodes)
- Two identical REST API instances.
- Can run on separate ports, virtual machines, or containers.
- Suggested stack: Node.js, Python, Go, etc.

### C. Database Layer (Master-Slave Replication)
- **Master Node:** Handles all write operations and can also handle reads.
- **Slave Node (Read Replica):** Replicates data from Master and handles read operations.

## 3) Functional API Requirements
API logic remains simple; the emphasis is infrastructure behavior.

### Endpoint: `POST /products`
- **Action:** Validate and save product data (`name`, `price`) into the **Master DB**.
- **Response:** Success message and created product payload.

### Endpoint: `GET /products`
- **Action:** Fetch product list from the **Slave DB**.
- **Response:**
  - Product list
  - Server metadata (example: `"processed_by": "Node_A"`) to demonstrate load balancing.

## 4) Technical Implementation Phases
You must document and record each phase below.

### Phase 1: Database Replication Setup
1. Configure Master node.
2. Configure Slave node.
3. Verify synchronization:
   - Insert data into Master.
   - Confirm replicated data exists on Slave.

### Phase 2: API Development & Read/Write Splitting
1. Implement API endpoints.
2. Configure **two DB connections**:
   - Write connection -> Master DB.
   - Read connection -> Slave DB.

### Phase 3: Infrastructure & Load Balancing
1. Deploy two API instances.
2. Configure Load Balancer to proxy traffic to both nodes.
3. (Optional) Add backend health checks.

### Phase 4: Verification & Stress Test
1. Send multiple requests with curl/Postman.
2. Verify server metadata alternates between Node 1 and Node 2.
3. Verify write-to-master data is visible via read-from-slave.

## 5) Deliverables

### A. Technical Documentation (PDF or Markdown)
Must include:
1. **System Architecture Diagram** (visual representation).
2. **Configuration Snippets**:
   - Load balancer config
   - Database replication config
   - API read/write connection logic
3. **Setup Guide**:
   - Step-by-step instructions to reproduce system.

### B. Video Demonstration (5-10 minutes)
Must include:
1. Brief walkthrough of source code and key config files.
2. Live demo:
   - `POST /products` writes to Master.
   - `GET /products` traffic balanced across 2 API nodes.
3. **Chaos Test**:
   - Stop one API node manually.
   - Show system continues serving through remaining node.

## 6) Evaluation Criteria

### Implementation Levels
- **Advanced Implementation (2.0 points):**
  - Load Balancer + 2 API Nodes + Master-Slave Replication + Read/Write Splitting.
- **Basic Implementation (1.0 point):**
  - Load Balancer + 2 API Nodes + Single DB Node (no replication).

### Scoring Breakdown
- **System Functionality (40%)**: LB works, DB replication active, API functional.
- **Read/Write Splitting (20%)**: Correct query routing to Master vs Slave.
- **Fault Tolerance (10%)**: Survives single API node failure.
- **Documentation Quality (15%)**: Clear, accurate, and reproducible guide.
- **Video Presentation (15%)**: Professional delivery and successful live demo.

## 7) Submission Instructions
- **Deadline:** 6:00 PM, September 5th, 2026.
- **Format:** ZIP file named `[MSSV].zip`.
- ZIP must include:
  - PDF documentation (or repository containing all required files),
  - Video link (YouTube) or GitHub repository link.

## Notes for Implementation Start
- Keep architecture modular so each layer can be tested independently.
- Add `processed_by` field in API response from each node for LB verification.
- Prepare scripts or docker-compose files early to simplify reproducible setup.
