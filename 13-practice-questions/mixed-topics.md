# Mixed Topics

Змішані питання для підготовки до Google Cloud Associate Cloud Engineer іспиту.

---

## Question 1: Storage Latency

Which storage option provides the lowest latency for VM workloads?

A) Cloud Storage  
B) Persistent Disk SSD  
C) Local SSD  
D) Filestore

**Правильна відповідь:** C

**Пояснення:** Local SSD надає найнижчу latency (sub-millisecond), оскільки фізично прикріплений до VM host. Однак data не persistent після VM deletion.

**Чому інші варіанти неправильні:**

- A: Cloud Storage має higher latency (network-based)
- B: Persistent Disk SSD має latency ~1-2ms
- D: Filestore має latency ~1-3ms (NFS protocol overhead)

---

## Question 2: Temporary Access

You need to grant temporary access to a Cloud Storage bucket for 1 hour. What should you use?

A) IAM policy with time-based condition  
B) Signed URL with 1-hour expiration  
C) ACL with temporary permission  
D) Bucket policy

**Правильна відповідь:** B

**Пояснення:** Signed URLs надають тимчасовий доступ з expiration time без зміни IAM policies. Ideal для temporary access scenarios.

**Чому інші варіанти неправильні:**

- A: IAM conditions складніші і потребують cleanup
- C: ACLs не мають expiration mechanism
- D: Bucket policies не існують в GCS (це AWS concept)

---

## Question 3: Machine Type Selection

Your application requires 16 vCPUs and 64 GB RAM. Which machine type should you use?

A) n1-standard-16  
B) n2-highmem-16  
C) n2-standard-16  
D) Custom machine type

**Правильна відповідь:** B

**Пояснення:** n2-highmem-16 має 16 vCPUs та 128 GB RAM (8 GB per vCPU), що покриває requirement 64 GB. Highmem series оптимізована для memory-intensive workloads.

**Чому інші варіанти неправильні:**

- A: n1-standard-16 має 60 GB RAM (недостатньо)
- C: n2-standard-16 має 64 GB RAM (точно requirement, але highmem краще для memory-intensive)
- D: Custom machine type дорожчий без необхідності

---

## Question 4: VPC Subnet Range

You need to create a subnet that supports 1000 IP addresses. What's the minimum CIDR range?

A) /24 (256 addresses)  
B) /23 (512 addresses)  
C) /22 (1024 addresses)  
D) /21 (2048 addresses)

**Правильна відповідь:** C

**Пояснення:** /22 CIDR надає 1024 IP addresses (2^(32-22) = 1024). GCP reserves 4 IPs per subnet, тому usable IPs = 1020, що покриває requirement 1000.

**Чому інші варіанти неправильні:**

- A: /24 надає тільки 256 IPs (недостатньо)
- B: /23 надає 512 IPs (недостатньо)
- D: /21 надає 2048 IPs (занадто багато, марнує IP space)

---

## Question 5: Firestore vs Bigtable

Your mobile app needs to store user profiles with complex queries and real-time sync. Which database should you use?

A) Cloud SQL  
B) Cloud Spanner  
C) Firestore  
D) Bigtable

**Правильна відповідь:** C

**Пояснення:** Firestore - NoSQL document database з real-time sync, offline support, та complex queries. Ideal для mobile/web apps.

**Чому інші варіанти неправильні:**

- A: Cloud SQL relational database, не має real-time sync
- B: Spanner дорогий для mobile app use case
- D: Bigtable не підтримує complex queries та real-time sync

---

## Question 6: gcloud Configuration

You work on multiple GCP projects. How should you manage gcloud configurations?

A) Use single configuration, change project each time  
B) Create separate configuration for each project  
C) Use different user accounts  
D) Reinstall gcloud SDK for each project

**Правильна відповідь:** B

**Пояснення:** Separate configurations дозволяють швидко switch між projects з `gcloud config configurations activate`. Кожна configuration зберігає project, region, zone settings.

**Чому інші варіанти неправильні:**

- A: Changing project manually кожен раз inefficient
- C: Different user accounts не потрібні для multiple projects
- D: Reinstalling SDK impractical

---

## Question 7: Cloud Functions Timeout

Your Cloud Function processes large files and takes 15 minutes. What should you do?

A) Increase timeout to 15 minutes  
B) Use Cloud Run instead  
C) Split into multiple functions  
D) Use Compute Engine

**Правильна відповідь:** B

**Пояснення:** Cloud Functions має maximum timeout 9 minutes. Cloud Run підтримує до 60 minutes timeout і краще підходить для long-running tasks.

**Чому інші варіанти неправильні:**

- A: 15 minutes перевищує Cloud Functions maximum (9 min)
- C: Splitting додає complexity
- D: Compute Engine overkill для single task

---

## Question 8: Snapshot Scheduling

You need automated daily snapshots of persistent disks at 2 AM. What should you use?

A) Cron job with gcloud commands  
B) Snapshot schedule policy  
C) Cloud Functions with Cloud Scheduler  
D) Manual snapshots

**Правильна відповідь:** B

**Пояснення:** Snapshot schedule policy - native GCP feature для automated snapshots з specified frequency та retention. No custom code needed.

**Чому інші варіанти неправильні:**

- A: Cron job потребує VM running 24/7
- C: Cloud Functions додає unnecessary complexity
- D: Manual snapshots не automated

---

## Question 9: App Engine Scaling

Your App Engine app has unpredictable traffic. Which scaling type should you use?

A) Manual scaling  
B) Basic scaling  
C) Automatic scaling  
D) No scaling

**Правильна відповідь:** C

**Пояснення:** Automatic scaling автоматично adjusts instances based on traffic. Ideal для unpredictable workloads з rapid scaling.

**Чому інші варіанти неправильні:**

- A: Manual scaling потребує human intervention
- B: Basic scaling має slower scaling response
- D: No scaling не адаптується до traffic changes

---

## Question 10: Cloud SQL Backup

Your Cloud SQL database requires point-in-time recovery. What should you enable?

A) Automated backups only  
B) Binary logging and automated backups  
C) Manual backups  
D) Read replicas

**Правильна відповідь:** B

**Пояснення:** Point-in-time recovery (PITR) потребує both automated backups AND binary logging. Binary logs зберігають all transactions для recovery до specific timestamp.

**Чому інші варіанти неправильні:**

- A: Automated backups alone не дозволяють PITR
- C: Manual backups не continuous
- D: Read replicas для scaling, не для PITR

---

## Question 11: GKE Node Pool

You need to run GPU workloads on GKE. What should you do?

A) Add GPUs to default node pool  
B) Create separate node pool with GPU-enabled nodes  
C) Use Compute Engine instead  
D) Enable GPU on all nodes

**Правильна відповідь:** B

**Пояснення:** Separate node pool з GPU-enabled nodes дозволяє isolate GPU workloads та optimize costs. GPU nodes дорогі, тому краще мати dedicated pool.

**Чому інші варіанти неправильні:**

- A: Default node pool може мати non-GPU workloads
- C: GKE provides better orchestration для GPU workloads
- D: Enabling GPU на всіх nodes марнує resources

---

## Question 12: Load Balancer Health Check

Your backend instances are failing health checks but are actually healthy. What should you check?

A) Health check interval  
B) Firewall rules allowing health check probes  
C) Backend instance CPU  
D) Load balancer configuration

**Правильна відповідь:** B

**Пояснення:** GCP health checks come from specific IP ranges (35.191.0.0/16, 130.211.0.0/22). Firewall rules must allow these IPs, інакше health checks fail.

**Чому інші варіанти неправильні:**

- A: Interval не впливає на failing checks
- C: CPU не relevant якщо instances healthy
- D: LB configuration не причина якщо instances healthy

---

## Question 13: Cloud Armor Rule

You need to block traffic from a specific country. What should you configure?

A) Firewall rule  
B) Cloud Armor security policy with geo-based rule  
C) VPC Service Controls  
D) IAM policy

**Правильна відповідь:** B

**Пояснення:** Cloud Armor підтримує geo-based rules для blocking/allowing traffic based on country/region. Works з HTTP(S) Load Balancer.

**Чому інші варіанти неправильні:**

- A: Firewall rules не підтримують geo-based filtering
- C: VPC Service Controls для API access control
- D: IAM policy для authentication/authorization

---

## Question 14: Persistent Disk Performance

Your application requires 30,000 IOPS. Which disk type should you use?

A) Standard persistent disk  
B) Balanced persistent disk  
C) SSD persistent disk  
D) Local SSD

**Правильна відповідь:** C

**Пояснення:** SSD persistent disk надає до 100,000 IOPS (read) та 60,000 IOPS (write). Balanced PD максимум 80,000 IOPS read.

**Чому інші варіанти неправильні:**

- A: Standard PD максимум 7,500 IOPS
- B: Balanced PD максимум 80,000 IOPS (може працювати, але SSD краще)
- D: Local SSD не persistent

---

## Question 15: Cloud Build Substitution

You need to use the Git commit SHA in your Cloud Build configuration. Which variable should you use?

A) $PROJECT_ID  
B) $BUILD_ID  
C) $COMMIT_SHA  
D) $SHORT_SHA

**Правильна відповідь:** C

**Пояснення:** $COMMIT_SHA - built-in substitution variable з full Git commit SHA. $SHORT_SHA - short version (7 characters).

**Чому інші варіанти неправильні:**

- A: $PROJECT_ID - GCP project ID
- B: $BUILD_ID - Cloud Build execution ID
- D: $SHORT_SHA - short commit SHA (може використовуватись, але питання asks for commit SHA)

---

## Question 16: Service Account Key

You need to authenticate a third-party application to GCP. What's the best practice?

A) Use user credentials  
B) Create service account key and rotate regularly  
C) Use default service account  
D) Share admin credentials

**Правильна відповідь:** B

**Пояснення:** Service account key з regular rotation - best practice для third-party apps. Keys should be rotated every 90 days та stored securely.

**Чому інші варіанти неправильні:**

- A: User credentials не підходять для applications
- C: Default service account має broad permissions
- D: Sharing admin credentials - major security risk

---

## Question 17: Cloud Storage Lifecycle Action

You need to automatically delete objects older than 365 days. What should you configure?

A) Retention policy  
B) Lifecycle rule with Delete action and Age condition  
C) Bucket lock  
D) Versioning

**Правильна відповідь:** B

**Пояснення:** Lifecycle rule з Delete action та Age=365 condition автоматично deletes objects після 365 днів.

**Чому інші варіанти неправильні:**

- A: Retention policy prevents deletion (opposite requirement)
- C: Bucket lock prevents modification
- D: Versioning зберігає versions, не deletes

---

## Question 18: GKE Cluster Autoscaling

Your GKE cluster needs to automatically add nodes when pods are pending. What should you enable?

A) Horizontal Pod Autoscaler  
B) Vertical Pod Autoscaler  
C) Cluster Autoscaler  
D) Node Pool Autoscaling

**Правильна відповідь:** C

**Пояснення:** Cluster Autoscaler автоматично adds/removes nodes based on pending pods. Monitors resource requests та adjusts node count.

**Чому інші варіанти неправильні:**

- A: HPA scales pods, не nodes
- B: VPA adjusts pod resources, не nodes
- D: Node Pool Autoscaling - same as Cluster Autoscaler (terminology)

---

## Question 19: Cloud Monitoring Metric

You need to monitor custom application metrics. What should you use?

A) System metrics only  
B) Cloud Monitoring API to write custom metrics  
C) Cloud Logging  
D) External monitoring tool

**Правильна відповідь:** B

**Пояснення:** Cloud Monitoring API дозволяє write custom metrics з application code. Supports Python, Java, Node.js SDKs.

**Чому інші варіанти неправильні:**

- A: System metrics тільки для GCP resources
- C: Cloud Logging для logs, не metrics
- D: External tool додає complexity

---

## Question 20: Deployment Manager Reference

You need to reference another resource's property in Deployment Manager. What syntax should you use?

A) ${resource.property}  
B) $(ref.resource-name.property)  
C) {{resource.property}}  
D) @resource.property

**Правильна відповідь:** B

**Пояснення:** $(ref.resource-name.property) - Deployment Manager syntax для referencing resource properties. Example: $(ref.my-bucket.name)

**Чому інші варіанти неправильні:**

- A: ${} - shell variable syntax
- C: {{}} - Jinja2 template syntax (used in templates, not configs)
- D: @ - не valid Deployment Manager syntax

---

**Повернутися до:** [Модуль 13 - Practice Questions](README.md)
