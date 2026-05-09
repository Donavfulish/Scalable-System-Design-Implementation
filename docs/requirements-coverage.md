# Requirements Coverage Report

Cap nhat theo `requirements.md` va hien trang repo.

## 1) Tong quan ty le hoan thanh
- **Technical implementation:** 100%
- **Deliverable A (technical documentation):** 95%
- **Deliverable B (video):** 85% (script + flow da xong, can ban quay va upload)
- **Tong the de bai:** **~95%** (con buoc nop bai thuc te)

## 2) Mapping theo tung nhom yeu cau

## A. System Architecture Requirements

### A1. Load Balancer (Nginx/HAProxy) - Dat
- Trang thai: **Done (100%)**
- Bang chung:
  - `infra/nginx/nginx.conf`
  - `docker-compose.yml` service `nginx`
- Ghi chu:
  - Dang dung `least_conn` algorithm.

### A2. 2 API Nodes - Dat
- Trang thai: **Done (100%)**
- Bang chung:
  - `docker-compose.yml` services `api-node-1`, `api-node-2`
  - `api/src/server.js`

### A3. Master-Slave Replication - Dat
- Trang thai: **Done (100%)**
- Bang chung:
  - `infra/mysql/master/init/01-master-init.sql`
  - `infra/mysql/slave/init/01-slave-bootstrap.sql`
  - `infra/mysql/scripts/setup-replication.sh`
- Kiem chung:
  - Log `replication-setup` da co `Replica_IO_Running: Yes`, `Replica_SQL_Running: Yes`.

## B. Functional API Requirements

### B1. POST /products ghi vao Master - Dat
- Trang thai: **Done (100%)**
- Bang chung:
  - `api/src/server.js` (`writePool.execute(...)`)
- Kiem chung:
  - Script `scripts/verify.ps1` da tao product thanh cong.

### B2. GET /products doc tu Slave + processed_by - Dat
- Trang thai: **Done (100%)**
- Bang chung:
  - `api/src/server.js` (`readPool.execute(...)`, `processed_by`)
- Kiem chung:
  - Output verify cho thay `processed_by` luan phien Node_1 / Node_2.

## C. Technical Implementation Phases

### C1. Phase 1 Replication setup - Dat
- Trang thai: **Done (100%)**
- Bang chung:
  - MySQL master/slave config + replication bootstrap script.

### C2. Phase 2 API + Read/Write split - Dat
- Trang thai: **Done (100%)**
- Bang chung:
  - `api/src/db.js`, `api/src/server.js`
  - env tách write/read DB.

### C3. Phase 3 Infra + LB - Dat
- Trang thai: **Done (100%)**
- Bang chung:
  - `docker-compose.yml`
  - `infra/nginx/nginx.conf`

### C4. Phase 4 Verification + Stress test - Dat
- Trang thai: **Done (100%)**
- Bang chung:
  - `scripts/verify.ps1`, `scripts/verify.sh`
  - `scripts/chaos-test.ps1`
  - ket qua test da pass.

## D. Deliverables

### D1. Deliverable A - Technical Documentation
- Trang thai: **Gan xong (95%)**
- Da co:
  - `docs/architecture.md`
  - `docs/configuration-snippets.md`
  - `docs/setup-guide.md`
  - `docs/technical-documentation.md`
  - `docs/acceptance-checklist.md`
- Con thieu de chot 100%:
  - Export 1 ban PDF (neu ban muon nop PDF thay vi markdown).

### D2. Deliverable B - Video Demonstration
- Trang thai: **San sang quay (85%)**
- Da co:
  - `docs/video-demo-script.md`
  - `scripts/video-demo.ps1` (one-click demo flow)
- Con thieu de chot 100%:
  - Quay video 5-10 phut va upload YouTube (hoac nen tang khac duoc chap nhan).

## E. Evaluation Criteria Mapping

### E1. System Functionality (40%) - Dat
- LB hoat dong, API hoat dong, replication active.

### E2. Read/Write Splitting (20%) - Dat
- POST -> master, GET -> slave da implement ro rang va test pass.

### E3. Fault Tolerance (10%) - Dat
- Chaos test stop 1 node van phuc vu qua node con lai.

### E4. Documentation Quality (15%) - Gan dat toi da
- Da co bo docs day du va theo cau truc.
- De toi da: them hinh/chung cu output + ban PDF.

### E5. Video Presentation (15%) - Chua cham vi chua quay
- Script va flow da san sang.
- Sau khi quay dung flow thi co the lay full diem muc nay.

## 3) Viec can lam tiep de dat 100% thuc te
1. Chay lai:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\video-demo.ps1`
2. Quay man hinh theo `docs/video-speaking-script.md`.
3. Export tai lieu markdown thanh PDF (tuy chon nhung nen co).
4. Dong goi file nop:
   - `[MSSV].zip`
   - kem link video hoac link repo.
