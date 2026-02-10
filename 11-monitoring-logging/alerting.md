# Alerting

## Fundamentals

**Alerting** - автоматичні сповіщення при виявленні проблем у системі.

### Що таке Alerting?

**Alerting** - це процес автоматичного виявлення та повідомлення про проблеми на основі метрик та логів.

**Key Concepts:**

- **Alert Policy**: Правило для виявлення проблем
- **Condition**: Умова спрацювання alert
- **Notification Channel**: Спосіб отримання сповіщення
- **Incident**: Активний alert

---

## Alert Policies

**Alert Policy** складається з:

1. **Conditions**: Що моніторити
2. **Notification Channels**: Кому повідомляти
3. **Documentation**: Як реагувати

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

---

## Alert Conditions

### Threshold Condition

**Опис:** Метрика перевищує/нижче порогу.

**Example:**

```bash
# CPU utilization > 80% for 5 minutes
--condition-threshold-value=0.8
--condition-threshold-duration=300s
--condition-filter='metric.type="compute.googleapis.com/instance/cpu/utilization"'
--condition-threshold-comparison=COMPARISON_GT
```

**Parameters:**

- **Threshold Value**: Значення порогу (0.8 = 80%)
- **Duration**: Скільки часу умова має бути true
- **Comparison**: GT (>), LT (<), GE (>=), LE (<=)
- **Aggregation**: ALIGN_MEAN, ALIGN_MAX, ALIGN_MIN

---

### Absence Condition

**Опис:** Метрика відсутня (no data).

**Example:**

```bash
# Uptime check failed (no data for 5 minutes)
--condition-absent-duration=300s
--condition-filter='metric.type="monitoring.googleapis.com/uptime_check/check_passed"'
```

**Use Cases:**

- ✅ Uptime checks failed
- ✅ Application stopped sending metrics
- ✅ Service down

---

### Rate of Change Condition

**Опис:** Швидкість зміни метрики.

**Example:**

```bash
# Request count increased by 50% in 5 minutes
--condition-threshold-value=0.5
--condition-threshold-duration=300s
--condition-filter='metric.type="loadbalancing.googleapis.com/https/request_count"'
--condition-threshold-comparison=COMPARISON_GT
--condition-threshold-aggregations=ALIGN_RATE
```

**Use Cases:**

- ✅ Traffic spike
- ✅ Error rate increase
- ✅ Cost spike

---

## Notification Channels

**Notification Channels** - способи отримання сповіщень.

### Email

```bash
gcloud alpha monitoring channels create \
  --display-name="Team Email" \
  --type=email \
  --channel-labels=email_address=team@example.com
```

### SMS

```bash
gcloud alpha monitoring channels create \
  --display-name="On-Call SMS" \
  --type=sms \
  --channel-labels=number=+1234567890
```

### Slack

```bash
gcloud alpha monitoring channels create \
  --display-name="Slack Channel" \
  --type=slack \
  --channel-labels=url=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```

### PagerDuty

```bash
gcloud alpha monitoring channels create \
  --display-name="PagerDuty" \
  --type=pagerduty \
  --channel-labels=service_key=YOUR_SERVICE_KEY
```

### Webhook

```bash
gcloud alpha monitoring channels create \
  --display-name="Custom Webhook" \
  --type=webhook_tokenauth \
  --channel-labels=url=https://example.com/webhook
```

### Pub/Sub

```bash
gcloud alpha monitoring channels create \
  --display-name="Pub/Sub Topic" \
  --type=pubsub \
  --channel-labels=topic=projects/PROJECT_ID/topics/alerts
```

---

## Alert Documentation

**Documentation** - інструкції для реагування на alert.

**Example:**

```bash
--documentation="
# High CPU Alert

## Runbook
https://wiki.example.com/runbooks/high-cpu

## Steps
1. Check application logs for errors
2. Identify slow queries or processes
3. Scale up if needed
4. Investigate root cause

## Contacts
- Team: backend-team@example.com
- On-Call: +1234567890
"
```

---

## Alert Best Practices

### 1. Set Meaningful Thresholds

```bash
# Good: Actionable threshold
CPU > 80% for 5 minutes

# Bad: Too sensitive
CPU > 50% for 1 minute
```

### 2. Use Appropriate Duration

```bash
# Good: Avoid flapping
--condition-threshold-duration=300s  # 5 minutes

# Bad: Too short
--condition-threshold-duration=60s  # 1 minute
```

### 3. Group Related Alerts

```bash
# Use labels
--user-labels=team=backend,severity=critical,service=api
```

### 4. Test Notification Channels

```bash
# Regularly test channels
gcloud alpha monitoring channels verify CHANNEL_ID
```

### 5. Document Runbooks

```bash
# Always include documentation
--documentation="Runbook: https://..."
```

---

## Practical Scenario: Multi-Tier Alerting

### Scenario

E-commerce application з різними рівнями severity.

**Requirements:**

- Critical alerts → PagerDuty + SMS
- Warning alerts → Slack
- Info alerts → Email

### Solution

**1. Create Notification Channels:**

```bash
# Critical: PagerDuty
PAGERDUTY_CHANNEL=$(gcloud alpha monitoring channels create \
  --display-name="PagerDuty Critical" \
  --type=pagerduty \
  --channel-labels=service_key=CRITICAL_KEY \
  --format="value(name)")

# Critical: SMS
SMS_CHANNEL=$(gcloud alpha monitoring channels create \
  --display-name="On-Call SMS" \
  --type=sms \
  --channel-labels=number=+1234567890 \
  --format="value(name)")

# Warning: Slack
SLACK_CHANNEL=$(gcloud alpha monitoring channels create \
  --display-name="Slack Warnings" \
  --type=slack \
  --channel-labels=url=https://hooks.slack.com/... \
  --format="value(name)")

# Info: Email
EMAIL_CHANNEL=$(gcloud alpha monitoring channels create \
  --display-name="Team Email" \
  --type=email \
  --channel-labels=email_address=team@example.com \
  --format="value(name)")
```

**2. Create Critical Alerts:**

```bash
# Site down (critical)
gcloud alpha monitoring policies create \
  --notification-channels=$PAGERDUTY_CHANNEL,$SMS_CHANNEL \
  --display-name="[CRITICAL] Site Down" \
  --condition-display-name="Uptime check failed" \
  --condition-absent-duration=300s \
  --condition-filter='metric.type="monitoring.googleapis.com/uptime_check/check_passed"' \
  --user-labels=severity=critical \
  --documentation="
Runbook: https://wiki.example.com/runbooks/site-down
Steps:
1. Check load balancer status
2. Verify backend health
3. Check recent deployments
4. Escalate to SRE if needed
"

# High error rate (critical)
gcloud alpha monitoring policies create \
  --notification-channels=$PAGERDUTY_CHANNEL,$SMS_CHANNEL \
  --display-name="[CRITICAL] High Error Rate" \
  --condition-display-name="Error rate > 5%" \
  --condition-threshold-value=0.05 \
  --condition-threshold-duration=300s \
  --condition-filter='metric.type="loadbalancing.googleapis.com/https/request_count" metric.label.response_code_class="500"' \
  --user-labels=severity=critical
```

**3. Create Warning Alerts:**

```bash
# High CPU (warning)
gcloud alpha monitoring policies create \
  --notification-channels=$SLACK_CHANNEL \
  --display-name="[WARNING] High CPU" \
  --condition-display-name="CPU > 80%" \
  --condition-threshold-value=0.8 \
  --condition-threshold-duration=600s \
  --condition-filter='metric.type="compute.googleapis.com/instance/cpu/utilization"' \
  --user-labels=severity=warning

# High latency (warning)
gcloud alpha monitoring policies create \
  --notification-channels=$SLACK_CHANNEL \
  --display-name="[WARNING] High Latency" \
  --condition-display-name="Latency > 1s" \
  --condition-threshold-value=1000 \
  --condition-threshold-duration=600s \
  --condition-filter='metric.type="loadbalancing.googleapis.com/https/total_latencies"' \
  --user-labels=severity=warning
```

**4. Create Info Alerts:**

```bash
# Deployment completed (info)
gcloud alpha monitoring policies create \
  --notification-channels=$EMAIL_CHANNEL \
  --display-name="[INFO] Deployment Completed" \
  --condition-display-name="Deployment event" \
  --condition-filter='resource.type="gce_instance" protoPayload.methodName="compute.instances.insert"' \
  --user-labels=severity=info
```

---

## Alert Fatigue Prevention

### 1. Avoid Noisy Alerts

```bash
# Bad: Too many alerts
CPU > 50% for 1 minute

# Good: Meaningful threshold
CPU > 80% for 5 minutes
```

### 2. Use Alert Grouping

```bash
# Group by service
--user-labels=service=api,team=backend

# Single alert for all instances
--condition-filter='metric.type="..." resource.type="gce_instance"'
```

### 3. Implement Escalation

```
Level 1 (Warning) → Slack (5 minutes)
Level 2 (Critical) → PagerDuty (10 minutes)
Level 3 (Emergency) → SMS + Phone (15 minutes)
```

### 4. Regular Review

```bash
# Review alert history
gcloud alpha monitoring policies list

# Check incident frequency
# Adjust thresholds based on data
```

---

## Cross-References

**[Module 11 - Cloud Monitoring](cloud-monitoring.md)**

- Metrics and dashboards
- Uptime checks
- Alert policies

**[Module 11 - Cloud Logging](cloud-logging.md)**

- Log-based metrics
- Log-based alerts

**[Module 03 - Compute Engine](../03-compute-engine/instance-groups.md)**

- Autoscaling based on metrics
- Health checks

**[Module 09 - Load Balancing](../09-networking/load-balancing.md)**

- Load balancer health checks
- Backend health monitoring

---

> ⚠️ **Важливо для іспиту**: Розуміння різних типів alert conditions (threshold, absence, rate of change) та notification channels критично важливе. Знайте як створювати alert policies для різних сценаріїв та як уникати alert fatigue.

---

**Повернутися до:** [Модуль 11 - Monitoring & Logging](README.md)
