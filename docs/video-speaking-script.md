# Video Speaking Script (Normal Language)

Muc tieu file nay: giup ban quay video 5-10 phut, biet ro can noi gi va thao tac gi.

## 0) Chuan bi truoc khi quay (30-60s)
- Mo terminal tai root project.
- Chuan bi san cac file de show:
  - `docker-compose.yml`
  - `infra/nginx/nginx.conf`
  - `api/src/server.js`
  - `docs/architecture.md`
- Chay san Docker Desktop.

Loi mo dau goi y:
"Day la project scalable backend gom load balancer, 2 API nodes, va MySQL master-slave replication voi read/write splitting."

## 1) Gioi thieu kien truc (1-2 phut)
### Ban noi
"He thong co 3 lop chinh:
1. Nginx la diem vao duy nhat.
2. 2 API node giong nhau de scale ngang.
3. Database gom master va slave replica.
POST /products ghi vao master.
GET /products doc tu slave.
Response GET co `processed_by` de chung minh load balancing."

### Ban thao tac
1. Mo `docs/architecture.md`, zoom vao so do.
2. Mo `docker-compose.yml`, chi nhanh cac service:
   - `mysql-master`, `mysql-slave`
   - `replication-setup`
   - `api-node-1`, `api-node-2`
   - `nginx`
3. Mo `api/src/server.js`, chi:
   - ham `POST /products` dung `writePool`
   - ham `GET /products` dung `readPool`

## 2) Khoi dong he thong (1 phut)
### Ban noi
"Bay gio minh se build va start toan bo stack bang Docker Compose."

### Ban thao tac
Chay lenh:
`docker compose up -d --build`

Sau do:
`docker compose ps`

### Ban noi tiep
"Tat ca service da len, replication-setup da chay xong, API nodes va Nginx dang running."

## 3) Demo chuc nang chinh (2-3 phut)
### Cach nhanh nhat (khuyen dung khi quay)
Chay script:
`powershell -ExecutionPolicy Bypass -File .\scripts\video-demo.ps1`

### Neu ban muon demo tay
1. Health check:
   - `Invoke-RestMethod -Method GET -Uri "http://localhost:8080/health"`
2. Tao product:
   - `Invoke-RestMethod -Method POST -Uri "http://localhost:8080/products" -ContentType "application/json" -Body '{"name":"Demo Product","price":199.99}'`
3. Goi GET nhieu lan:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`

### Ban noi trong luc demo
"POST da tao du lieu thanh cong.
GET tra ve danh sach san pham va field `processed_by` luan phien Node_1, Node_2.
Dieu nay chung minh load balancer dang phan phoi request."

## 4) Chaos test / Fault tolerance (1-2 phut)
### Ban noi
"Bay gio minh test fault tolerance: tat 1 API node, he thong van phai phuc vu duoc."

### Ban thao tac
1. Chay:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\chaos-test.ps1`

### Ban noi ket qua
"Khi dung `api-node-1`, request van tra ve thanh cong qua `api-node-2`.
Nhu vay he thong dat yeu cau fault tolerance co ban."

## 5) Ket bai va doi chieu yeu cau (45-60s)
### Ban noi
"Project da implement day du:
- Load balancer + 2 API nodes
- Master-slave replication
- Read/write splitting
- Kich ban failover 1 node
- Bo tai lieu va script demo day du.
Phan con lai de nop bai la dong goi PDF tai lieu va upload video."

## 6) Checklist quay video de tranh sai sot
- [ ] Co show so do kien truc.
- [ ] Co show config Nginx + API read/write split.
- [ ] Co POST thanh cong.
- [ ] Co GET luan phien `processed_by`.
- [ ] Co chaos test tat 1 node.
- [ ] Co ket luan map ve tieu chi cham diem.
