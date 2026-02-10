# Cloud Logging

## Fundamentals

**Cloud Logging** - це централізований сервіс для збору, зберігання та аналізу логів з GCP ресурсів та додатків.

### Що таке Logging?

**Logging** - це процес запису подій та діагностичної інформації для debugging, auditing та compliance.

**Key Concepts:**

- **Log entry**: Одна запис в логах
- **Log name**: Ідентифікатор типу логу
- **Severity**: Рівень важливості (DEBUG, INFO, WARNING, ERROR, CRITICAL)
- **Retention**: Період зберігання логів

---

## Log Types

### Platform Logs

**Автоматично збираються** GCP сервісами.

#### Admin Activity Logs

**Опис:** API calls що змінюють конфігурацію ресурсів.

**Characteristics:**

- **Retention**: 400 days (безкоштовно)
- **Cannot be disabled**
- **Examples**: Create VM, delete bucket, change IAM policy

**View:**

```bash
gcloud logging read "logName:activity" --limit=10
```

---

#### Data Access Logs

**Опис:** API calls що читають/пишуть дані.

**Characteristics:**

- **Retention**: 30 days (default)
- **Disabled by default** (except BigQuery)
- **Examples**: Read object, query database, list files

**Enable:**

```bash
# Enable for Cloud Storage
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=serviceAccount:SERVICE_ACCOUNT \
  --role=roles/logging.configWriter
```

**Types:**

- **ADMIN_READ**: Metadata operations (list buckets)
- **DATA_READ**: Data read operations (download file)
- **DATA_WRITE**: Data write operations (upload file)

---

#### System Event Logs

**Опис:** GCP system events (не user-initiated).

**Characteristics:**

- **Retention**: 400 days
- **Automatically enabled**
- **Examples**: VM preemption, autoscaling events

---

#### Access Transparency Logs

**Опис:** Actions performed by Google staff.

**Characteristics:**

- **Available**: Enterprise+ customers
- **Retention**: 400 days
- **Examples**: Google engineer accessing data for support

---

### Application Logs

**Власні логи** з додатків.

**Write Log (Python):**

```python
from google.cloud import logging

# Initialize client
client = logging.Client()
logger = client.logger("my-app-log")

# Write log entry
logger.log_text("Application started", severity="INFO")
logger.log_struct({
    "message": "User logged in",
    "user_id": "12345",
    "ip_address": "192.168.1.1"
}, severity="INFO")
```

**Write Log (gcloud):**

```bash
gcloud logging write my-app-log "Application error occurred" \
  --severity=ERROR \
  --resource=gce_instance
```

---

## Log Retention

### Default Retention

| Log Type | Retention | Cost |
|----------|-----------|------|
| **Admin Activity** | 400 days | Free |
| **System Event** | 400 days | Free |
| **Access Transparency** | 400 days | Free |
| **Data Access** | 30 days | Paid |
| **Application Logs** | 30 days | Paid |

### Custom Retention

**Create Log Bucket with Custom Retention:**

```bash
gcloud logging buckets create my-bucket \
  --location=global \
  --retention-days=365
```

**Create Log Sink to Bucket:**

```bash
gcloud logging sinks create my-sink \
  logging.googleapis.com/projects/PROJECT_ID/locations/global/buckets/my-bucket \
  --log-filter='resource.type="gce_instance"'
```

---

## Log Queries

### Logs Explorer

**Basic Query:**

```
resource.type="gce_instance"
severity="ERROR"
timestamp>="2024-01-01T00:00:00Z"
```

**Advanced Query:**

```
resource.type="gce_instance"
AND resource.labels.instance_id="1234567890"
AND (severity="ERROR" OR severity="CRITICAL")
AND jsonPayload.message=~"database.*timeout"
```

### Query Filters

**Resource Type:**

```
resource.type="gce_instance"
resource.type="cloud_function"
resource.type="k8s_container"
```

**Severity:**

```
severity="ERROR"
severity>="WARNING"
```

**Time Range:**

```
timestamp>="2024-01-01T00:00:00Z"
timestamp<"2024-01-02T00:00:00Z"
```

**Text Search:**

```
textPayload=~"error"
jsonPayload.message=~"database.*timeout"
```

**Logical Operators:**

```
AND, OR, NOT
resource.type="gce_instance" AND severity="ERROR"
```

---

## Log-Based Metrics

**Log-Based Metrics** - створення метрик з логів для моніторингу.

### Create Counter Metric

```bash
gcloud logging metrics create error_count \
  --description="Count of error logs" \
  --log-filter='severity="ERROR"' \
  --value-extractor=''
```

### Create Distribution Metric

```bash
gcloud logging metrics create request_latency \
  --description="Request latency distribution" \
  --log-filter='jsonPayload.latency:*' \
  --value-extractor='EXTRACT(jsonPayload.latency)' \
  --metric-kind=DELTA \
  --value-type=DISTRIBUTION
```

### Use in Alerting

```bash
# Create alert on log-based metric
gcloud alpha monitoring policies create \
  --notification-channels=$CHANNEL_ID \
  --display-name="High Error Rate" \
  --condition-threshold-value=10 \
  --condition-threshold-duration=300s \
  --condition-filter='metric.type="logging.googleapis.com/user/error_count"'
```

---

## Log Sinks

**Log Sinks** - експорт логів до інших сервісів.

### Sink to Cloud Storage

```bash
gcloud logging sinks create storage-sink \
  storage.googleapis.com/my-logs-bucket \
  --log-filter='resource.type="gce_instance" AND severity>="WARNING"'
```

### Sink to BigQuery

```bash
gcloud logging sinks create bigquery-sink \
  bigquery.googleapis.com/projects/PROJECT_ID/datasets/logs_dataset \
  --log-filter='resource.type="cloud_function"'
```

### Sink to Pub/Sub

```bash
gcloud logging sinks create pubsub-sink \
  pubsub.googleapis.com/projects/PROJECT_ID/topics/logs-topic \
  --log-filter='severity="ERROR"'
```

### Sink Permissions

```bash
# Grant sink service account permissions
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=serviceAccount:SINK_SERVICE_ACCOUNT \
  --role=roles/storage.objectCreator
```

---

## Structured Logging

**Structured Logging** - логування в JSON format для кращого аналізу.

**Example (Python):**

```python
import logging
import google.cloud.logging

# Setup Cloud Logging
client = google.cloud.logging.Client()
client.setup_logging()

# Structured log
logging.info("User action", extra={
    "json_fields": {
        "user_id": "12345",
        "action": "purchase",
        "amount": 99.99,
        "currency": "USD"
    }
})
```

**Query Structured Logs:**

```
jsonPayload.user_id="12345"
jsonPayload.action="purchase"
jsonPayload.amount>=100
```

---

## Practical Scenario: Application Logging Strategy

### Scenario

Microservices application з compliance requirements.

**Requirements:**

- Retain audit logs for 7 years
- Export error logs to BigQuery for analysis
- Alert on critical errors
- Cost optimization

### Solution

**1. Configure Log Retention:**

```bash
# Create long-term retention bucket for audit logs
gcloud logging buckets create audit-logs \
  --location=us-central1 \
  --retention-days=2555  # 7 years

# Create sink for audit logs
gcloud logging sinks create audit-sink \
  logging.googleapis.com/projects/PROJECT_ID/locations/us-central1/buckets/audit-logs \
  --log-filter='protoPayload.methodName:*'
```

**2. Export Errors to BigQuery:**

```bash
# Create BigQuery dataset
bq mk --dataset --location=US logs_dataset

# Create sink
gcloud logging sinks create error-analysis-sink \
  bigquery.googleapis.com/projects/PROJECT_ID/datasets/logs_dataset \
  --log-filter='severity>="ERROR"'
```

**3. Create Log-Based Metric:**

```bash
gcloud logging metrics create critical_errors \
  --description="Count of critical errors" \
  --log-filter='severity="CRITICAL"'
```

**4. Create Alert:**

```bash
gcloud alpha monitoring policies create \
  --notification-channels=$PAGERDUTY_CHANNEL \
  --display-name="Critical Error Alert" \
  --condition-threshold-value=1 \
  --condition-threshold-duration=60s \
  --condition-filter='metric.type="logging.googleapis.com/user/critical_errors"'
```

**5. Exclude Noisy Logs:**

```bash
# Exclude health check logs to reduce costs
gcloud logging sinks create _Default \
  logging.googleapis.com/projects/PROJECT_ID/locations/global/buckets/_Default \
  --log-filter='NOT (resource.type="http_load_balancer" AND httpRequest.requestUrl=~"/health")'
```

---

## Best Practices

### 1. Use Structured Logging

```python
# Good: Structured
logger.log_struct({
    "message": "Order processed",
    "order_id": "12345",
    "amount": 99.99
})

# Bad: Unstructured
logger.log_text("Order 12345 processed for $99.99")
```

### 2. Set Appropriate Severity

```python
logger.log_text("Debug info", severity="DEBUG")
logger.log_text("Normal operation", severity="INFO")
logger.log_text("Potential issue", severity="WARNING")
logger.log_text("Error occurred", severity="ERROR")
logger.log_text("System failure", severity="CRITICAL")
```

### 3. Include Context

```python
logger.log_struct({
    "message": "Database query failed",
    "query": "SELECT * FROM users",
    "error": str(e),
    "user_id": user_id,
    "trace_id": trace_id
})
```

### 4. Optimize Costs

```bash
# Exclude verbose logs
--log-filter='NOT (severity="DEBUG")'

# Exclude health checks
--log-filter='NOT (httpRequest.requestUrl=~"/health")'

# Use sampling for high-volume logs
--log-filter='sample(insertId, 0.1)'  # 10% sampling
```

### 5. Use Log Sinks for Long-Term Storage

```bash
# Export to Cloud Storage for archival
gcloud logging sinks create archive-sink \
  storage.googleapis.com/archive-logs-bucket \
  --log-filter='timestamp<"-P30D"'  # Logs older than 30 days
```

---

## Cross-References

**[Module 03 - Compute Engine](../03-compute-engine/vm-instances.md)**

- VM logs
- Serial console logs

**[Module 04 - GKE](../04-kubernetes-engine/workloads.md)**

- Container logs
- Cluster logs

**[Module 05 - App Engine](../05-app-engine/deployment.md)**

- Application logs
- Request logs

**[Module 11 - Cloud Monitoring](cloud-monitoring.md)**

- Log-based metrics
- Integration with monitoring

**[Module 11 - Alerting](alerting.md)**

- Alerts on log-based metrics

---

> ⚠️ **Важливо для іспиту**: Розуміння різних типів логів (Admin Activity, Data Access, System Event), retention policies та log sinks критично важливе. Знайте як створювати log-based metrics та використовувати їх для alerting.

---

**Повернутися до:** [Модуль 11 - Monitoring & Logging](README.md)
