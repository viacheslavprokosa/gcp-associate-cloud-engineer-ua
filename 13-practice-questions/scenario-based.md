# Scenario-Based Questions

Практичні питання для підготовки до Google Cloud Associate Cloud Engineer іспиту.

---

## Question 1: Web Application Migration

Your company needs to migrate a monolithic web application to GCP. The application uses MySQL database and requires minimal downtime during migration. What's the best approach?

A) Rewrite the application as microservices on GKE  
B) Lift-and-shift to Compute Engine with Cloud SQL  
C) Deploy directly to App Engine Standard  
D) Break into Cloud Functions

**Правильна відповідь:** B

**Пояснення:** Lift-and-shift до Compute Engine з Cloud SQL мінімізує зміни в коді та забезпечує швидку міграцію з мінімальним downtime. Cloud SQL підтримує MySQL і може бути налаштований для реплікації з on-premises database.

**Чому інші варіанти неправильні:**

- A: Rewrite as microservices потребує значних змін у коді та часу
- C: App Engine може мати обмеження для monolithic applications
- D: Cloud Functions не підходить для monolithic applications

---

## Question 2: Cost Optimization for Batch Processing

You need to process 1 million images uploaded daily to Cloud Storage. Each image takes 2 minutes to process. The processing can tolerate interruptions. What's the most cost-effective solution?

A) Compute Engine standard VMs running 24/7  
B) Cloud Functions triggered by Cloud Storage events  
C) Preemptible VMs with batch processing  
D) GKE cluster with autoscaling

**Правильна відповідь:** C

**Пояснення:** Preemptible VMs коштують до 80% дешевше за standard VMs і ідеально підходять для batch processing з tolerance до interruptions. Для 1 млн images по 2 хвилини кожна, це найбільш cost-effective рішення.

**Чому інші варіанти неправильні:**

- A: Standard VMs 24/7 дуже дорогі для batch workloads
- B: Cloud Functions має 9-хвилинний timeout, не підходить для 2-хвилинної обробки кожного image
- D: GKE додає overhead і складність для простого batch processing

---

## Question 3: High Availability Database

Your application requires a globally distributed database with 99.999% availability and strong consistency. Which service should you use?

A) Cloud SQL with read replicas  
B) Cloud Spanner  
C) Firestore  
D) Bigtable

**Правильна відповідь:** B

**Пояснення:** Cloud Spanner - єдиний сервіс, що надає 99.999% SLA, global distribution, strong consistency та horizontal scalability. Це relational database з ACID guarantees.

**Чому інші варіанти неправильні:**

- A: Cloud SQL regional service, не globally distributed
- C: Firestore має eventual consistency (за замовчуванням)
- D: Bigtable NoSQL database без strong consistency guarantees

---

## Question 4: Network Isolation

You need to isolate development and production environments in the same project. What's the best approach?

A) Use separate projects  
B) Use separate VPCs with firewall rules  
C) Use separate regions  
D) Use separate zones

**Правильна відповідь:** B

**Пояснення:** Separate VPCs з firewall rules забезпечують network isolation в межах одного project. Це дозволяє контролювати traffic між environments та застосовувати різні security policies.

**Чому інші варіанти неправильні:**

- A: Separate projects додають administrative overhead
- C: Regions не забезпечують network isolation
- D: Zones в одній VPC можуть комунікувати freely

---

## Question 5: Autoscaling Configuration

Your web application experiences traffic spikes during business hours (9 AM - 5 PM). How should you configure autoscaling?

A) Set minimum instances to 10, maximum to 100  
B) Use scheduled scaling to increase instances at 9 AM  
C) Set minimum instances to 1, maximum to 100, target CPU 60%  
D) Disable autoscaling and manually scale

**Правильна відповідь:** C

**Пояснення:** Autoscaling з low minimum (1), high maximum (100) та reasonable CPU target (60%) автоматично адаптується до traffic patterns без manual intervention. Це cost-effective і responsive.

**Чому інші варіанти неправильні:**

- A: Minimum 10 instances марнує ресурси в off-peak hours
- B: Scheduled scaling не адаптується до unexpected traffic changes
- D: Manual scaling не responsive і потребує human intervention

---

## Question 6: Data Retention Policy

You need to store audit logs for 7 years for compliance, but only need frequent access for the first 30 days. What's the most cost-effective solution?

A) Store all logs in Cloud Storage Standard  
B) Use Cloud Storage lifecycle policy to move to Archive after 30 days  
C) Use Cloud Logging with custom retention  
D) Export to BigQuery and delete after 30 days

**Правильна відповідь:** B

**Пояснення:** Cloud Storage lifecycle policy автоматично переміщує objects з Standard (frequent access) до Archive (long-term storage) після 30 днів. Archive storage коштує $0.0012/GB/month vs Standard $0.020/GB/month.

**Чому інші варіанти неправильні:**

- A: Standard storage дорогий для 7-річного зберігання
- C: Cloud Logging має maximum 3650 днів retention
- D: Deleting після 30 днів порушує 7-річну compliance вимогу

---

## Question 7: Load Balancer Selection

Your application serves global users and needs to route traffic to the nearest backend. Which load balancer should you use?

A) Network Load Balancer  
B) Internal Load Balancer  
C) HTTP(S) Load Balancer  
D) TCP Proxy Load Balancer

**Правильна відповідь:** C

**Пояснення:** HTTP(S) Load Balancer - global load balancer з anycast IP, що автоматично routes traffic до nearest healthy backend based on user location. Підтримує SSL termination та content-based routing.

**Чому інші варіанти неправильні:**

- A: Network Load Balancer regional, не global
- B: Internal Load Balancer для internal traffic only
- D: TCP Proxy для non-HTTP traffic

---

## Question 8: Service Account Best Practice

Your application running on Compute Engine needs to access Cloud Storage. What's the best practice?

A) Create service account key and store in VM metadata  
B) Use default Compute Engine service account  
C) Create custom service account with minimal permissions  
D) Use user credentials

**Правильна відповідь:** C

**Пояснення:** Custom service account з principle of least privilege (minimal permissions) - best practice для security. Attach service account до VM, no keys needed (використовує metadata server).

**Чому інші варіанти неправильні:**

- A: Service account keys - security risk, можуть бути leaked
- B: Default service account має Editor role (too broad)
- D: User credentials не підходять для applications

---

## Question 9: Disaster Recovery Strategy

Your application requires RPO of 1 hour and RTO of 4 hours. Which backup strategy should you use?

A) Daily snapshots  
B) Hourly snapshots with automated restore testing  
C) Real-time replication  
D) Weekly snapshots

**Правильна відповідь:** B

**Пояснення:** Hourly snapshots забезпечують RPO 1 hour (maximum data loss). Automated restore testing гарантує RTO 4 hours (recovery time). Це balance між cost та requirements.

**Чому інші варіанти неправильні:**

- A: Daily snapshots не відповідають RPO 1 hour
- C: Real-time replication дорогий і не потрібен для RPO 1 hour
- D: Weekly snapshots не відповідають RPO requirement

---

## Question 10: Container Deployment

You need to deploy a containerized application with zero infrastructure management. Which service should you use?

A) Compute Engine with Docker  
B) GKE Autopilot  
C) Cloud Run  
D) App Engine Flexible

**Правильна відповідь:** C

**Пояснення:** Cloud Run - fully managed serverless platform для containers з zero infrastructure management. Auto-scales to zero, pay per request, підтримує any language/framework.

**Чому інші варіанти неправильні:**

- A: Compute Engine потребує infrastructure management
- B: GKE Autopilot все ще потребує cluster configuration
- D: App Engine Flexible має більше обмежень ніж Cloud Run

---

## Question 11: VPC Peering vs VPN

You need to connect two VPCs in different projects within the same organization. What's the best approach?

A) Cloud VPN  
B) VPC Peering  
C) Shared VPC  
D) Cloud Interconnect

**Правильна відповідь:** B

**Пояснення:** VPC Peering - найпростіший і найшвидший спосіб з'єднати VPCs в межах GCP. Використовує Google's internal network, no encryption overhead, low latency.

**Чому інші варіанти неправильні:**

- A: Cloud VPN додає encryption overhead і latency
- C: Shared VPC для sharing в межах одного project
- D: Cloud Interconnect для on-premises connectivity

---

## Question 12: Monitoring Alert Configuration

Your application's response time should not exceed 500ms. How should you configure alerting?

A) Alert when response time > 500ms for 1 minute  
B) Alert when response time > 500ms for 5 minutes  
C) Alert when average response time > 500ms for 5 minutes  
D) Alert immediately when any request > 500ms

**Правильна відповідь:** C

**Пояснення:** Average response time > 500ms for 5 minutes уникає false positives від occasional spikes та дає час для investigation перед alerting. 5-minute window - good balance.

**Чому інші варіанти неправильні:**

- A: 1 minute too short, може давати false positives
- B: Single request threshold дає багато false positives
- D: Immediate alerts на single requests створюють alert fatigue

---

## Question 13: IAM Role Assignment

A developer needs to deploy applications to App Engine but should not be able to delete them. Which role should you assign?

A) App Engine Admin  
B) App Engine Deployer  
C) App Engine Viewer  
D) Editor

**Правильна відповідь:** B

**Пояснення:** App Engine Deployer role дозволяє deploy applications але не дозволяє delete. Це principle of least privilege.

**Чому інші варіанти неправильні:**

- A: Admin role дозволяє delete
- C: Viewer role не дозволяє deploy
- D: Editor role занадто broad

---

## Question 14: Cloud Storage Signed URLs

You need to allow external users to upload files to Cloud Storage without GCP credentials. What should you use?

A) Make bucket public  
B) Generate signed URLs with PUT method  
C) Use IAM policy  
D) Use ACLs

**Правильна відповідь:** B

**Пояснення:** Signed URLs з PUT method дозволяють temporary upload access без credentials. URL має expiration time і specific permissions.

**Чому інші варіанти неправильні:**

- A: Public bucket - security risk
- C: IAM policy потребує GCP credentials
- D: ACLs не дозволяють temporary access

---

## Question 15: Database Selection for Analytics

You need to store and analyze 10TB of time-series IoT data with sub-second query latency. Which database should you use?

A) Cloud SQL  
B) Cloud Spanner  
C) Bigtable  
D) Firestore

**Правильна відповідь:** C

**Пояснення:** Bigtable - NoSQL database оптимізована для time-series data з high throughput та low latency. Ідеально для IoT workloads з petabyte-scale.

**Чому інші варіанти неправильні:**

- A: Cloud SQL не scale до 10TB efficiently
- B: Spanner дорогий для analytics workloads
- D: Firestore не оптимізована для large-scale analytics

---

## Question 16: Preemptible VM Best Practice

Your batch processing job uses preemptible VMs. How should you handle preemption?

A) Ignore preemption, restart manually  
B) Use startup script to resume from checkpoint  
C) Use only standard VMs  
D) Set --no-restart-on-failure flag

**Правильна відповідь:** B

**Пояснення:** Startup script з checkpoint/resume logic дозволяє automatically continue processing після preemption. Це maximizes cost savings від preemptible VMs.

**Чому інші варіанти неправильні:**

- A: Manual restart не efficient
- C: Standard VMs дорогі
- D: --no-restart-on-failure не вирішує preemption issue

---

## Question 17: Cloud Build Trigger

You need to automatically build and deploy your application when code is pushed to the main branch. What should you use?

A) Manual gcloud builds submit  
B) Cloud Build trigger on push to main branch  
C) Cron job running gcloud builds  
D) Cloud Functions triggered by GitHub webhook

**Правильна відповідь:** B

**Пояснення:** Cloud Build trigger автоматично запускає build при push до specified branch. Native integration з GitHub/GitLab, no custom code needed.

**Чому інші варіанти неправильні:**

- A: Manual builds не automated
- C: Cron job не responsive до code changes
- D: Cloud Functions додає unnecessary complexity

---

## Question 18: Regional vs Zonal Resources

Your application requires 99.95% availability. How should you deploy Compute Engine instances?

A) Single zone with autoscaling  
B) Multiple zones in single region with load balancer  
C) Single region with manual failover  
D) Multiple regions with global load balancer

**Правильна відповідь:** B

**Пояснення:** Multiple zones з load balancer забезпечує 99.95% availability (regional MIG SLA). Це cost-effective рішення для high availability.

**Чому інші варіанти неправильні:**

- A: Single zone має lower SLA
- C: Manual failover не відповідає availability requirement
- D: Multiple regions дорогі і не потрібні для 99.95%

---

## Question 19: Cloud SQL High Availability

Your Cloud SQL database requires automatic failover. What should you configure?

A) Read replicas  
B) High availability (HA) configuration  
C) Automated backups  
D) Point-in-time recovery

**Правильна відповідь:** B

**Пояснення:** HA configuration створює standby replica в іншій zone з automatic failover. Забезпечує 99.95% SLA.

**Чому інші варіанти неправильні:**

- A: Read replicas для read scaling, не для HA
- C: Backups для disaster recovery, не для automatic failover
- D: PITR для data recovery, не для HA

---

## Question 20: Custom VPC Network

You need to create a VPC with specific IP ranges for different subnets. What mode should you use?

A) Auto mode VPC  
B) Custom mode VPC  
C) Default VPC  
D) Legacy network

**Правильна відповідь:** B

**Пояснення:** Custom mode VPC дозволяє specify custom IP ranges для кожного subnet. Це необхідно для specific networking requirements.

**Чому інші варіанти неправильні:**

- A: Auto mode automatically creates subnets з predefined ranges
- C: Default VPC - auto mode VPC
- D: Legacy networks deprecated

---

## Question 21: Cloud Functions Trigger

You need to process files immediately after they are uploaded to Cloud Storage. What should you use?

A) Cron job checking bucket every minute  
B) Cloud Functions with Cloud Storage trigger  
C) Pub/Sub with manual polling  
D) Cloud Run with HTTP endpoint

**Правильна відповідь:** B

**Пояснення:** Cloud Functions з Cloud Storage trigger автоматично executes при upload events. Event-driven, no polling needed, cost-effective.

**Чому інші варіанти неправильні:**

- A: Cron job має delay і не efficient
- C: Manual polling не event-driven
- D: Cloud Run потребує HTTP request, не event-driven

---

## Question 22: Deployment Manager vs Terraform

Your organization uses multiple cloud providers. Which IaC tool should you use?

A) Deployment Manager  
B) Terraform  
C) Cloud Build  
D) gcloud commands

**Правильна відповідь:** B

**Пояснення:** Terraform - multi-cloud IaC tool з support для GCP, AWS, Azure. Deployment Manager тільки для GCP.

**Чому інші варіанти неправильні:**

- A: Deployment Manager GCP-only
- C: Cloud Build для CI/CD, не для IaC
- D: gcloud commands не declarative IaC

---

## Question 23: Log Retention

You need to retain audit logs for 10 years for compliance. What should you do?

A) Use Cloud Logging default retention  
B) Create log sink to Cloud Storage Archive  
C) Export to BigQuery  
D) Use Cloud Logging custom retention

**Правильна відповідь:** B

**Пояснення:** Log sink до Cloud Storage Archive - найдешевший спосіб для long-term retention. Archive storage $0.0012/GB/month. Cloud Logging має maximum 3650 днів retention.

**Чому інші варіанти неправильні:**

- A: Default retention maximum 30 днів
- C: BigQuery дорогий для 10-річного storage
- D: Custom retention maximum 3650 днів (10 років)

---

## Question 24: GKE Cluster Upgrade

You need to upgrade your GKE cluster with zero downtime. What should you do?

A) Delete cluster and create new one  
B) Use rolling upgrade with surge upgrades  
C) Upgrade all nodes simultaneously  
D) Manually upgrade each node

**Правильна відповідь:** B

**Пояснення:** Rolling upgrade з surge upgrades створює new nodes перед deleting old ones, забезпечуючи zero downtime. GKE automatically drains workloads.

**Чому інші варіанти неправильні:**

- A: Deleting cluster має downtime
- C: Simultaneous upgrade має downtime
- D: Manual upgrade error-prone і має downtime

---

## Question 25: Cloud Armor

Your web application is experiencing DDoS attack. What should you use?

A) Firewall rules  
B) Cloud Armor with rate limiting  
C) VPC Service Controls  
D) Identity-Aware Proxy

**Правильна відповідь:** B

**Пояснення:** Cloud Armor - DDoS protection service з rate limiting, IP blacklisting/whitelisting, та geo-based access control. Works з HTTP(S) Load Balancer.

**Чому інші варіанти неправильні:**

- A: Firewall rules не effective проти DDoS
- C: VPC Service Controls для data exfiltration protection
- D: IAP для identity-based access control

---

**Повернутися до:** [Модуль 13 - Practice Questions](README.md)
