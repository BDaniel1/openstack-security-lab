# Capstone II – Scripts Guide

This folder contains helper scripts to move between lab states in a persistent OpenStack DevStack environment.

The goal is to quickly get to the correct starting point for each report without rebuilding the environment.

---

## General Notes

- Labs are **sequential**. Each lab builds on the previous one.
- Always follow the correct starting point to avoid inconsistencies.
- **Cinder repair must be run for Labs 2–5 when starting the lab.**
- **Before exiting any lab involving volumes:**
  - Detach volumes from VMs  
  - Delete block storage volumes  
  This prevents Cinder/LVM-related errors in later labs.

---

## Lab 1

**Start from baseline**

    ./initial_setup.sh

**Complete Lab 1**

    ./report1_apply.sh

**Reset Lab 1**

    ./report1_reset.sh

---

## Lab 2

**Start from end of Lab 1**

    ./report1_to_report2_baseline.sh

**After Section 1 (required before continuing)**

    ./report2_cinder_repair.sh
    ./report2_create_VMs.sh

**Complete Lab 2**

    ./report2_apply.sh

**Reset Lab 2 (returns to end of Section 1 state)**

    ./report2_reset.sh

---

## Lab 3

Start from **end of Lab 2**

**Apply**

    ./report3_apply.sh

**Reset**

    ./report3_reset.sh

---

## Lab 4

Start from **end of Lab 3**

**Apply**

    ./report4_apply.sh

**Reset**

    ./report4_reset.sh

---

## Lab 5

Start from **end of Lab 4**

- No reset script required  
- Lab focuses on log review and validation

---