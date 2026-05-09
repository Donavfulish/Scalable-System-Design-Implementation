# System Architecture Diagram

```mermaid
flowchart LR
    C[Client] --> LB[Nginx Load Balancer]

    LB --> A1[API Node 1]
    LB --> A2[API Node 2]

    A1 -->|"POST /products<br>WRITE"| M[(MySQL Master)]
    A2 -->|"POST /products<br>WRITE"| M

    A1 -->|"GET /products<br>READ"| S[(MySQL Slave)]
    A2 -->|"GET /products<br>READ"| S

    M -->|Binary Log Replication| S
```

## Notes
- Nginx is the single entry point and distributes traffic to both API nodes.
- `POST /products` always writes to Master.
- `GET /products` always reads from Slave.
- `processed_by` in API response proves load-balancing behavior.