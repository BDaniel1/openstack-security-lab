# Capstone II – Security Engineering (Persistent Environment)

Structured hardening of a persistent OpenStack private cloud using production-style security controls.

Unlike Capstone I (local DevStack labs), this phase uses a long-lived NetLab environment and approaches security as a series of phased engineering engagements. Each report introduces new controls, validates enforcement, and incrementally reduces risk across identity, compute, storage, networking, and operations.

---

## Objectives
- Implement structured RBAC using Keystone groups and custom roles
- Enforce least-privilege authorization through service-level policy.yaml controls
- Diagnose and remediate Cinder LVM backend failures to restore persistent storage
- Design and enforce tenant network segmentation using Neutron
- Eliminate cross-project lateral movement through network isolation and security groups
- Apply project-level governance controls using OpenStack quotas
- Protect data at rest using Cinder LUKS volume encryption
- Establish audit visibility through systemd/journald log analysis
- Validate security controls through denied-event and failure testing
- Establish foundations for incident response and forensic investigation

---

## Reports

| Report | Topic | Skills Demonstrated | Status |
|--------|-------|---------------------|--------|
| 01 | RBAC hardening & identity redesign | Keystone groups/roles, custom job-function roles, Nova/Glance policy enforcement | ✅ Complete |
| 02 | Storage remediation & network segmentation | Cinder LVM troubleshooting, volume lifecycle validation, Neutron networks, tenant isolation, security groups | ✅ Complete |
| 03 | Cloud governance & quota enforcement | Project quotas (compute/storage/network), resource limits, denial validation, multi-tenant governance | ✅ Complete |
| 04 | Data-at-rest encryption | Cinder volume types, LUKS encryption, encrypted volume provisioning, host-level validation | ✅ Complete |
| 05 | Monitoring & audit validation | systemd/journald logs, service inspection, audit evidence collection, denied-event analysis | ✅ Complete |
| 06 | Forensics & IR readiness | Evidence collection workflows, incident investigation procedures | ⏳ Planned |
| Final | Integrated security demonstration | End-to-end hardened OpenStack environment validated against real-world cloud security practices | ⏳ Planned |

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
