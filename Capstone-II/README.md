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

| Report | Topic | Skills Demonstrated |
| --- | --- | --- |
| [01](C2-01-rbac-hardening-keystone-groups-nova-policy.pdf) | RBAC hardening & identity redesign | Keystone groups/roles, custom job-function roles, Nova/Glance policy enforcement |
| [02](C2-02-cinder-lvm-remediation-neutron-network-segmentation-security-groups.pdf) | Storage remediation & network segmentation | Cinder LVM troubleshooting, volume lifecycle validation, Neutron networks, tenant isolation, security groups |
| [03](C2-03-openstack-quotas-governance-enforcement-denial-testing.pdf) | Cloud governance & quota enforcement | Project quotas (compute/storage/network), resource limits, denial validation, multi-tenant governance |
| [04](C2-04-cinder-luks-encryption-volume-types-data-at-rest-validation.pdf) | Data-at-rest encryption | Cinder volume types, LUKS encryption, encrypted volume provisioning, host-level validation |
| [05](C2-05-openstack-audit-logging-monitoring-denied-events-validation.pdf) | Monitoring & audit validation | systemd/journald logs, service inspection, audit evidence collection, denied-event analysis |

---

## Scripts

Helper scripts are included to support consistent execution within the persistent NetLab environment.

These scripts are used to:
- Recreate baseline states between reports without rebuilding the environment
- Apply and reset configurations for each lab in a controlled manner
- Automate repetitive OpenStack CLI operations
- Address environment-specific issues (e.g., Cinder LVM loop device instability)

Workflow overview:
- **Initial setup** establishes the baseline environment
- Each report includes **apply** and **reset** scripts
- A **transition script** prepares the environment for Labs 2–5
- A **Cinder repair script** is required in Labs 2–5 to restore block storage functionality

> Note: Block storage volumes must be detached and deleted before exiting a lab to prevent Cinder-related errors in subsequent sessions.

→ See: [Scripts](./scripts)

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
