---

## Scripts

A set of helper scripts is included to support consistent lab execution within the persistent NetLab environment.

These scripts are designed to:
- Recreate baseline states between reports without rebuilding the environment
- Apply and reset configurations for each report in a controlled manner
- Automate repetitive OpenStack CLI operations for reliability and speed
- Address environment-specific issues (e.g., Cinder LVM loop device instability)

The workflow follows a structured progression:
- **Initial setup** establishes the baseline environment
- Each report includes **apply** and **reset** scripts to move between states
- A **transition script** converts the Report 1 RBAC model to the simplified baseline used in later labs
- A dedicated **Cinder repair script** is required in Labs 2–5 to restore block storage functionality

> Note: Block storage volumes should always be detached and deleted before exiting a lab to prevent Cinder-related errors in subsequent sessions.

→ See: [Scripts](./scripts)