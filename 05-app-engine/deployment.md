# Deployment

## Вступ

**App Engine Deployment** — це process deploying applications to App Engine. Розуміння deployment strategies, versioning, та traffic management критично важливе для production deployments.

### Що таке Deployment?

**Deployment** — це uploading application code to App Engine:

- Version management
- Traffic splitting
- Gradual rollouts
- Rollback capability
- Zero-downtime deployments

### Ключові концепції

1. **Service:** Independent microservice (default service required)
2. **Version:** Specific deployment of a service
3. **Instance:** Running copy of a version

### Зв'язок з іншими модулями

- **[Module 05 - Standard vs Flexible](standard-vs-flexible.md):** Environment selection
- **[Module 04 - Kubernetes Engine](../04-kubernetes-engine/README.md):** Alternative deployment platform
- **[Module 12 - Deployment Management](../12-deployment-management/README.md):** CI/CD pipelines

---

## app.yaml Configuration

### Basic Structure

**Minimal app.yaml:**

```yaml
runtime: python39
```

### Standard Environment Configuration

**Complete example:**

```yaml
runtime: python39
entrypoint: gunicorn -b :$PORT main:app

# Instance class
instance_class: F2

# Automatic scaling
automatic_scaling:
  min_instances: 1
  max_instances: 10
  target_cpu_utilization: 0.65
  target_throughput_utilization: 0.75
  max_concurrent_requests: 80

# Environment variables
env_variables:
  DATABASE_URL: "postgresql://..."
  API_KEY: "secret123"

# Handlers (optional)
handlers:
- url: /static
  static_dir: static
- url: /.*
  script: auto
```

### Flexible Environment Configuration

**Complete example:**

```yaml
runtime: python
env: flex
entrypoint: gunicorn -b :$PORT main:app

# Resources
resources:
  cpu: 2
  memory_gb: 4
  disk_size_gb: 10

# Automatic scaling
automatic_scaling:
  min_num_instances: 2
  max_num_instances: 20
  cpu_utilization:
    target_utilization: 0.6
  target_concurrent_requests: 100

# Environment variables
env_variables:
  DATABASE_URL: "postgresql://..."

# Network
network:
  session_affinity: true
  forwarded_ports:
  - 8080

# Health checks
liveness_check:
  path: "/health"
  check_interval_sec: 30
  timeout_sec: 4
  failure_threshold: 2

readiness_check:
  path: "/ready"
  check_interval_sec: 5
  timeout_sec: 4
  failure_threshold: 2
  app_start_timeout_sec: 300
```

### Instance Classes

**Standard Environment:**

| Class | Memory | CPU | Price/hour |
|-------|--------|-----|------------|
| F1 | 128 MB | 600 MHz | $0.05 |
| F2 | 256 MB | 1.2 GHz | $0.10 |
| F4 | 512 MB | 2.4 GHz | $0.20 |
| F4_1G | 1024 MB | 2.4 GHz | $0.30 |

**Flexible Environment:**

- Custom CPU and memory allocation
- Pricing based on vCPU and memory

### Scaling Types

#### 1. Automatic Scaling

**Standard Environment:**

```yaml
automatic_scaling:
  min_instances: 1
  max_instances: 10
  target_cpu_utilization: 0.65
  target_throughput_utilization: 0.75
  max_concurrent_requests: 80
  min_pending_latency: 30ms
  max_pending_latency: 100ms
```

**Flexible Environment:**

```yaml
automatic_scaling:
  min_num_instances: 2
  max_num_instances: 20
  cool_down_period_sec: 120
  cpu_utilization:
    target_utilization: 0.6
  target_concurrent_requests: 100
```

#### 2. Basic Scaling

**Fixed number of instances based on requests:**

```yaml
basic_scaling:
  max_instances: 5
  idle_timeout: 10m
```

**Characteristics:**

- Instances created on demand
- Shut down after idle timeout
- Good for batch processing

#### 3. Manual Scaling

**Fixed number of instances:**

```yaml
manual_scaling:
  instances: 3
```

**Characteristics:**

- Always running
- No auto-scaling
- Predictable costs

---

## Deployment Commands

### Basic Deployment

```bash
# Deploy to default service
gcloud app deploy

# Deploy with specific version
gcloud app deploy --version=v2

# Deploy without promoting (no traffic)
gcloud app deploy --version=v2 --no-promote

# Deploy to specific project
gcloud app deploy --project=my-project
```

### Service Deployment

```bash
# Deploy specific service
gcloud app deploy service.yaml

# Deploy multiple services
gcloud app deploy app.yaml worker.yaml

# Deploy to specific region
gcloud app deploy --region=us-central
```

### Deployment Options

```bash
# Stop previous version after deployment
gcloud app deploy --stop-previous-version

# Promote version to receive traffic
gcloud app deploy --promote

# Quiet mode (no prompts)
gcloud app deploy --quiet

# Image URL (Flexible only)
gcloud app deploy --image-url=gcr.io/my-project/my-image:v1
```

---

## Version Management

### Listing Versions

```bash
# List all versions
gcloud app versions list

# List versions for specific service
gcloud app versions list --service=default

# Detailed version info
gcloud app versions describe v1 --service=default
```

### Version Operations

```bash
# Start version
gcloud app versions start v1 --service=default

# Stop version
gcloud app versions stop v1 --service=default

# Delete version
gcloud app versions delete v1 --service=default

# Migrate traffic to version
gcloud app versions migrate v2 --service=default
```

### Version Naming

**Automatic naming:**

```bash
# Auto-generated version ID
gcloud app deploy
# Creates: 20240210t123456
```

**Manual naming:**

```bash
# Custom version ID
gcloud app deploy --version=v2-0-1

# Semantic versioning
gcloud app deploy --version=release-2-0
```

---

## Traffic Splitting

### Traffic Management

**Split traffic between versions:**

```bash
# 90% to v1, 10% to v2
gcloud app services set-traffic default \
  --splits=v1=0.9,v2=0.1

# Gradual migration
gcloud app services set-traffic default \
  --splits=v1=0.8,v2=0.2 \
  --migrate

# IP-based splitting (sticky sessions)
gcloud app services set-traffic default \
  --splits=v1=0.5,v2=0.5 \
  --split-by=ip

# Cookie-based splitting
gcloud app services set-traffic default \
  --splits=v1=0.5,v2=0.5 \
  --split-by=cookie
```

### Traffic Splitting Strategies

#### 1. Random (Default)

```bash
gcloud app services set-traffic default \
  --splits=v1=0.9,v2=0.1 \
  --split-by=random
```

**Characteristics:**

- Random distribution
- No session affinity
- Best for stateless apps

#### 2. IP-based

```bash
gcloud app services set-traffic default \
  --splits=v1=0.9,v2=0.1 \
  --split-by=ip
```

**Characteristics:**

- Same IP → same version
- Session affinity
- Good for stateful apps

#### 3. Cookie-based

```bash
gcloud app services set-traffic default \
  --splits=v1=0.9,v2=0.1 \
  --split-by=cookie
```

**Characteristics:**

- Cookie-based routing
- Strongest session affinity
- Best for user sessions

---

## Deployment Strategies

### Blue-Green Deployment

**Deploy new version without traffic:**

```bash
# Deploy v2 (green) without traffic
gcloud app deploy --version=v2 --no-promote

# Test v2
curl https://v2-dot-my-service-dot-my-project.appspot.com

# Switch all traffic to v2
gcloud app services set-traffic default --splits=v2=1.0

# Rollback if needed
gcloud app services set-traffic default --splits=v1=1.0
```

### Canary Deployment

**Gradual rollout:**

```bash
# Step 1: Deploy v2 with 10% traffic
gcloud app deploy --version=v2
gcloud app services set-traffic default --splits=v1=0.9,v2=0.1

# Step 2: Increase to 25%
gcloud app services set-traffic default --splits=v1=0.75,v2=0.25

# Step 3: Increase to 50%
gcloud app services set-traffic default --splits=v1=0.5,v2=0.5

# Step 4: Full rollout
gcloud app services set-traffic default --splits=v2=1.0

# Cleanup old version
gcloud app versions delete v1
```

### Rolling Deployment

**Gradual instance replacement:**

```bash
# Deploy with gradual migration
gcloud app deploy --version=v2
gcloud app services set-traffic default \
  --splits=v2=1.0 \
  --migrate
```

**Process:**

1. New instances created
2. Traffic gradually shifted
3. Old instances shut down

---

## Практичний сценарій: Production Deployment

### Scenario: Web Application Update

**Requirements:**

- Zero downtime
- Gradual rollout
- Rollback capability
- Monitor performance

### Implementation

**Step 1: Deploy new version without traffic**

```bash
# Deploy v2.1.0
gcloud app deploy \
  --version=v2-1-0 \
  --no-promote \
  --quiet
```

**Step 2: Test new version**

```bash
# Access version-specific URL
curl https://v2-1-0-dot-default-dot-my-project.appspot.com/health

# Run smoke tests
./run-smoke-tests.sh v2-1-0
```

**Step 3: Canary deployment (10%)**

```bash
# Route 10% traffic to new version
gcloud app services set-traffic default \
  --splits=v2-0-0=0.9,v2-1-0=0.1 \
  --split-by=cookie
```

**Step 4: Monitor metrics**

```bash
# View logs
gcloud app logs tail --service=default --version=v2-1-0

# Check error rate
gcloud logging read "resource.type=gae_app AND resource.labels.version_id=v2-1-0 AND severity>=ERROR" --limit=50
```

**Step 5: Gradual rollout**

```bash
# 25% traffic
gcloud app services set-traffic default \
  --splits=v2-0-0=0.75,v2-1-0=0.25

# Wait and monitor...

# 50% traffic
gcloud app services set-traffic default \
  --splits=v2-0-0=0.5,v2-1-0=0.5

# Wait and monitor...

# 100% traffic
gcloud app services set-traffic default \
  --splits=v2-1-0=1.0
```

**Step 6: Cleanup**

```bash
# Stop old version
gcloud app versions stop v2-0-0 --service=default

# Delete old version (after verification)
gcloud app versions delete v2-0-0 --service=default
```

### Rollback Procedure

**If issues detected:**

```bash
# Immediate rollback to previous version
gcloud app services set-traffic default \
  --splits=v2-0-0=1.0

# Stop problematic version
gcloud app versions stop v2-1-0 --service=default
```

---

## Environment Variables and Secrets

### Environment Variables

**In app.yaml:**

```yaml
env_variables:
  DATABASE_HOST: "10.0.0.1"
  CACHE_TTL: "3600"
  DEBUG: "false"
```

### Secret Manager Integration

**Using Secret Manager:**

```yaml
# app.yaml
runtime: python39

# Reference secrets
env_variables:
  DATABASE_PASSWORD: ${DATABASE_PASSWORD}
```

**Deploy with secrets:**

```bash
# Set secret
echo -n "my-secret-password" | \
  gcloud secrets create DATABASE_PASSWORD --data-file=-

# Grant access
gcloud secrets add-iam-policy-binding DATABASE_PASSWORD \
  --member=serviceAccount:my-project@appspot.gserviceaccount.com \
  --role=roles/secretmanager.secretAccessor

# Deploy
gcloud app deploy
```

---

## Best Practices

### Deployment

✅ **DO:**

- Use version naming conventions (semantic versioning)
- Deploy with `--no-promote` for testing
- Use canary deployments for production
- Monitor metrics during rollout
- Keep previous version running during deployment
- Use traffic splitting for gradual rollouts

❌ **DON'T:**

- Don't deploy directly to production
- Don't delete old versions immediately
- Don't skip testing on version-specific URL
- Don't ignore error rates during rollout

### app.yaml Configuration

✅ **DO:**

- Set appropriate instance class
- Configure health checks (Flexible)
- Use environment variables for configuration
- Set realistic scaling limits
- Use Secret Manager for sensitive data

❌ **DON'T:**

- Don't hardcode secrets in app.yaml
- Don't set max_instances too high (cost)
- Don't skip health checks
- Don't use default scaling blindly

### Traffic Management

✅ **DO:**

- Use cookie-based splitting for user sessions
- Monitor traffic distribution
- Test with small percentage first
- Keep rollback plan ready
- Document traffic splitting decisions

❌ **DON'T:**

- Don't split traffic without monitoring
- Don't use random splitting for stateful apps
- Don't forget to clean up old versions

---

## Exam Tips

> ⚠️ **Важливо для іспиту:**

1. **Deployment Commands:**
   - `gcloud app deploy` - Deploy application
   - `--version=v2` - Specify version
   - `--no-promote` - Deploy without traffic
   - `--stop-previous-version` - Stop old version

2. **Traffic Splitting:**
   - `gcloud app services set-traffic`
   - `--splits=v1=0.9,v2=0.1` - Percentage split
   - `--split-by=ip` - IP-based routing
   - `--split-by=cookie` - Cookie-based routing
   - `--migrate` - Gradual migration

3. **Version Management:**
   - Multiple versions can run simultaneously
   - Traffic can be split between versions
   - Old versions can be stopped/deleted
   - Version-specific URLs: `version-dot-service-dot-project.appspot.com`

4. **Scaling Types:**
   - Automatic: Based on load (default)
   - Basic: On-demand with idle timeout
   - Manual: Fixed number of instances

5. **Deployment Strategies:**
   - Blue-Green: Deploy new, switch traffic instantly
   - Canary: Gradual rollout with monitoring
   - Rolling: Gradual instance replacement

6. **Common Scenarios:**
   - Zero-downtime deployment → Blue-Green or Canary
   - Test new version → Deploy with `--no-promote`
   - Gradual rollout → Canary with traffic splitting
   - Rollback → Switch traffic to previous version
   - Session affinity → Cookie-based splitting

---

**Повернутися до:** [Модуль 05 - App Engine](README.md)
