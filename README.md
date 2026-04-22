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
| --- | --- | --- |
| [01](Capstone-I/C1-01-devstack-environment-setup.pdf) | DevStack environment setup | Linux setup, OpenStack deployment, Horizon usage, VM provisioning |
| [02](Capstone-I/C1-02-keystone-rbac-implementation.pdf) | Keystone RBAC implementation | Users/projects/roles, least privilege, CLI + dashboard administration |
| [03](Capstone-I/C1-03-keystone-iam-hardening-policy-mfa.pdf) | IAM hardening + MFA | Scoped accounts, Nova policy enforcement, Keystone TOTP MFA |
| [04](Capstone-I/C1-04-tenant-network-segmentation-east-west-mitigation.pdf) | Tenant isolation & east-west mitigation | Neutron networks, segmentation, security groups, lateral movement testing |

→ See: [Capstone-I](/Capstone-I)

---

### Capstone II – Security Engineering (Persistent Environment)

Structured hardening of a persistent OpenStack deployment, approached as phased security engagements rather than isolated labs.

| Report | Topic | Skills Demonstrated |
| --- | --- | --- |
| [01](Capstone-II/C2-01-rbac-hardening-keystone-groups-nova-policy.pdf) | RBAC hardening & identity redesign | Keystone groups/roles, custom job-function roles, Nova/Glance policy enforcement |
| [02](Capstone-II/C2-02-cinder-lvm-remediation-neutron-network-segmentation-security-groups.pdf) | Storage remediation & network segmentation | Cinder LVM troubleshooting, volume lifecycle validation, Neutron networks, tenant isolation, security groups |
| [03](Capstone-II/C2-03-openstack-quotas-governance-enforcement-denial-testing.pdf) | Cloud governance & quota enforcement | Project quotas (compute/storage/network), resource limits, denial validation, multi-tenant governance |
| [04](Capstone-II/C2-04-cinder-luks-encryption-volume-types-data-at-rest-validation.pdf) | Data-at-rest encryption | Cinder volume types, LUKS encryption, encrypted volume provisioning, host-level validation |
| [05](Capstone-II/C2-05-openstack-audit-logging-monitoring-denied-events-validation.pdf) | Monitoring & audit validation | systemd/journald logs, service inspection, audit evidence collection, denied-event analysis |

→ See: [Capstone-II](/Capstone-II)

→ See: [Scripts (automation & validation)](/Capstone-II/scripts)

---

## Tools & Technologies

OpenStack (Keystone, Nova, Neutron, Glance, Cinder), DevStack, Linux, Bash, LVM, OpenStack CLI, RBAC, policy.yaml, security groups, Neutron networking, project quotas, LUKS encryption, systemd/journald logging

---

## About

Built as part of a cybersecurity capstone focused on practical cloud defense.
The emphasis is on implementing and validating real security controls rather than theoretical configuration.
