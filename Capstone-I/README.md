# Capstone I – Foundations

Initial deployment and baseline hardening of a private OpenStack environment using DevStack.

This phase focused on building a functional cloud from scratch, then incrementally introducing core security controls, including identity management, least-privilege access, and tenant isolation. All work was performed in local virtualized lab environments.

---

## Objectives

- Deploy a working OpenStack environment
- Establish core services (Keystone, Nova, Neutron, Glance, Cinder)
- Implement role-based access control (RBAC)
- Enforce least-privilege authorization
- Introduce multi-factor authentication (MFA)
- Segment tenant networks and reduce east-west attack paths

---

## Labs

| Lab | Topic | Skills Demonstrated |
| --- | --- | --- |
| [01](C1-01-devstack-environment-setup.pdf) | DevStack environment setup | Linux setup, OpenStack deployment, Horizon usage, VM provisioning |
| [02](C1-02-keystone-rbac-implementation.pdf) | Keystone RBAC implementation | Users/projects/roles, least privilege, CLI + dashboard administration |
| [03](C1-03-keystone-iam-hardening-policy-mfa.pdf) | IAM hardening + MFA | Scoped accounts, Nova policy enforcement, Keystone TOTP MFA |
| [04](C1-04-tenant-network-segmentation-east-west-mitigation.pdf) | Tenant isolation & east-west mitigation | Neutron networks, segmentation, security groups, lateral movement testing |

---

## Environment

- DevStack (single-node)
- Ubuntu Linux
- Local VMs (VirtualBox/VMware)
- Horizon dashboard + OpenStack CLI

---

## Outcome

By the end of Capstone I, the environment progressed from a default, permissive deployment to a segmented, least-privilege cloud with enforced RBAC, MFA, and tenant network isolation. These controls established the security foundation for the more advanced hardening work in Capstone II.
