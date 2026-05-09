# Acceptance Checklist (Mapped to requirements.md)

## Architecture and Functionality
- [ ] AC-01: Load balancer is the only entry point.
- [ ] AC-02: Two API nodes are deployed and reachable.
- [ ] AC-03: Master-Slave replication is active.
- [ ] AC-04: `POST /products` writes to Master.
- [ ] AC-05: `GET /products` reads from Slave.
- [ ] AC-06: `processed_by` alternates between Node_1 and Node_2.
- [ ] AC-07: One-node failure still serves requests.

## Deliverables
- [ ] AC-08: Architecture diagram is included.
- [ ] AC-09: Config snippets are documented.
- [ ] AC-10: Setup guide is reproducible.
- [ ] AC-11: Video demonstrates all required scenarios.
- [ ] AC-12: Submission package follows required format.

## Evaluation Criteria Coverage
- [ ] AC-13: System functionality verified in repeated test runs.
- [ ] AC-14: Read/write split verified with evidence.
- [ ] AC-15: Fault tolerance verified via chaos test.
- [ ] AC-16: Documentation is clear and technically accurate.
- [ ] AC-17: Video is clear and successful end-to-end.
