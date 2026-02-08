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

| Lab | Focus | Skills Demonstrated |
|-----|-------|---------------------|
| 01 | DevStack environment setup | Linux administration, OpenStack deployment, Horizon & CLI usage |
| 02 | Keystone RBAC implementation | Users/projects/roles, least-privilege design, multi-tenant access control |
| 03 | IAM hardening + MFA | Policy enforcement, scoped accounts, TOTP-based authentication |
| 04 | Tenant isolation & east-west mitigation | Neutron networks, segmentation, security groups, lateral movement testing |

---

## Environment

- DevStack (single-node)
- Ubuntu Linux
- Local VMs (VirtualBox/VMware)
- Horizon dashboard + OpenStack CLI

---

## Outcome

By the end of Capstone I, the environment progressed from a default, permissive deployment to a segmented, least-privilege cloud with enforced RBAC, MFA, and tenant network isolation. These controls established the security foundation for the more advanced hardening work in Capstone II.
