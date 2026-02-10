# Cloud SDK

## Fundamentals

**Cloud SDK** - набір command-line tools для управління GCP ресурсами.

### Components

- **gcloud**: Основний CLI tool
- **gsutil**: Cloud Storage management
- **bq**: BigQuery management
- **kubectl**: Kubernetes management (optional)

---

## gcloud Command Structure

```bash
gcloud [GROUP] [GROUP] [COMMAND] [POSITIONAL_ARGS] [FLAGS]
```

**Examples:**

```bash
gcloud compute instances create my-vm
#      │       │         │       │
#      │       │         │       └─ Positional argument
#      │       │         └───────── Command
#      │       └─────────────────── Resource group
#      └─────────────────────────── Service group
```

---

## Installation

### Linux/Mac

```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
```

### Docker

```bash
docker run -it google/cloud-sdk:latest gcloud version
```

---

## Authentication

### User Account

```bash
# Login
gcloud auth login

# List accounts
gcloud auth list

# Set active account
gcloud config set account USER@EXAMPLE.COM

# Revoke credentials
gcloud auth revoke USER@EXAMPLE.COM
```

### Service Account

```bash
# Activate service account
gcloud auth activate-service-account \
  --key-file=KEY_FILE.json

# Application Default Credentials
gcloud auth application-default login
```

---

## Configuration

### Configurations

```bash
# List configurations
gcloud config configurations list

# Create configuration
gcloud config configurations create production

# Activate configuration
gcloud config configurations activate production

# Delete configuration
gcloud config configurations delete production
```

### Properties

```bash
# Set project
gcloud config set project PROJECT_ID

# Set region
gcloud config set compute/region us-central1

# Set zone
gcloud config set compute/zone us-central1-a

# View all properties
gcloud config list

# Unset property
gcloud config unset compute/zone
```

---

## Common Commands

### Compute Engine

```bash
# List instances
gcloud compute instances list

# Create instance
gcloud compute instances create my-vm \
  --zone=us-central1-a \
  --machine-type=e2-medium

# SSH to instance
gcloud compute ssh my-vm --zone=us-central1-a

# Delete instance
gcloud compute instances delete my-vm --zone=us-central1-a
```

### Cloud Storage

```bash
# List buckets
gsutil ls

# Create bucket
gsutil mb gs://my-bucket

# Copy file
gsutil cp file.txt gs://my-bucket/

# Sync directory
gsutil rsync -r local-dir gs://my-bucket/remote-dir

# Delete bucket
gsutil rm -r gs://my-bucket
```

### IAM

```bash
# List IAM policy
gcloud projects get-iam-policy PROJECT_ID

# Add IAM binding
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=user:USER@EXAMPLE.COM \
  --role=roles/viewer

# Remove IAM binding
gcloud projects remove-iam-policy-binding PROJECT_ID \
  --member=user:USER@EXAMPLE.COM \
  --role=roles/viewer
```

---

## Filtering and Formatting

### Filtering

```bash
# Filter by name
gcloud compute instances list --filter="name:my-vm"

# Filter by zone
gcloud compute instances list --filter="zone:us-central1-a"

# Multiple filters
gcloud compute instances list \
  --filter="zone:us-central1-a AND status:RUNNING"
```

### Formatting

```bash
# Table format (default)
gcloud compute instances list --format=table

# JSON format
gcloud compute instances list --format=json

# YAML format
gcloud compute instances list --format=yaml

# Custom format
gcloud compute instances list \
  --format="table(name,zone,machineType,status)"

# Get specific value
gcloud compute instances describe my-vm \
  --zone=us-central1-a \
  --format="value(networkInterfaces[0].accessConfigs[0].natIP)"
```

---

## Best Practices

### 1. Use Configurations

```bash
# Development configuration
gcloud config configurations create dev
gcloud config set project dev-project
gcloud config set compute/region us-central1

# Production configuration
gcloud config configurations create prod
gcloud config set project prod-project
gcloud config set compute/region us-east1
```

### 2. Use Service Accounts for Automation

```bash
# Create service account
gcloud iam service-accounts create automation-sa

# Grant roles
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=serviceAccount:automation-sa@PROJECT_ID.iam.gserviceaccount.com \
  --role=roles/compute.admin

# Create key
gcloud iam service-accounts keys create key.json \
  --iam-account=automation-sa@PROJECT_ID.iam.gserviceaccount.com

# Use in scripts
gcloud auth activate-service-account --key-file=key.json
```

### 3. Use Filters and Formatting

```bash
# Get only running instances
gcloud compute instances list \
  --filter="status:RUNNING" \
  --format="table(name,zone)"
```

### 4. Enable Command Completion

```bash
# Bash
echo "source /path/to/google-cloud-sdk/completion.bash.inc" >> ~/.bashrc

# Zsh
echo "source /path/to/google-cloud-sdk/completion.zsh.inc" >> ~/.zshrc
```

---

## Cross-References

**[Module 03 - Compute Engine](../03-compute-engine/vm-instances.md)**

- gcloud compute commands

**[Module 07 - Cloud Storage](../07-storage/cloud-storage.md)**

- gsutil commands

**[Module 10 - IAM](../10-iam-security/iam-basics.md)**

- gcloud iam commands

**[Module 12 - Cloud Build](cloud-build.md)**

- gcloud builds commands

---

> ⚠️ **Важливо для іспиту**: Знання основних gcloud команд критично важливе. Розумійте структуру команд, filtering, formatting та конфігурації.

---

**Повернутися до:** [Модуль 12 - Deployment & Management](README.md)
