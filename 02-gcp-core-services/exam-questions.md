# Exam Questions - GCP Core Services

## Question 1

Your company needs to run a containerized application that requires orchestration with auto-scaling, load balancing, and rolling updates. The team has Kubernetes expertise. Which compute service should you use?

A) Compute Engine with Docker  
B) Google Kubernetes Engine (GKE)  
C) App Engine Flexible  
D) Cloud Run

**Правильна відповідь:** B

**Пояснення:** Google Kubernetes Engine (GKE) є керованим Kubernetes сервісом, який надає всі необхідні можливості: оркестрацію контейнерів, автоматичне масштабування, load balancing та rolling updates. Оскільки команда має досвід з Kubernetes, GKE є найкращим вибором.

**Чому інші варіанти неправильні:**

- A: Compute Engine з Docker потребує ручного управління оркестрацією, що складніше та менш ефективно
- C: App Engine Flexible підтримує контейнери, але не надає повноцінної Kubernetes оркестрації
- D: Cloud Run підходить для простих контейнерів, але не надає повної Kubernetes функціональності

---

## Question 2

You need to store 500 TB of video files that are accessed less than once per year for compliance purposes. Cost optimization is the primary concern. Which storage class should you use?

A) Cloud Storage Standard  
B) Cloud Storage Nearline  
C) Cloud Storage Coldline  
D) Cloud Storage Archive

**Правильна відповідь:** D

**Пояснення:** Cloud Storage Archive клас призначений саме для даних, до яких звертаються рідше ніж раз на рік. Це найдешевший storage class, що ідеально підходить для compliance архівування з мінімальним доступом.

**Чому інші варіанти неправильні:**

- A: Standard - найдорожчий клас, призначений для часто використовуваних даних
- B: Nearline - для даних з доступом менше 1 разу на місяць, дорожчий за Archive
- C: Coldline - для даних з доступом менше 1 разу на квартал, дорожчий за Archive

---

## Question 3

Your application requires a relational database with strong consistency across multiple regions worldwide and the ability to scale to handle petabytes of data. Which database service should you choose?

A) Cloud SQL with read replicas  
B) Cloud Spanner  
C) Firestore  
D) Bigtable

**Правильна відповідь:** B

**Пояснення:** Cloud Spanner - єдина реляційна база даних в GCP, яка надає глобальну реплікацію з сильною консистентністю та може масштабуватися до петабайтів даних. Це ідеальний вибір для глобальних додатків з великими обсягами даних.

**Чому інші варіанти неправильні:**

- A: Cloud SQL обмежений регіональним масштабом та не може масштабуватися до петабайтів
- C: Firestore - NoSQL документна база даних, не реляційна
- D: Bigtable - NoSQL wide-column база даних, не реляційна

---

## Question 4

You need to distribute HTTP(S) traffic globally across multiple regions with SSL termination and URL-based routing. Which load balancer should you use?

A) Network Load Balancer  
B) Internal Load Balancer  
C) HTTP(S) Load Balancer  
D) TCP Proxy Load Balancer

**Правильна відповідь:** C

**Пояснення:** HTTP(S) Load Balancer - це глобальний Layer 7 load balancer, який підтримує SSL termination, URL-based routing та розподіл трафіку між регіонами. Це єдиний load balancer, який надає всі необхідні можливості.

**Чому інші варіанти неправильні:**

- A: Network Load Balancer - регіональний Layer 4 балансувальник, не підтримує URL-based routing
- B: Internal Load Balancer - для внутрішнього трафіку в VPC, не глобальний
- D: TCP Proxy Load Balancer - Layer 4, не підтримує URL-based routing

---

## Question 5

Your startup needs to deploy a web application quickly without managing infrastructure. The application is written in Python and needs to scale automatically based on traffic. Which service is the best fit?

A) Compute Engine  
B) Google Kubernetes Engine  
C) App Engine Standard  
D) Cloud Functions

**Правильна відповідь:** C

**Пояснення:** App Engine Standard ідеально підходить для швидкого розгортання веб-додатків без управління інфраструктурою. Він підтримує Python, автоматично масштабується (включаючи до 0 екземплярів) та має безкоштовний tier для стартапів.

**Чому інші варіанти неправильні:**

- A: Compute Engine потребує управління VM, що не відповідає вимозі "без управління інфраструктурою"
- B: GKE потребує знань Kubernetes та більше налаштувань, що уповільнює deployment
- D: Cloud Functions призначений для event-driven функцій, а не для повноцінних веб-додатків

---

## Question 6

You need to connect your on-premises data center to GCP with a bandwidth of 50 Gbps and the lowest possible latency. Your company has a presence in a colocation facility that supports GCP. Which connectivity option should you use?

A) Cloud VPN  
B) Partner Interconnect  
C) Dedicated Interconnect  
D) VPC Peering

**Правильна відповідь:** C

**Пояснення:** Dedicated Interconnect надає пряме фізичне з'єднання з найнижчою latency та підтримує bandwidth до 100 Gbps. Оскільки компанія має присутність в colocation facility, Dedicated Interconnect є найкращим вибором.

**Чому інші варіанти неправильні:**

- A: Cloud VPN обмежений ~3 Gbps на тунель, недостатньо для 50 Gbps
- B: Partner Interconnect підходить, але Dedicated Interconnect надає нижчу latency при наявності colocation
- D: VPC Peering - для з'єднання VPC мереж в GCP, не для on-premises

---

## Question 7

Your application needs to cache session data with sub-millisecond latency and support for complex data structures like lists and sets. Which service should you use?

A) Cloud SQL  
B) Memorystore for Redis  
C) Memorystore for Memcached  
D) Firestore

**Правильна відповідь:** B

**Пояснення:** Memorystore for Redis надає sub-millisecond latency та підтримує складні структури даних (lists, sets, sorted sets), що ідеально підходить для кешування session даних з додатковою функціональністю.

**Чому інші варіанти неправильні:**

- A: Cloud SQL - реляційна база даних з вищою latency, не оптимізована для кешування
- C: Memcached підтримує тільки прості key-value пари, не складні структури даних
- D: Firestore - документна база даних, не оптимізована для sub-millisecond latency кешування

---

## Question 8

You need to store time-series IoT sensor data from millions of devices with high write throughput (millions of writes per second) and efficient time-range queries. Which database should you use?

A) Cloud SQL  
B) Cloud Spanner  
C) Firestore  
D) Bigtable

**Правильна відповідь:** D

**Пояснення:** Bigtable спеціально розроблений для time-series даних з високою throughput (мільйони операцій на секунду). Його wide-column модель ідеально підходить для IoT сенсорів з ефективними time-range запитами.

**Чому інші варіанти неправильні:**

- A: Cloud SQL не може обробляти мільйони writes/sec та не оптимізований для time-series
- B: Cloud Spanner дорожчий та надмірний для цього use case
- C: Firestore не оптимізований для такої високої write throughput та time-series даних

---

## Question 9

Your company wants to share a VPC network between multiple projects while maintaining centralized network administration. Which feature should you use?

A) VPC Peering  
B) Shared VPC  
C) Cloud VPN  
D) Cloud Interconnect

**Правильна відповідь:** B

**Пояснення:** Shared VPC дозволяє одному host project володіти VPC мережею, яку можуть використовувати кілька service projects. Це забезпечує централізоване управління мережею при розподіленому управлінні ресурсами.

**Чому інші варіанти неправильні:**

- A: VPC Peering з'єднує дві окремі VPC, але не надає централізованого управління
- C: Cloud VPN - для з'єднання on-premises з GCP, не для sharing VPC між проектами
- D: Cloud Interconnect - також для on-premises connectivity

---

## Question 10

You need to run a short-lived batch processing job that processes files uploaded to Cloud Storage. The job should start automatically when a file is uploaded. Which compute service is most cost-effective?

A) Compute Engine with a cron job  
B) GKE with a CronJob  
C) App Engine  
D) Cloud Functions

**Правильна відповідь:** D

**Пояснення:** Cloud Functions ідеально підходить для event-driven обробки файлів. Функція автоматично запускається при upload файлу в Cloud Storage, ви платите тільки за час виконання, і немає постійно працюючих ресурсів.

**Чому інші варіанти неправильні:**

- A: Compute Engine потребує постійно працюючу VM для моніторингу, що дорожче
- B: GKE надмірний для простої обробки файлів та потребує постійно працюючі ноди
- C: App Engine не має нативної інтеграції з Cloud Storage triggers для автоматичного запуску

---

**Повернутися до:** [Модуль 02 - Основні сервіси GCP](README.md)
