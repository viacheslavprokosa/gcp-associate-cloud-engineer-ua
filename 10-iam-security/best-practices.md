# Best Practices

## Вступ

**Security Best Practices** — це набір рекомендацій для забезпечення безпеки GCP resources. Дотримання best practices мінімізує security risks та забезпечує compliance.

### Навіщо потрібні Best Practices?

1. **Security:** Захист від unauthorized access
2. **Compliance:** Відповідність regulations (GDPR, HIPAA, PCI DSS)
3. **Risk Mitigation:** Зменшення ймовірності incidents
4. **Operational Excellence:** Стабільна та безпечна infrastructure

### Зв'язок з іншими модулями

- **[Module 10 - IAM Basics](iam-basics.md):** IAM fundamentals
- **[Module 10 - Service Accounts](service-accounts.md):** Service account security
- **[Module 10 - Roles and Permissions](roles-and-permissions.md):** Custom roles
- **[Module 09 - Networking](../09-networking/README.md):** Network security
- **[Module 11 - Monitoring & Logging](../11-monitoring-logging/README.md):** Security monitoring

---

## IAM Best Practices

### 1. Principle of Least Privilege

✅ **DO:**

- Надавайте мінімальні необхідні permissions
- Використовуйте predefined roles замість basic roles
- Створюйте custom roles для specific needs
- Регулярно review та revoke unused permissions

❌ **DON'T:**

- Не надавайте `roles/owner` або `roles/editor` без потреби
- Не використовуйте `allUsers` або `allAuthenticatedUsers`
- Не share credentials між users

**Example:**

```bash
# ❌ BAD: Занадто широкі permissions
gcloud projects add-iam-policy-binding my-project \
  --member=user:alice@example.com \
  --role=roles/editor

# ✅ GOOD: Specific permissions
gcloud projects add-iam-policy-binding my-project \
  --member=user:alice@example.com \
  --role=roles/compute.instanceAdmin.v1
```

### 2. Use Groups for Access Management

✅ **DO:**

- Створюйте Google Groups для teams
- Надавайте permissions groups, не individual users
- Manage group membership централізовано

❌ **DON'T:**

- Не надавайте permissions кожному user окремо
- Не забувайте видаляти users з groups при звільненні

**Example:**

```bash
# ✅ GOOD: Grant to group
gcloud projects add-iam-policy-binding my-project \
  --member=group:developers@example.com \
  --role=roles/compute.instanceAdmin.v1

# Add/remove users from group (in Google Admin Console)
```

### 3. Service Account Security

✅ **DO:**

- Створюйте окремий service account для кожної application
- Використовуйте Google-managed keys (metadata server)
- Rotate user-managed keys regularly (90 days)
- Enable service account key expiration
- Monitor service account usage

❌ **DON'T:**

- Не використовуйте default service accounts
- Не commit service account keys до git
- Не share keys між applications
- Не зберігайте keys у plain text

**Example:**

```bash
# ✅ GOOD: Create dedicated service account
gcloud iam service-accounts create app-backend-sa \
  --display-name="App Backend Service Account"

# Grant minimal permissions
gcloud projects add-iam-policy-binding my-project \
  --member=serviceAccount:app-backend-sa@my-project.iam.gserviceaccount.com \
  --role=roles/cloudsql.client

# Use on VM (no keys needed!)
gcloud compute instances create backend-vm \
  --service-account=app-backend-sa@my-project.iam.gserviceaccount.com \
  --scopes=cloud-platform
```

### 4. Enable Multi-Factor Authentication (MFA)

✅ **DO:**

- Require 2-Step Verification для всіх users
- Use hardware security keys для admin accounts
- Enforce MFA через organization policies

❌ **DON'T:**

- Не дозволяйте accounts без MFA
- Не використовуйте SMS як єдиний MFA method

### 5. Use Organization Policies

✅ **DO:**

- Enforce constraints на organization level
- Restrict public IP addresses
- Require OS Login
- Disable service account key creation

**Example:**

```bash
# Disable service account key creation
gcloud resource-manager org-policies set-policy \
  --organization=123456789 \
  constraint:iam.disableServiceAccountKeyCreation

# Require OS Login
gcloud compute project-info add-metadata \
  --metadata enable-oslogin=TRUE
```

---

## Network Security Best Practices

### 1. Use VPC Firewall Rules

✅ **DO:**

- Default deny all ingress traffic
- Allow only necessary ports
- Use service accounts as targets
- Tag instances for granular control

❌ **DON'T:**

- Не відкривайте 0.0.0.0/0 для всіх ports
- Не використовуйте default firewall rules

**Example:**

```bash
# ✅ GOOD: Specific firewall rule
gcloud compute firewall-rules create allow-web-traffic \
  --network=my-vpc \
  --allow=tcp:80,tcp:443 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=web-server

# ❌ BAD: Too permissive
gcloud compute firewall-rules create allow-all \
  --network=my-vpc \
  --allow=all \
  --source-ranges=0.0.0.0/0
```

### 2. Use Private IP Addresses

✅ **DO:**

- Use private IPs для internal communication
- Use Cloud NAT для outbound internet access
- Use Private Google Access для GCP APIs

❌ **DON'T:**

- Не використовуйте public IPs без потреби
- Не expose databases з public IPs

**Example:**

```bash
# ✅ GOOD: VM without public IP
gcloud compute instances create internal-vm \
  --network=my-vpc \
  --subnet=private-subnet \
  --no-address

# Enable Private Google Access
gcloud compute networks subnets update private-subnet \
  --region=us-central1 \
  --enable-private-ip-google-access
```

### 3. Use Cloud Armor

✅ **DO:**

- Enable DDoS protection
- Configure WAF rules
- Rate limiting
- Geo-blocking

---

## Data Protection Best Practices

### 1. Encryption

✅ **DO:**

- Use encryption at rest (default)
- Use encryption in transit (SSL/TLS)
- Use Customer-Managed Encryption Keys (CMEK) для sensitive data
- Rotate encryption keys regularly

❌ **DON'T:**

- Не disable encryption
- Не зберігайте sensitive data unencrypted

**Example:**

```bash
# Create Cloud KMS key
gcloud kms keyrings create my-keyring \
  --location=us-central1

gcloud kms keys create my-key \
  --location=us-central1 \
  --keyring=my-keyring \
  --purpose=encryption

# Use CMEK for Cloud Storage bucket
gsutil kms encryption \
  -k projects/my-project/locations/us-central1/keyRings/my-keyring/cryptoKeys/my-key \
  gs://my-bucket
```

### 2. Access Control for Data

✅ **DO:**

- Use IAM для bucket-level permissions
- Use ACLs для object-level permissions (якщо потрібно)
- Enable uniform bucket-level access
- Use signed URLs для temporary access

❌ **DON'T:**

- Не робіть buckets public без потреби
- Не використовуйте `allUsers` permissions

**Example:**

```bash
# ✅ GOOD: Uniform bucket-level access
gsutil uniformbucketlevelaccess set on gs://my-bucket

# Grant specific user access
gsutil iam ch user:alice@example.com:objectViewer gs://my-bucket
```

### 3. Data Loss Prevention (DLP)

✅ **DO:**

- Scan data для sensitive information (PII, credit cards)
- Redact або mask sensitive data
- Monitor data access

---

## Monitoring and Logging Best Practices

### 1. Enable Audit Logging

✅ **DO:**

- Enable Admin Activity logs (always on)
- Enable Data Access logs для sensitive resources
- Export logs до Cloud Storage або BigQuery
- Set up log retention policies

❌ **DON'T:**

- Не disable audit logs
- Не ігноруйте security alerts

**Example:**

```bash
# Enable Data Access logs for Cloud Storage
gcloud projects get-iam-policy my-project > policy.yaml

# Edit policy.yaml to add:
# auditConfigs:
# - auditLogConfigs:
#   - logType: DATA_READ
#   - logType: DATA_WRITE
#   service: storage.googleapis.com

gcloud projects set-iam-policy my-project policy.yaml
```

### 2. Set Up Alerts

✅ **DO:**

- Alert на suspicious activities
- Alert на IAM policy changes
- Alert на firewall rule changes
- Alert на failed login attempts

**Example:**

```bash
# Create alert for IAM policy changes
gcloud alpha monitoring policies create \
  --notification-channels=CHANNEL_ID \
  --display-name="IAM Policy Changes" \
  --condition-display-name="IAM changes detected" \
  --condition-threshold-value=1 \
  --condition-threshold-duration=0s
```

### 3. Regular Security Reviews

✅ **DO:**

- Review IAM policies quarterly
- Review service account keys
- Review firewall rules
- Review audit logs
- Conduct security audits

---

## Compliance Best Practices

### 1. Data Residency

✅ **DO:**

- Use specific regions для data storage
- Use organization policies для enforce regions
- Document data locations

**Example:**

```bash
# Restrict resource locations
gcloud resource-manager org-policies set-policy \
  --organization=123456789 \
  constraint:gcp.resourceLocations \
  --allowed-values=us-central1,us-east1
```

### 2. Separation of Duties

✅ **DO:**

- Розділяйте responsibilities між teams
- Use different service accounts для different environments
- Separate dev/staging/prod projects

### 3. Compliance Certifications

✅ **DO:**

- Verify GCP compliance certifications (ISO 27001, SOC 2, HIPAA)
- Use Compliance Reports Manager
- Document compliance requirements

---

## Практичний сценарій: Secure Production Environment

### Вимоги

1. Web application з database
2. GDPR compliance
3. High availability
4. Security monitoring

### Security Implementation

**1. Project Structure:**

```bash
# Separate projects for environments
gcloud projects create prod-app-123 --name="Production App"
gcloud projects create staging-app-123 --name="Staging App"
gcloud projects create dev-app-123 --name="Development App"
```

**2. IAM Setup:**

```bash
# Create groups
# - developers@example.com (dev access)
# - devops@example.com (staging + prod access)
# - security@example.com (read-only audit access)

# Production: DevOps only
gcloud projects add-iam-policy-binding prod-app-123 \
  --member=group:devops@example.com \
  --role=roles/editor

# Security team: Read-only
gcloud projects add-iam-policy-binding prod-app-123 \
  --member=group:security@example.com \
  --role=roles/viewer

# Enable audit logging
gcloud projects get-iam-policy prod-app-123 > policy.yaml
# Add Data Access logs
gcloud projects set-iam-policy prod-app-123 policy.yaml
```

**3. Network Security:**

```bash
# Create VPC
gcloud compute networks create prod-vpc \
  --subnet-mode=custom

# Private subnet for application
gcloud compute networks subnets create app-subnet \
  --network=prod-vpc \
  --region=europe-west1 \
  --range=10.0.1.0/24 \
  --enable-private-ip-google-access

# Private subnet for database
gcloud compute networks subnets create db-subnet \
  --network=prod-vpc \
  --region=europe-west1 \
  --range=10.0.2.0/24 \
  --enable-private-ip-google-access

# Firewall: Allow HTTPS from internet
gcloud compute firewall-rules create allow-https \
  --network=prod-vpc \
  --allow=tcp:443 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=web-server

# Firewall: Allow app to database (internal only)
gcloud compute firewall-rules create allow-app-to-db \
  --network=prod-vpc \
  --allow=tcp:3306 \
  --source-tags=app-server \
  --target-tags=db-server

# Cloud NAT for outbound traffic
gcloud compute routers create prod-router \
  --network=prod-vpc \
  --region=europe-west1

gcloud compute routers nats create prod-nat \
  --router=prod-router \
  --region=europe-west1 \
  --auto-allocate-nat-external-ips \
  --nat-all-subnet-ip-ranges
```

**4. Service Accounts:**

```bash
# Web app service account
gcloud iam service-accounts create web-app-sa \
  --display-name="Web Application"

# Database access
gcloud projects add-iam-policy-binding prod-app-123 \
  --member=serviceAccount:web-app-sa@prod-app-123.iam.gserviceaccount.com \
  --role=roles/cloudsql.client

# Storage access
gcloud projects add-iam-policy-binding prod-app-123 \
  --member=serviceAccount:web-app-sa@prod-app-123.iam.gserviceaccount.com \
  --role=roles/storage.objectViewer
```

**5. Data Protection:**

```bash
# Create KMS keyring (GDPR: data in EU)
gcloud kms keyrings create prod-keyring \
  --location=europe-west1

gcloud kms keys create prod-key \
  --location=europe-west1 \
  --keyring=prod-keyring \
  --purpose=encryption

# Cloud SQL with CMEK
gcloud sql instances create prod-db \
  --database-version=MYSQL_8_0 \
  --region=europe-west1 \
  --network=prod-vpc \
  --no-assign-ip \
  --disk-encryption-key=projects/prod-app-123/locations/europe-west1/keyRings/prod-keyring/cryptoKeys/prod-key

# Cloud Storage with CMEK
gsutil mb -l europe-west1 gs://prod-app-data-123
gsutil kms encryption \
  -k projects/prod-app-123/locations/europe-west1/keyRings/prod-keyring/cryptoKeys/prod-key \
  gs://prod-app-data-123
```

**6. Monitoring:**

```bash
# Export logs to Cloud Storage (long-term retention)
gcloud logging sinks create prod-logs-sink \
  storage.googleapis.com/prod-logs-bucket-123 \
  --log-filter='resource.type="gce_instance" OR resource.type="cloudsql_database"'

# Alert on IAM changes
gcloud alpha monitoring policies create \
  --notification-channels=CHANNEL_ID \
  --display-name="Production IAM Changes" \
  --condition-display-name="IAM policy modified"
```

---

## Security Checklist

### IAM

- [ ] No basic roles (owner/editor/viewer) in production
- [ ] All users in groups
- [ ] Service accounts per application
- [ ] No user-managed service account keys
- [ ] MFA enabled for all users
- [ ] Regular access reviews

### Network

- [ ] Private IPs for internal resources
- [ ] Firewall rules follow least privilege
- [ ] No 0.0.0.0/0 for sensitive ports
- [ ] Cloud NAT for outbound traffic
- [ ] VPC Service Controls for sensitive data

### Data

- [ ] Encryption at rest enabled
- [ ] Encryption in transit (SSL/TLS)
- [ ] CMEK for sensitive data
- [ ] Uniform bucket-level access
- [ ] No public buckets
- [ ] DLP scanning enabled

### Monitoring

- [ ] Audit logs enabled
- [ ] Logs exported for retention
- [ ] Alerts configured
- [ ] Regular log reviews
- [ ] Security dashboard

### Compliance

- [ ] Data in correct regions
- [ ] Compliance certifications verified
- [ ] Separation of duties
- [ ] Regular security audits
- [ ] Incident response plan

---

## Exam Tips

> ⚠️ **Важливо для іспиту:**

1. **Least Privilege:**
   - Мінімальні необхідні permissions
   - Predefined roles > basic roles
   - Custom roles для specific needs

2. **Service Accounts:**
   - One per application
   - Google-managed keys preferred
   - Rotate user-managed keys (90 days)
   - No default service accounts

3. **Network Security:**
   - Private IPs для internal resources
   - Firewall rules: default deny
   - Cloud NAT для outbound traffic
   - VPC Service Controls

4. **Data Protection:**
   - Encryption at rest (default)
   - Encryption in transit (SSL/TLS)
   - CMEK для sensitive data
   - No public buckets

5. **Monitoring:**
   - Enable audit logs
   - Export logs для retention
   - Set up alerts
   - Regular reviews

6. **Compliance:**
   - Data residency requirements
   - Organization policies
   - Separation of duties
   - Regular audits

7. **Common Mistakes:**
   - Using basic roles (owner/editor)
   - Public IPs everywhere
   - No MFA
   - Committing keys to git
   - Ignoring audit logs

---

**Повернутися до:** [Модуль 10 - IAM & Security](README.md)
