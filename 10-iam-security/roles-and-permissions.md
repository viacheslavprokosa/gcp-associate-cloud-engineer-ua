# Roles and Permissions

## Вступ

**Roles** — це колекції permissions, які визначають, що identity може робити з GCP resources. **Permissions** — це атомарні дозволи для виконання specific operations.

### Що таке Roles та Permissions?

**Permission:**

- Атомарний дозвіл для specific operation
- Format: `service.resource.verb`
- Example: `compute.instances.create`

**Role:**

- Колекція permissions
- Надається identity через IAM policy
- Types: Basic, Predefined, Custom

### Навіщо потрібні Custom Roles?

1. **Least Privilege:** Точний контроль permissions
2. **Compliance:** Відповідність security policies
3. **Flexibility:** Permissions, які не покриваються predefined roles
4. **Separation of Duties:** Розділення responsibilities

### Зв'язок з іншими модулями

- **[Module 10 - IAM Basics](iam-basics.md):** IAM fundamentals та hierarchy
- **[Module 10 - Service Accounts](service-accounts.md):** Service account roles
- **[Module 03 - Compute Engine](../03-compute-engine/README.md):** Compute permissions
- **[Module 07 - Storage](../07-storage/README.md):** Storage permissions
- **[Module 08 - Databases](../08-databases/README.md):** Database permissions

---

## Role Types

### 1. Basic Roles (Primitive Roles)

**Legacy roles з широкими permissions:**

| Role | Permissions | Use Case |
|------|-------------|----------|
| `roles/viewer` | Read-only access to all resources | View resources |
| `roles/editor` | Viewer + create/modify resources | Modify resources |
| `roles/owner` | Editor + manage IAM + billing | Full control |

**Permissions count:**

- Viewer: ~2,000 permissions
- Editor: ~4,000 permissions
- Owner: ~5,000+ permissions

> ⚠️ **Not Recommended:** Занадто широкі permissions. Використовуйте predefined або custom roles.

### 2. Predefined Roles

**Google-managed roles для specific services:**

**Compute Engine:**

```
roles/compute.admin                 - Full control of Compute Engine
roles/compute.instanceAdmin.v1      - Manage instances
roles/compute.networkAdmin          - Manage networks
roles/compute.securityAdmin         - Manage firewalls, SSL certs
roles/compute.viewer                - Read-only access
```

**Cloud Storage:**

```
roles/storage.admin                 - Full control of buckets/objects
roles/storage.objectAdmin           - Full control of objects
roles/storage.objectCreator         - Create objects
roles/storage.objectViewer          - View objects
```

**Cloud SQL:**

```
roles/cloudsql.admin                - Full control
roles/cloudsql.client               - Connect to instances
roles/cloudsql.editor               - Modify instances
roles/cloudsql.viewer               - View instances
```

### 3. Custom Roles

**User-defined roles з specific permissions:**

**Characteristics:**

- Project-level або organization-level
- Minimum permissions needed
- Can be updated
- Launch stages: ALPHA, BETA, GA, DISABLED

---

## Custom Roles

### Creating Custom Roles

**Using gcloud:**

```bash
# Create custom role
gcloud iam roles create vmOperator \
  --project=my-project \
  --title="VM Operator" \
  --description="Can start/stop VMs but not delete" \
  --permissions=compute.instances.start,compute.instances.stop,compute.instances.get,compute.instances.list \
  --stage=GA
```

**Using YAML file:**

```yaml
# vm-operator-role.yaml
title: "VM Operator"
description: "Can start/stop VMs but not delete"
stage: "GA"
includedPermissions:
- compute.instances.start
- compute.instances.stop
- compute.instances.get
- compute.instances.list
- compute.zones.list
- compute.projects.get
```

```bash
# Create from YAML
gcloud iam roles create vmOperator \
  --project=my-project \
  --file=vm-operator-role.yaml
```

### Organization-Level Custom Roles

```bash
# Create at organization level
gcloud iam roles create vmOperator \
  --organization=123456789 \
  --title="VM Operator" \
  --permissions=compute.instances.start,compute.instances.stop
```

**Benefits:**

- Reusable across all projects
- Centralized management
- Consistent permissions

### Updating Custom Roles

```bash
# Add permissions
gcloud iam roles update vmOperator \
  --project=my-project \
  --add-permissions=compute.instances.reset

# Remove permissions
gcloud iam roles update vmOperator \
  --project=my-project \
  --remove-permissions=compute.instances.reset

# Update from file
gcloud iam roles update vmOperator \
  --project=my-project \
  --file=updated-role.yaml
```

### Deleting Custom Roles

```bash
# Soft delete (can be undeleted within 7 days)
gcloud iam roles delete vmOperator --project=my-project

# Undelete
gcloud iam roles undelete vmOperator --project=my-project

# Permanent delete (after 37 days)
# Happens automatically
```

---

## Permissions

### Permission Format

```
<service>.<resource>.<verb>
```

**Examples:**

```
compute.instances.create        - Create VM instances
compute.instances.delete        - Delete VM instances
compute.instances.get           - Get VM instance details
compute.instances.list          - List VM instances
compute.instances.start         - Start VM instances
compute.instances.stop          - Stop VM instances

storage.buckets.create          - Create buckets
storage.buckets.delete          - Delete buckets
storage.objects.get             - Get objects
storage.objects.create          - Create objects
storage.objects.delete          - Delete objects

iam.serviceAccounts.create      - Create service accounts
iam.serviceAccounts.delete      - Delete service accounts
iam.serviceAccounts.get         - Get service account details
iam.serviceAccounts.actAs       - Use service account
```

### Permission Categories

**1. Read Permissions:**

```
*.get       - Get single resource
*.list      - List resources
*.describe  - Describe resource
```

**2. Write Permissions:**

```
*.create    - Create resource
*.update    - Update resource
*.patch     - Patch resource
*.delete    - Delete resource
```

**3. Admin Permissions:**

```
*.setIamPolicy      - Set IAM policy
*.getIamPolicy      - Get IAM policy
*.testIamPermissions - Test permissions
```

### Finding Permissions

**List permissions in predefined role:**

```bash
gcloud iam roles describe roles/compute.instanceAdmin.v1
```

**Output:**

```yaml
name: roles/compute.instanceAdmin.v1
title: Compute Instance Admin (v1)
description: Full control of Compute Engine instances
includedPermissions:
- compute.instances.create
- compute.instances.delete
- compute.instances.get
- compute.instances.list
- compute.instances.start
- compute.instances.stop
- compute.disks.create
- compute.disks.delete
# ... more permissions
```

**Search for permissions:**

```bash
# Find all compute permissions
gcloud iam list-testable-permissions \
  //cloudresourcemanager.googleapis.com/projects/my-project \
  --filter="name:compute"
```

---

## Custom Role Best Practices

### 1. Naming Convention

✅ **DO:**

```
<service>.<action>.<scope>
  example: compute.vmOperator.project
          storage.bucketManager.org
          iam.serviceAccountCreator.project
```

❌ **DON'T:**

```
role1, customRole, myRole
```

### 2. Permission Selection

✅ **DO:**

- Start with minimum permissions
- Add permissions incrementally
- Test thoroughly
- Document purpose

❌ **DON'T:**

- Copy all permissions from predefined role
- Add permissions "just in case"
- Include admin permissions without need

### 3. Maintenance

✅ **DO:**

- Review permissions regularly
- Update when requirements change
- Version control role definitions
- Document changes

❌ **DON'T:**

- Create and forget
- Never review
- Make ad-hoc changes

### 4. Launch Stages

**ALPHA:**

- Testing phase
- May change
- Not for production

**BETA:**

- Stable but may change
- Can use in production with caution

**GA (General Availability):**

- Production-ready
- Stable
- Recommended

**DISABLED:**

- Role disabled
- Cannot be granted

---

## Testing Permissions

### Test IAM Permissions

**Check if identity has specific permissions:**

```bash
# Test permissions for current user
gcloud projects get-iam-policy my-project \
  --flatten="bindings[].members" \
  --filter="bindings.members:user:alice@example.com"
```

**Test specific permissions:**

```bash
# Test if user can create instances
gcloud compute instances test-iam-permissions my-instance \
  --zone=us-central1-a \
  --permissions=compute.instances.start,compute.instances.stop
```

**Output:**

```json
{
  "permissions": [
    "compute.instances.start",
    "compute.instances.stop"
  ]
}
```

### Policy Troubleshooter

```bash
gcloud policy-troubleshoot iam \
  --resource=//cloudresourcemanager.googleapis.com/projects/my-project \
  --principal=user:alice@example.com \
  --permission=compute.instances.create
```

**Output shows:**

- Whether permission is granted
- Which policy grants it
- Inheritance path

---

## Практичний сценарій: DevOps Team Roles

### Вимоги

1. **Junior DevOps:** View resources, restart VMs
2. **Senior DevOps:** Create/delete VMs, manage networks
3. **DevOps Lead:** Full Compute Engine access + IAM management
4. **Security Team:** Read-only access + audit logs

### Custom Roles Design

**1. Junior DevOps Role:**

```yaml
# junior-devops.yaml
title: "Junior DevOps"
description: "View resources and restart VMs"
stage: "GA"
includedPermissions:
# View permissions
- compute.instances.get
- compute.instances.list
- compute.zones.list
- compute.projects.get
# Restart permissions
- compute.instances.start
- compute.instances.stop
- compute.instances.reset
# Monitoring
- monitoring.timeSeries.list
- logging.logEntries.list
```

```bash
gcloud iam roles create juniorDevOps \
  --project=my-project \
  --file=junior-devops.yaml

# Grant to group
gcloud projects add-iam-policy-binding my-project \
  --member=group:junior-devops@example.com \
  --role=projects/my-project/roles/juniorDevOps
```

**2. Senior DevOps Role:**

```yaml
# senior-devops.yaml
title: "Senior DevOps"
description: "Manage VMs and networks"
stage: "GA"
includedPermissions:
# All junior permissions
- compute.instances.*
- compute.disks.*
- compute.networks.*
- compute.firewalls.*
- compute.addresses.*
# Storage
- storage.buckets.get
- storage.buckets.list
- storage.objects.*
# Cloud SQL
- cloudsql.instances.get
- cloudsql.instances.list
- cloudsql.instances.restart
```

```bash
gcloud iam roles create seniorDevOps \
  --project=my-project \
  --file=senior-devops.yaml

gcloud projects add-iam-policy-binding my-project \
  --member=group:senior-devops@example.com \
  --role=projects/my-project/roles/seniorDevOps
```

**3. DevOps Lead Role:**

```yaml
# devops-lead.yaml
title: "DevOps Lead"
description: "Full Compute access + IAM management"
stage: "GA"
includedPermissions:
# Full Compute Engine
- compute.*
# IAM management
- iam.serviceAccounts.create
- iam.serviceAccounts.delete
- iam.serviceAccounts.get
- iam.serviceAccounts.list
- iam.roles.create
- iam.roles.update
- iam.roles.get
- iam.roles.list
# Project IAM
- resourcemanager.projects.getIamPolicy
- resourcemanager.projects.setIamPolicy
```

**4. Security Auditor Role:**

```yaml
# security-auditor.yaml
title: "Security Auditor"
description: "Read-only access + audit logs"
stage: "GA"
includedPermissions:
# Read all resources
- *.get
- *.list
# Audit logs
- logging.logEntries.list
- logging.logs.list
- logging.sinks.get
- logging.sinks.list
# IAM policies
- iam.serviceAccounts.getIamPolicy
- resourcemanager.projects.getIamPolicy
# Security
- compute.firewalls.get
- compute.firewalls.list
- compute.sslCertificates.get
- compute.sslCertificates.list
```

---

## Role Limitations

### Custom Role Limits

| Limit | Value |
|-------|-------|
| Custom roles per project | 300 |
| Custom roles per organization | 300 |
| Permissions per custom role | No hard limit (recommended < 100) |
| Role name length | 64 characters |
| Role title length | 100 characters |

### Unsupported Permissions

**Some permissions cannot be included in custom roles:**

```
# Cannot be in custom roles
iam.serviceAccountKeys.create
iam.serviceAccountKeys.delete
resourcemanager.projects.setIamPolicy (at org level)
```

**Workaround:** Use predefined roles for these permissions.

---

## Role Recommendations

### Compute Engine

**Read-Only:**

```
roles/compute.viewer
```

**Manage Instances:**

```
Custom role:
- compute.instances.*
- compute.disks.get
- compute.disks.list
```

**Network Admin:**

```
roles/compute.networkAdmin
```

### Cloud Storage

**Read Objects:**

```
roles/storage.objectViewer
```

**Write Objects:**

```
roles/storage.objectCreator
```

**Manage Buckets:**

```
roles/storage.admin
```

### Cloud SQL

**Connect to Database:**

```
roles/cloudsql.client
```

**Manage Instances:**

```
roles/cloudsql.admin
```

---

## Exam Tips

> ⚠️ **Важливо для іспиту:**

1. **Role Types:**
   - Basic: viewer, editor, owner (not recommended)
   - Predefined: service-specific, Google-managed
   - Custom: user-defined, project or org level

2. **Permission Format:**
   - `service.resource.verb`
   - Example: `compute.instances.create`

3. **Custom Roles:**
   - Max 300 per project/organization
   - Launch stages: ALPHA, BETA, GA, DISABLED
   - Can be project-level or org-level

4. **Best Practices:**
   - Use predefined roles when possible
   - Custom roles for specific needs
   - Least privilege principle
   - Regular reviews

5. **Testing:**
   - `gcloud iam roles describe` - view permissions
   - `test-iam-permissions` - test access
   - Policy Troubleshooter - debug access issues

6. **Limitations:**
   - Some permissions cannot be in custom roles
   - 300 custom roles per project/org
   - Soft delete (7 days), permanent after 37 days

7. **Common Scenarios:**
   - Junior vs Senior permissions
   - Read-only auditor role
   - Service-specific operator roles

---

**Повернутися до:** [Модуль 10 - IAM & Security](README.md)
