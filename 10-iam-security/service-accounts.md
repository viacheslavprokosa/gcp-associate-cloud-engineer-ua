# Service Accounts

## Вступ

**Service Account** — це спеціальний тип Google account для applications та VMs, а не для людей. Service accounts дозволяють applications автентифікуватися та отримувати доступ до GCP resources.

### Що таке Service Account?

Service account — це identity для applications:

- **Not for humans:** Призначені для applications, VMs, services
- **Email format:** `sa-name@project-id.iam.gserviceaccount.com`
- **Authentication:** Через service account keys або metadata server
- **Authorization:** Через IAM roles

### Навіщо потрібні Service Accounts?

1. **Application Authentication:**
   - Applications потребують identity для доступу до GCP APIs
   - Безпечна автентифікація без user credentials

2. **VM Identity:**
   - VM instances можуть використовувати service account
   - Automatic authentication через metadata server

3. **Automation:**
   - CI/CD pipelines
   - Scheduled jobs
   - Scripts та tools

4. **Least Privilege:**
   - Кожна application має свій service account
   - Granular permissions per application

### Зв'язок з іншими модулями

- **[Module 03 - Compute Engine](../03-compute-engine/README.md):** VM instances з service accounts
- **[Module 04 - Kubernetes Engine](../04-kubernetes-engine/README.md):** Workload Identity для pods
- **[Module 06 - Cloud Functions](../06-cloud-functions/README.md):** Functions з service accounts
- **[Module 07 - Storage](../07-storage/README.md):** Access до Cloud Storage
- **[Module 08 - Databases](../08-databases/README.md):** Database access control

---

## Types of Service Accounts

### 1. User-Managed Service Accounts

**Created by users:**

```bash
gcloud iam service-accounts create my-app-sa \
  --display-name="My Application Service Account"
```

**Characteristics:**

- Створюються вручну
- Повний контроль над lifecycle
- Можна видаляти та recreate
- Email: `sa-name@project-id.iam.gserviceaccount.com`

### 2. Default Service Accounts

**Automatically created:**

**Compute Engine default SA:**

```
PROJECT_NUMBER-compute@developer.gserviceaccount.com
```

- Створюється автоматично при першому використанні Compute Engine
- Default role: `roles/editor` (⚠️ занадто широкі permissions!)

**App Engine default SA:**

```
PROJECT_ID@appspot.gserviceaccount.com
```

- Створюється автоматично при створенні App Engine app
- Default role: `roles/editor`

> ⚠️ **Best Practice:** Не використовуйте default service accounts у production! Створюйте custom service accounts з least privilege permissions.

### 3. Google-Managed Service Accounts

**Managed by Google:**

```
PROJECT_NUMBER@cloudservices.gserviceaccount.com
```

- Використовуються Google services
- Не можна видаляти
- Автоматично managed

---

## Service Account Lifecycle

### Creating Service Accounts

**Using gcloud:**

```bash
# Створення service account
gcloud iam service-accounts create my-app-sa \
  --display-name="My Application" \
  --description="Service account for my application"

# Перевірка
gcloud iam service-accounts list
```

**Using Console:**

1. IAM & Admin → Service Accounts
2. Create Service Account
3. Enter name, description
4. Grant roles (optional)
5. Create

### Granting Roles

**Project-level permissions:**

```bash
# Надати service account доступ до project
gcloud projects add-iam-policy-binding my-project \
  --member=serviceAccount:my-app-sa@my-project.iam.gserviceaccount.com \
  --role=roles/storage.objectViewer
```

**Resource-level permissions:**

```bash
# Надати доступ до specific bucket
gsutil iam ch \
  serviceAccount:my-app-sa@my-project.iam.gserviceaccount.com:objectAdmin \
  gs://my-bucket
```

### Deleting Service Accounts

```bash
gcloud iam service-accounts delete \
  my-app-sa@my-project.iam.gserviceaccount.com
```

> ⚠️ **Caution:** Видалення service account може зламати applications, які його використовують!

---

## Service Account Keys

### Types of Keys

**1. Google-Managed Keys:**

- Автоматично rotated
- Використовуються Compute Engine, App Engine, Cloud Functions
- **Recommended:** Завжди використовуйте, коли можливо

**2. User-Managed Keys:**

- Створюються вручну
- Потребують manual rotation
- JSON або P12 format
- **Use only when necessary:** Для applications поза GCP

### Creating Keys

```bash
# Створення JSON key
gcloud iam service-accounts keys create ~/key.json \
  --iam-account=my-app-sa@my-project.iam.gserviceaccount.com

# List keys
gcloud iam service-accounts keys list \
  --iam-account=my-app-sa@my-project.iam.gserviceaccount.com
```

### Using Keys

**Set environment variable:**

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/key.json"
```

**In application (Python):**

```python
from google.cloud import storage

# Automatic authentication using GOOGLE_APPLICATION_CREDENTIALS
client = storage.Client()
buckets = list(client.list_buckets())
```

### Key Rotation

**Best Practice:** Rotate keys regularly (every 90 days)

```bash
# Create new key
gcloud iam service-accounts keys create ~/new-key.json \
  --iam-account=my-app-sa@my-project.iam.gserviceaccount.com

# Update application to use new key

# Delete old key
gcloud iam service-accounts keys delete KEY_ID \
  --iam-account=my-app-sa@my-project.iam.gserviceaccount.com
```

---

## Authentication Methods

### 1. Metadata Server (Recommended)

**For Compute Engine VMs:**

```python
from google.auth import compute_engine
from google.cloud import storage

# Automatic authentication через metadata server
credentials = compute_engine.Credentials()
client = storage.Client(credentials=credentials)
```

**How it works:**

1. VM має attached service account
2. Application запитує credentials у metadata server
3. Metadata server повертає short-lived access token
4. No keys needed!

### 2. Service Account Keys

**For applications поза GCP:**

```python
from google.oauth2 import service_account
from google.cloud import storage

credentials = service_account.Credentials.from_service_account_file(
    '/path/to/key.json'
)
client = storage.Client(credentials=credentials)
```

### 3. Workload Identity (GKE)

**For Kubernetes pods:**

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-app-ksa
  annotations:
    iam.gke.io/gcp-service-account: my-app-sa@project.iam.gserviceaccount.com
```

**Bind KSA to GSA:**

```bash
gcloud iam service-accounts add-iam-policy-binding \
  my-app-sa@project.iam.gserviceaccount.com \
  --role=roles/iam.workloadIdentityUser \
  --member="serviceAccount:project.svc.id.goog[namespace/my-app-ksa]"
```

---

## Service Account Impersonation

### What is Impersonation?

**Impersonation** дозволяє одному identity (user або service account) діяти від імені іншого service account.

### Use Cases

1. **Testing:** Developers тестують з permissions service account
2. **Delegation:** User виконує дії від імені service account
3. **Cross-project access:** Service account в одному project доступає до іншого

### Granting Impersonation

```bash
# Надати user можливість impersonate service account
gcloud iam service-accounts add-iam-policy-binding \
  target-sa@project.iam.gserviceaccount.com \
  --member=user:alice@example.com \
  --role=roles/iam.serviceAccountTokenCreator
```

### Using Impersonation

**With gcloud:**

```bash
gcloud compute instances list \
  --impersonate-service-account=target-sa@project.iam.gserviceaccount.com
```

**In application:**

```python
from google.auth import impersonated_credentials
from google.cloud import storage

# Source credentials (your user account)
source_credentials, project = google.auth.default()

# Target service account
target_scopes = ['https://www.googleapis.com/auth/cloud-platform']
target_credentials = impersonated_credentials.Credentials(
    source_credentials=source_credentials,
    target_principal='target-sa@project.iam.gserviceaccount.com',
    target_scopes=target_scopes
)

client = storage.Client(credentials=target_credentials)
```

---

## Service Accounts on Compute Engine

### Attaching Service Account to VM

**At creation:**

```bash
gcloud compute instances create my-vm \
  --service-account=my-app-sa@project.iam.gserviceaccount.com \
  --scopes=cloud-platform
```

**Update existing VM:**

```bash
# Stop VM
gcloud compute instances stop my-vm

# Update service account
gcloud compute instances set-service-account my-vm \
  --service-account=my-app-sa@project.iam.gserviceaccount.com \
  --scopes=cloud-platform

# Start VM
gcloud compute instances start my-vm
```

### Access Scopes

**Scopes** обмежують, які APIs може використовувати VM.

**Common scopes:**

```bash
--scopes=storage-ro              # Cloud Storage read-only
--scopes=storage-rw              # Cloud Storage read-write
--scopes=compute-ro              # Compute Engine read-only
--scopes=cloud-platform          # All GCP APIs (recommended)
```

> ⚠️ **Best Practice:** Використовуйте `cloud-platform` scope та контролюйте access через IAM roles, не scopes.

### Accessing from VM

**Inside VM:**

```bash
# Get access token
curl -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token

# Get service account email
curl -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email
```

---

## Service Account Permissions

### Service Account as Resource

Service account може бути **resource** (хтось доступає до нього):

**Roles:**

- `roles/iam.serviceAccountUser` - Використовувати service account
- `roles/iam.serviceAccountTokenCreator` - Create tokens (impersonation)
- `roles/iam.serviceAccountKeyAdmin` - Manage keys

**Example:**

```bash
# Дозволити user використовувати service account на VM
gcloud iam service-accounts add-iam-policy-binding \
  my-app-sa@project.iam.gserviceaccount.com \
  --member=user:alice@example.com \
  --role=roles/iam.serviceAccountUser
```

### Service Account as Identity

Service account може бути **identity** (він доступає до resources):

```bash
# Надати service account доступ до Cloud Storage
gcloud projects add-iam-policy-binding my-project \
  --member=serviceAccount:my-app-sa@project.iam.gserviceaccount.com \
  --role=roles/storage.objectViewer
```

---

## Best Practices

### 1. Least Privilege

✅ **DO:**

- Створюйте окремий service account для кожної application
- Надавайте мінімальні необхідні permissions
- Використовуйте predefined roles

❌ **DON'T:**

- Не використовуйте default service accounts
- Не надавайте `roles/editor` або `roles/owner`
- Не share service accounts між applications

### 2. Key Management

✅ **DO:**

- Використовуйте Google-managed keys (metadata server)
- Rotate user-managed keys regularly (90 days)
- Store keys securely (Secret Manager)
- Delete unused keys

❌ **DON'T:**

- Не commit keys до git
- Не share keys
- Не зберігайте keys у plain text
- Не створюйте keys без потреби

### 3. Monitoring

✅ **DO:**

- Моніторьте service account usage
- Enable audit logging
- Review permissions regularly
- Track key creation/deletion

❌ **DON'T:**

- Не ігноруйте unused service accounts
- Не забувайте про orphaned keys

### 4. Naming Convention

✅ **DO:**

```
app-name-environment-sa
  example: web-app-prod-sa
          api-backend-dev-sa
          data-pipeline-staging-sa
```

❌ **DON'T:**

```
sa1, sa2, test, my-sa
```

---

## Практичний сценарій: Multi-Tier Application

### Вимоги

1. Web frontend (Cloud Run)
2. API backend (Compute Engine)
3. Data processing (Cloud Functions)
4. Storage (Cloud Storage)
5. Database (Cloud SQL)

### Service Accounts Design

**1. Frontend Service Account:**

```bash
# Створення
gcloud iam service-accounts create web-frontend-sa \
  --display-name="Web Frontend Service Account"

# Permissions: read from Cloud Storage, call backend API
gcloud projects add-iam-policy-binding my-project \
  --member=serviceAccount:web-frontend-sa@my-project.iam.gserviceaccount.com \
  --role=roles/storage.objectViewer

# Deploy Cloud Run з service account
gcloud run deploy web-frontend \
  --image=gcr.io/my-project/frontend \
  --service-account=web-frontend-sa@my-project.iam.gserviceaccount.com
```

**2. Backend Service Account:**

```bash
# Створення
gcloud iam service-accounts create api-backend-sa \
  --display-name="API Backend Service Account"

# Permissions: read/write Cloud Storage, access Cloud SQL
gcloud projects add-iam-policy-binding my-project \
  --member=serviceAccount:api-backend-sa@my-project.iam.gserviceaccount.com \
  --role=roles/storage.objectAdmin

gcloud projects add-iam-policy-binding my-project \
  --member=serviceAccount:api-backend-sa@my-project.iam.gserviceaccount.com \
  --role=roles/cloudsql.client

# Create VM з service account
gcloud compute instances create api-backend \
  --service-account=api-backend-sa@my-project.iam.gserviceaccount.com \
  --scopes=cloud-platform
```

**3. Data Processing Service Account:**

```bash
# Створення
gcloud iam service-accounts create data-processor-sa \
  --display-name="Data Processor Service Account"

# Permissions: read/write Cloud Storage
gcloud projects add-iam-policy-binding my-project \
  --member=serviceAccount:data-processor-sa@my-project.iam.gserviceaccount.com \
  --role=roles/storage.objectAdmin

# Deploy Cloud Function з service account
gcloud functions deploy process-data \
  --runtime=python39 \
  --trigger-bucket=input-bucket \
  --service-account=data-processor-sa@my-project.iam.gserviceaccount.com
```

**4. Cross-Service Communication:**

```bash
# Frontend може impersonate backend для testing
gcloud iam service-accounts add-iam-policy-binding \
  api-backend-sa@my-project.iam.gserviceaccount.com \
  --member=serviceAccount:web-frontend-sa@my-project.iam.gserviceaccount.com \
  --role=roles/iam.serviceAccountTokenCreator
```

---

## Service Account vs User Account

| Feature | Service Account | User Account |
|---------|----------------|--------------|
| **Purpose** | Applications, VMs | Humans |
| **Email** | <sa@project.iam.gserviceaccount.com> | <user@example.com> |
| **Authentication** | Keys, metadata server | Password, OAuth |
| **Lifecycle** | Managed by project | Managed by domain |
| **Max per project** | 100 (default) | Unlimited |

---

## Troubleshooting

### Common Issues

**1. Permission Denied:**

```bash
# Check service account permissions
gcloud projects get-iam-policy my-project \
  --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:my-sa@project.iam.gserviceaccount.com"
```

**2. Key Not Working:**

```bash
# Verify key is valid
gcloud iam service-accounts keys list \
  --iam-account=my-sa@project.iam.gserviceaccount.com

# Check GOOGLE_APPLICATION_CREDENTIALS
echo $GOOGLE_APPLICATION_CREDENTIALS
```

**3. Metadata Server Not Accessible:**

```bash
# From VM, test metadata server
curl -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email
```

**4. Quota Exceeded:**

```bash
# Check service account quota
gcloud iam service-accounts list --project=my-project | wc -l

# Request quota increase if needed
```

---

## Exam Tips

> ⚠️ **Важливо для іспиту:**

1. **Types:**
   - User-managed: створені вручну
   - Default: автоматично створені (Compute, App Engine)
   - Google-managed: managed by Google

2. **Authentication:**
   - **Preferred:** Metadata server (no keys!)
   - **Alternative:** Service account keys (JSON)
   - **GKE:** Workload Identity

3. **Keys:**
   - Google-managed: automatic rotation
   - User-managed: manual rotation needed
   - **Best practice:** Avoid user-managed keys

4. **Permissions:**
   - Service account **as resource:** хтось використовує його
   - Service account **as identity:** він доступає до resources

5. **Roles:**
   - `roles/iam.serviceAccountUser` - use SA on VM
   - `roles/iam.serviceAccountTokenCreator` - impersonation
   - `roles/iam.serviceAccountKeyAdmin` - manage keys

6. **Best Practices:**
   - One service account per application
   - Least privilege permissions
   - Don't use default service accounts
   - Rotate keys regularly
   - Use metadata server when possible

7. **Scopes:**
   - Обмежують APIs для VM
   - **Best practice:** `cloud-platform` + IAM roles

8. **Impersonation:**
   - User діє від імені service account
   - Requires `roles/iam.serviceAccountTokenCreator`

---

**Повернутися до:** [Модуль 10 - IAM & Security](README.md)
