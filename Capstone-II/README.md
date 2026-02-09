# Capstone II – Security Engineering (Persistent Environment)

Structured hardening of a persistent OpenStack private cloud using production-style security controls.

Unlike Capstone I (local DevStack labs), this phase uses a long-lived NetLab environment and approaches security as a series of phased engineering engagements. Each report introduces new controls, validates enforcement, and incrementally reduces risk across identity, compute, storage, networking, and operations.

---

## Objectives

- Transition from default roles to structured RBAC
- Enforce least-privilege authorization at the service layer
- Harden Nova, Glance, Neutron, and Cinder policies
- Segment tenant networks and restrict east-west traffic
- Protect data at rest and in transit
- Implement logging, monitoring, and audit visibility
- Establish incident response and forensic readiness

---

## Reports

| Report | Focus | Skills Demonstrated | Status |
|--------|-------|---------------------|--------|
| 01 | RBAC hardening & identity redesign | Keystone groups/roles, custom job-function roles, Nova/Glance policy enforcement, separation of duties validation | ✅ Complete |
| 02 | Service-level policy enforcement | Hardened Nova/Glance/Neutron/Cinder policy.yaml, restricted lifecycle operations, validated authorized vs denied API calls | 🚧 In Progress |
| 03 | Network segmentation & security groups | Tenant networks, routers, ACLs, service-tier isolation, reduced east-west attack surface | ⏳ Planned |
| 04 | Data protection | Encryption at rest, TLS for service communication, protected inter-instance traffic | ⏳ Planned |
| 05 | Monitoring & logging | Centralized logs, audit trails, operational visibility, anomaly detection | ⏳ Planned |
| 06 | Forensics & IR readiness | Evidence collection workflows, investigation procedures, response validation | ⏳ Planned |
| Final | Integrated security demonstration | End-to-end hardened OpenStack environment mapped to real-world cloud security practices | ⏳ Planned |

---

## Environment

- Persistent university NetLab OpenStack deployment
- DevStack-based services
- Keystone, Nova, Neutron, Glance, Cinder
- Horizon dashboard + OpenStack CLI
- Linux administration and service configuration

---

## Outcome

Capstone II transforms the environment from a functional cloud into a defensible one.  
Security controls are implemented incrementally and validated through testing of both authorized and unauthorized actions, producing measurable evidence that least-privilege and isolation policies are actively enforced.
