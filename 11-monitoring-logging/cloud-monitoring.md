# Cloud Monitoring

## Fundamentals

**Cloud Monitoring** - це сервіс для збору, аналізу та візуалізації метрик з GCP ресурсів та додатків.

### Що таке Monitoring?

**Monitoring** - це процес збору та аналізу даних про performance та health систем для виявлення проблем та оптимізації.

**Key Concepts:**

- **Metrics**: Числові дані про систему (CPU, memory, latency)
- **Time series**: Послідовність значень метрики в часі
- **Dashboards**: Візуалізація метрик
- **Alerts**: Автоматичні сповіщення при проблемах

---

## Metrics

### System Metrics

**Автоматично збираються** для GCP ресурсів.

**Compute Engine Metrics:**

```
compute.googleapis.com/instance/cpu/utilization
compute.googleapis.com/instance/disk/read_bytes_count
compute.googleapis.com/instance/disk/write_bytes_count
compute.googleapis.com/instance/network/received_bytes_count
compute.googleapis.com/instance/network/sent_bytes_count
```

**Cloud Storage Metrics:**

```
storage.googleapis.com/storage/total_bytes
storage.googleapis.com/api/request_count
storage.googleapis.com/network/sent_bytes_count
```

**Cloud SQL Metrics:**

```
cloudsql.googleapis.com/database/cpu/utilization
cloudsql.googleapis.com/database/memory/utilization
cloudsql.googleapis.com/database/disk/bytes_used
```

---

### Custom Metrics

**Власні метрики** для додатків.

**Create Custom Metric (Python):**

```python
from google.cloud import monitoring_v3
import time

client = monitoring_v3.MetricServiceClient()
project_name = f"projects/{project_id}"

# Define metric descriptor
descriptor = monitoring_v3.MetricDescriptor()
descriptor.type = "custom.googleapis.com/my_app/request_count"
descriptor.metric_kind = monitoring_v3.MetricDescriptor.MetricKind.GAUGE
descriptor.value_type = monitoring_v3.MetricDescriptor.ValueType.INT64
descriptor.description = "Number of requests"

# Create descriptor
descriptor = client.create_metric_descriptor(
    name=project_name, metric_descriptor=descriptor
)

# Write time series data
series = monitoring_v3.TimeSeries()
series.metric.type = "custom.googleapis.com/my_app/request_count"
series.resource.type = "gce_instance"
series.resource.labels["instance_id"] = "1234567890"
series.resource.labels["zone"] = "us-central1-a"

# Add data point
point = monitoring_v3.Point()
point.value.int64_value = 100
point.interval.end_time.seconds = int(time.time())
series.points = [point]

# Write to Cloud Monitoring
client.create_time_series(name=project_name, time_series=[series])
```

**Use Cases:**

- ✅ Application-specific metrics (requests/sec, errors)
- ✅ Business metrics (orders, revenue)
- ✅ Custom performance indicators

---

## Dashboards

**Dashboards** - візуалізація метрик для моніторингу.

### Create Dashboard (gcloud)

```bash
# Create dashboard from JSON
gcloud monitoring dashboards create --config-from-file=dashboard.json
```

**dashboard.json:**

```json
{
  "displayName": "My Application Dashboard",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "width": 6,
        "height": 4,
        "widget": {
          "title": "CPU Utilization",
          "xyChart": {
            "dataSets": [{
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN"
                  }
                }
              }
            }]
          }
        }
      }
    ]
  }
}
```

### Dashboard Best Practices

**1. Group Related Metrics:**

```
Application Dashboard:
├─ Request Rate
├─ Error Rate
├─ Latency (p50, p95, p99)
└─ Resource Utilization
```

**2. Use Appropriate Chart Types:**

- **Line charts**: Time series data (CPU, memory)
- **Heatmaps**: Distribution (latency percentiles)
- **Gauges**: Current values (disk usage)
- **Tables**: Multiple metrics comparison

**3. Set Meaningful Time Ranges:**

- Last 1 hour: Real-time monitoring
- Last 24 hours: Daily patterns
- Last 7 days: Weekly trends

---

## Uptime Checks

**Uptime Checks** - автоматична перевірка доступності сервісів.

### HTTP Uptime Check

```bash
gcloud monitoring uptime create my-uptime-check \
  --resource-type=uptime-url \
  --host=example.com \
  --path=/health \
  --check-interval=60s \
  --timeout=10s
```

### Types of Uptime Checks

**1. HTTP(S) Check:**

```bash
gcloud monitoring uptime create http-check \
  --resource-type=uptime-url \
  --host=example.com \
  --path=/api/health \
  --port=443 \
  --use-ssl \
  --check-interval=60s
```

**2. TCP Check:**

```bash
gcloud monitoring uptime create tcp-check \
  --resource-type=uptime-url \
  --host=database.example.com \
  --port=3306 \
  --check-interval=60s
```

**3. Regions:**

```bash
# Check from multiple regions
--regions=us-central1,europe-west1,asia-east1
```

---

## Alerting Policies

**Alerting Policies** - автоматичні сповіщення при проблемах.

### Create Alert Policy

```bash
gcloud alpha monitoring policies create \
  --notification-channels=CHANNEL_ID \
  --display-name="High CPU Alert" \
  --condition-display-name="CPU > 80%" \
  --condition-threshold-value=0.8 \
  --condition-threshold-duration=300s \
  --condition-filter='metric.type="compute.googleapis.com/instance/cpu/utilization" resource.type="gce_instance"'
```

### Alert Conditions

**Threshold Condition:**

```
Metric: CPU utilization
Condition: > 80%
Duration: 5 minutes
Aggregation: Mean
```

**Absence Condition:**

```
Metric: Uptime check
Condition: No data for 5 minutes
```

**Rate of Change:**

```
Metric: Request count
Condition: Increase > 50% in 5 minutes
```

---

## Notification Channels

**Notification Channels** - способи отримання сповіщень.

### Create Email Channel

```bash
gcloud alpha monitoring channels create \
  --display-name="Team Email" \
  --type=email \
  --channel-labels=email_address=team@example.com
```

### Supported Channels

| Channel | Use Case |
|---------|----------|
| **Email** | General notifications |
| **SMS** | Critical alerts |
| **Slack** | Team collaboration |
| **PagerDuty** | On-call rotation |
| **Webhooks** | Custom integrations |
| **Pub/Sub** | Event-driven automation |

---

## Practical Scenario: Web Application Monitoring

### Scenario

E-commerce website з high availability requirements.

**Requirements:**

- Monitor CPU, memory, disk
- Track request rate and latency
- Alert on high error rate
- Uptime checks for critical endpoints

### Solution

**1. Create Dashboard:**

```json
{
  "displayName": "E-commerce Dashboard",
  "mosaicLayout": {
    "tiles": [
      {
        "widget": {
          "title": "Request Rate",
          "xyChart": {
            "dataSets": [{
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"loadbalancing.googleapis.com/https/request_count\""
                }
              }
            }]
          }
        }
      },
      {
        "widget": {
          "title": "Error Rate",
          "xyChart": {
            "dataSets": [{
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "metric.type=\"loadbalancing.googleapis.com/https/request_count\" metric.label.response_code_class=\"500\""
                }
              }
            }]
          }
        }
      }
    ]
  }
}
```

**2. Create Uptime Checks:**

```bash
# Homepage check
gcloud monitoring uptime create homepage-check \
  --resource-type=uptime-url \
  --host=www.example.com \
  --path=/ \
  --check-interval=60s

# API health check
gcloud monitoring uptime create api-health-check \
  --resource-type=uptime-url \
  --host=api.example.com \
  --path=/health \
  --check-interval=60s
```

**3. Create Alert Policies:**

```bash
# High error rate alert
gcloud alpha monitoring policies create \
  --notification-channels=$EMAIL_CHANNEL \
  --display-name="High Error Rate" \
  --condition-display-name="Error rate > 5%" \
  --condition-threshold-value=0.05 \
  --condition-threshold-duration=300s \
  --condition-filter='metric.type="loadbalancing.googleapis.com/https/request_count" metric.label.response_code_class="500"'

# High latency alert
gcloud alpha monitoring policies create \
  --notification-channels=$PAGERDUTY_CHANNEL \
  --display-name="High Latency" \
  --condition-display-name="Latency > 1s" \
  --condition-threshold-value=1000 \
  --condition-threshold-duration=300s \
  --condition-filter='metric.type="loadbalancing.googleapis.com/https/total_latencies"'

# Uptime check failure
gcloud alpha monitoring policies create \
  --notification-channels=$SMS_CHANNEL \
  --display-name="Site Down" \
  --condition-display-name="Uptime check failed" \
  --condition-absent-duration=300s \
  --condition-filter='metric.type="monitoring.googleapis.com/uptime_check/check_passed"'
```

---

## Best Practices

### 1. Monitor Key Metrics

**Golden Signals:**

- **Latency**: Response time
- **Traffic**: Requests per second
- **Errors**: Error rate
- **Saturation**: Resource utilization

### 2. Set Meaningful Alerts

```bash
# Good: Actionable alert
"CPU > 80% for 5 minutes"

# Bad: Noisy alert
"CPU > 50% for 1 minute"
```

### 3. Use Alert Documentation

```bash
--documentation="
Runbook: https://wiki.example.com/runbooks/high-cpu
Steps:
1. Check application logs
2. Identify slow queries
3. Scale up if needed
"
```

### 4. Group Alerts

```bash
# Use labels to group related alerts
--user-labels=team=backend,severity=critical
```

### 5. Test Alerts

```bash
# Regularly test notification channels
# Verify on-call rotation
# Review alert history
```

---

## Cross-References

**[Module 03 - Compute Engine](../03-compute-engine/vm-instances.md)**

- VM metrics monitoring
- Instance health checks

**[Module 04 - GKE](../04-kubernetes-engine/clusters-and-nodes.md)**

- GKE metrics
- Container monitoring

**[Module 07 - Storage](../07-storage/cloud-storage.md)**

- Storage metrics
- Cost tracking

**[Module 09 - Load Balancing](../09-networking/load-balancing.md)**

- Load balancer metrics
- Health checks

**[Module 11 - Cloud Logging](cloud-logging.md)**

- Log-based metrics
- Integration with monitoring

**[Module 11 - Alerting](alerting.md)**

- Alert policies
- Notification channels

---

> ⚠️ **Важливо для іспиту**: Розуміння різниці між metrics, logs та traces критично важливе. Знайте як створювати dashboards, uptime checks та alerting policies для різних сценаріїв.

---

**Повернутися до:** [Модуль 11 - Monitoring & Logging](README.md)
