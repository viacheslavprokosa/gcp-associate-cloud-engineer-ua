# Cloud Build

## Fundamentals

**Cloud Build** - це serverless CI/CD платформа для автоматизації builds, tests та deployments.

### Key Concepts

- **Build**: Execution of build steps
- **Build Step**: Single operation (compile, test, deploy)
- **Build Trigger**: Automatic build on code changes
- **Builder**: Docker image that executes build step

---

## cloudbuild.yaml

**Build configuration file** визначає build steps.

### Basic Structure

```yaml
steps:
- name: 'BUILDER_IMAGE'
  args: ['COMMAND', 'ARG1', 'ARG2']
  env: ['KEY=VALUE']
```

### Example: Docker Build

```yaml
steps:
# Build Docker image
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', 'gcr.io/$PROJECT_ID/my-app:$COMMIT_SHA', '.']

# Push to Container Registry
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'gcr.io/$PROJECT_ID/my-app:$COMMIT_SHA']

images:
- 'gcr.io/$PROJECT_ID/my-app:$COMMIT_SHA'
```

---

## Build Steps

### Pre-built Builders

**Google-provided builders:**

- `gcr.io/cloud-builders/docker`: Docker commands
- `gcr.io/cloud-builders/gcloud`: gcloud commands
- `gcr.io/cloud-builders/kubectl`: Kubernetes deployments
- `gcr.io/cloud-builders/npm`: Node.js builds
- `gcr.io/cloud-builders/mvn`: Maven builds
- `gcr.io/cloud-builders/gradle`: Gradle builds

### Multi-Step Build

```yaml
steps:
# Install dependencies
- name: 'gcr.io/cloud-builders/npm'
  args: ['install']

# Run tests
- name: 'gcr.io/cloud-builders/npm'
  args: ['test']

# Build application
- name: 'gcr.io/cloud-builders/npm'
  args: ['run', 'build']

# Build Docker image
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', 'gcr.io/$PROJECT_ID/app:$SHORT_SHA', '.']

# Push image
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'gcr.io/$PROJECT_ID/app:$SHORT_SHA']

images:
- 'gcr.io/$PROJECT_ID/app:$SHORT_SHA'
```

---

## Build Triggers

**Build Triggers** - автоматичний запуск builds при змінах в коді.

### Create Trigger (GitHub)

```bash
gcloud builds triggers create github \
  --repo-name=my-repo \
  --repo-owner=my-org \
  --branch-pattern="^main$" \
  --build-config=cloudbuild.yaml
```

### Trigger Types

**1. Push to Branch:**

```bash
--branch-pattern="^main$"
```

**2. Pull Request:**

```bash
--pull-request-pattern="^main$"
```

**3. Tag:**

```bash
--tag-pattern="^v.*"
```

---

## Substitutions

**Variables** в build configuration.

### Built-in Substitutions

```yaml
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [
    'build',
    '-t', 'gcr.io/$PROJECT_ID/app:$COMMIT_SHA',
    '-t', 'gcr.io/$PROJECT_ID/app:$SHORT_SHA',
    '-t', 'gcr.io/$PROJECT_ID/app:$BRANCH_NAME',
    '.'
  ]
```

**Available variables:**

- `$PROJECT_ID`: GCP project ID
- `$BUILD_ID`: Unique build ID
- `$COMMIT_SHA`: Full commit SHA
- `$SHORT_SHA`: Short commit SHA (7 chars)
- `$BRANCH_NAME`: Branch name
- `$TAG_NAME`: Tag name
- `$REPO_NAME`: Repository name

### Custom Substitutions

```yaml
substitutions:
  _ENV: 'production'
  _REGION: 'us-central1'

steps:
- name: 'gcr.io/cloud-builders/gcloud'
  args: [
    'run', 'deploy', 'my-service',
    '--image', 'gcr.io/$PROJECT_ID/app:$SHORT_SHA',
    '--region', '${_REGION}',
    '--platform', 'managed'
  ]
```

---

## Practical Scenario: Full CI/CD Pipeline

### Scenario

Node.js application з automated testing та deployment до Cloud Run.

### Solution

**cloudbuild.yaml:**

```yaml
steps:
# Install dependencies
- name: 'node:18'
  entrypoint: 'npm'
  args: ['ci']

# Run linter
- name: 'node:18'
  entrypoint: 'npm'
  args: ['run', 'lint']

# Run tests
- name: 'node:18'
  entrypoint: 'npm'
  args: ['test']
  env:
  - 'NODE_ENV=test'

# Build application
- name: 'node:18'
  entrypoint: 'npm'
  args: ['run', 'build']

# Build Docker image
- name: 'gcr.io/cloud-builders/docker'
  args: [
    'build',
    '-t', 'gcr.io/$PROJECT_ID/app:$SHORT_SHA',
    '-t', 'gcr.io/$PROJECT_ID/app:latest',
    '.'
  ]

# Push to Container Registry
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'gcr.io/$PROJECT_ID/app:$SHORT_SHA']

# Deploy to Cloud Run
- name: 'gcr.io/cloud-builders/gcloud'
  args: [
    'run', 'deploy', 'my-app',
    '--image', 'gcr.io/$PROJECT_ID/app:$SHORT_SHA',
    '--region', 'us-central1',
    '--platform', 'managed',
    '--allow-unauthenticated'
  ]

images:
- 'gcr.io/$PROJECT_ID/app:$SHORT_SHA'
- 'gcr.io/$PROJECT_ID/app:latest'

options:
  machineType: 'N1_HIGHCPU_8'
  logging: CLOUD_LOGGING_ONLY
```

**Create Trigger:**

```bash
gcloud builds triggers create github \
  --repo-name=my-app \
  --repo-owner=my-org \
  --branch-pattern="^main$" \
  --build-config=cloudbuild.yaml
```

---

## Best Practices

### 1. Use Caching

```yaml
steps:
- name: 'node:18'
  entrypoint: 'npm'
  args: ['ci', '--cache', '.npm']
  volumes:
  - name: 'npm-cache'
    path: '.npm'
```

### 2. Parallel Steps

```yaml
steps:
# These run in parallel
- name: 'gcr.io/cloud-builders/npm'
  args: ['run', 'lint']
  id: 'lint'

- name: 'gcr.io/cloud-builders/npm'
  args: ['run', 'test']
  id: 'test'

# This waits for both
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', 'gcr.io/$PROJECT_ID/app', '.']
  waitFor: ['lint', 'test']
```

### 3. Use Secrets

```bash
# Create secret
echo -n "my-secret-value" | gcloud secrets create my-secret --data-file=-

# Use in build
```

```yaml
availableSecrets:
  secretManager:
  - versionName: projects/$PROJECT_ID/secrets/my-secret/versions/latest
    env: 'MY_SECRET'

steps:
- name: 'gcr.io/cloud-builders/gcloud'
  entrypoint: 'bash'
  args: ['-c', 'echo $$MY_SECRET']
  secretEnv: ['MY_SECRET']
```

---

## Cross-References

**[Module 03 - Compute Engine](../03-compute-engine/vm-instances.md)**

- Deploy to Compute Engine

**[Module 04 - GKE](../04-kubernetes-engine/workloads.md)**

- Deploy to GKE

**[Module 05 - App Engine](../05-app-engine/deployment.md)**

- Deploy to App Engine

**[Module 12 - Cloud SDK](cloud-sdk.md)**

- gcloud builds commands

---

> ⚠️ **Важливо для іспиту**: Розуміння cloudbuild.yaml структури, build steps, triggers та substitutions критично важливе для ACE exam.

---

**Повернутися до:** [Модуль 12 - Deployment & Management](README.md)
