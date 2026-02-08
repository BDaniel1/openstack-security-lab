# OpenStack Security Labs

Hands-on cloud security engineering work focused on deploying, hardening, and defending a private OpenStack environment.

This repository documents a two-phase capstone project that progresses from foundational cloud setup to production-style security controls including identity management, policy enforcement, segmentation, encryption, monitoring, and incident readiness.

---

## Skills Demonstrated

- OpenStack deployment and administration (DevStack)
- Identity & Access Management (Keystone RBAC, groups, least privilege)
- Service authorization (Nova / Glance / Neutron / Cinder policy enforcement)
- Tenant network segmentation and east-west traffic reduction
- Data protection (encryption at rest and in transit)
- Logging, monitoring, and auditability
- Incident response and forensic readiness
- Linux troubleshooting and CLI automation
- Security validation and testing

---

## Repository Structure

### Capstone I – Foundations
Initial environment setup and baseline hardening using local DevStack deployments.

| Lab | Topic | Skills Demonstrated |
|-----|-------|---------------------|
| 01 | DevStack environment setup | Linux setup, OpenStack deployment, Horizon usage, VM provisioning |
| 02 | Keystone RBAC implementation | Users/projects/roles, least privilege, CLI + dashboard administration |
| 03 | IAM hardening + MFA | Scoped accounts, Nova policy enforcement, Keystone TOTP MFA |
| 04 | Tenant isolation & east-west mitigation | Neutron networks, segmentation, security groups, lateral movement testing |

→ See: `/Capstone-I`

---

### Capstone II – Security Engineering (Persistent Environment)
Structured hardening of a persistent OpenStack deployment, approached as phased security engagements rather than isolated labs.

| Report | Topic | Skills Demonstrated | Status |
|-----|-------|---------------------|
| 01 | RBAC hardening & identity redesign | Keystone groups/roles, custom job-function roles, Nova/Glance policy enforcement | ✅ Complete |
| 02 | Service-level policy enforcement | Hardened Nova/Glance/Neutron/Cinder policy.yaml, restricted lifecycle operations | 🚧 In Progress |
| 03 | Network segmentation & security groups | Tenant networks, routers, ACLs, service-tier isolation, reduced east-west traffic | ⏳ Planned |
| 04 | Data protection | Encryption at rest, TLS for service traffic, protected inter-instance communication | ⏳ Planned |
| 05 | Monitoring & logging | Centralized logs, audit trails, operational visibility | ⏳ Planned |
| 06 | Forensics & IR readiness | Evidence collection workflows, incident investigation procedures | ⏳ Planned |
| Final | Integrated security demonstration | End-to-end hardened OpenStack environment validated against real-world cloud security practices | ⏳ Planned |

→ See: `/Capstone-II`

---

## Tools & Technologies

OpenStack (Keystone, Nova, Neutron, Glance, Cinder), Linux, DevStack, Bash, RBAC, policy.yaml, security groups, TLS, logging and monitoring tools

---

## About

Built as part of a cybersecurity capstone focused on practical cloud defense.
The emphasis is on implementing and validating real security controls rather than theoretical configuration.
