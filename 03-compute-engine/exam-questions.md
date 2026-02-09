# Exam Questions - Compute Engine

## Question 1

You need to run a batch processing job that can tolerate interruptions and should complete within 12 hours. Cost optimization is the primary concern. Which VM option should you use?

A) Standard VM with committed use discount  
B) Preemptible VM  
C) Spot VM  
D) Shared-core VM

**Правильна відповідь:** B

**Пояснення:** Preemptible VM надає знижку 60-91% та гарантує роботу до 24 годин, що підходить для 12-годинного batch job. Оскільки job може толерувати переривання, preemptible VM є найбільш cost-effective рішенням.

**Чому інші варіанти неправильні:**

- A: Committed use discount вимагає 1-3 роки commitment, надмірний для batch job
- C: Spot VM також підходить, але preemptible VM гарантує 24 години роботи
- D: Shared-core VM має низьку продуктивність, не підходить для batch processing

---

## Question 2

Your application requires 8 vCPUs and 24 GB of memory. No predefined machine type matches these requirements. What should you do?

A) Use n2-standard-8 (8 vCPUs, 32 GB)  
B) Create a custom machine type with 8 vCPUs and 24 GB  
C) Use two n2-standard-4 instances  
D) Use e2-standard-8 (8 vCPUs, 32 GB)

**Правильна відповідь:** B

**Пояснення:** Custom machine types дозволяють створити VM з точною кількістю vCPU та memory, що оптимізує вартість. 8 vCPUs з 24 GB (3 GB/vCPU) відповідає допустимому діапазону 0.9-6.5 GB/vCPU.

**Чому інші варіанти неправильні:**

- A: Переплата за 8 GB непотрібної memory
- C: Складніше управління, потенційно дорожче
- D: Також переплата за непотрібну memory

---

## Question 3

You need to create a backup of a 500 GB persistent disk attached to a running VM. The backup should be stored in a different region for disaster recovery. What should you do?

A) Stop the VM, detach the disk, create an image  
B) Create a snapshot of the disk while the VM is running  
C) Use gsutil to copy disk data to Cloud Storage  
D) Create a machine image of the entire VM

**Правильна відповідь:** B

**Пояснення:** Snapshots можна створювати з running VM без downtime. Snapshots є глобальними ресурсами та автоматично зберігаються в кількох локаціях. Це найпростіший та найефективніший спосіб backup.

**Чому інші варіанти неправильні:**

- A: Непотрібний downtime, snapshots можна створювати без зупинки VM
- C: Складний процес, snapshots автоматично обробляють це
- D: Machine image включає всю конфігурацію VM, надмірний для простого backup диску

---

## Question 4

Your managed instance group needs to scale between 2 and 10 instances based on CPU utilization. You want to ensure smooth scaling without rapid fluctuations. What should you configure?

A) Set target CPU utilization to 90% with no cool-down period  
B) Set target CPU utilization to 60% with a 90-second cool-down period  
C) Use only min and max replicas without autoscaling  
D) Set target CPU utilization to 30% with a 300-second cool-down period

**Правильна відповідь:** B

**Пояснення:** Target CPU 60% забезпечує баланс між performance та cost, залишаючи запас для traffic spikes. Cool-down period 90 секунд запобігає rapid scaling fluctuations, даючи час для стабілізації метрик.

**Чому інші варіанти неправильні:**

- A: 90% CPU занадто високий, може призвести до performance issues; без cool-down може бути нестабільне scaling
- C: Без autoscaling не буде автоматичного реагування на навантаження
- D: 30% CPU занадто низький, призведе до overprovisioning та зайвих витрат

---

## Question 5

You need to update the application version on all instances in a managed instance group with zero downtime. What should you do?

A) Delete the MIG and create a new one with the new template  
B) Perform a rolling update with max-surge=3 and max-unavailable=0  
C) Manually update each instance one by one  
D) Stop all instances, update, and restart

**Правильна відповідь:** B

**Пояснення:** Rolling update з max-surge=3 створює 3 додаткові instances з новим template, а max-unavailable=0 гарантує, що жоден existing instance не буде недоступний під час update, забезпечуючи zero downtime.

**Чому інші варіанти неправильні:**

- A: Призведе до downtime при видаленні MIG
- C: Неефективно та схильне до помилок, MIG не буде автоматично управляти процесом
- D: Очевидний downtime при зупинці всіх instances

---

## Question 6

Your application requires the highest disk performance for a database workload with millions of IOPS. Which disk type should you use?

A) Standard Persistent Disk  
B) Balanced Persistent Disk  
C) SSD Persistent Disk  
D) Extreme Persistent Disk

**Правильна відповідь:** D

**Пояснення:** Extreme Persistent Disk надає найвищу продуктивність з до 120 IOPS per GB, що ідеально підходить для database workloads з мільйонами IOPS. Це єдиний тип диску, який може задовольнити такі вимоги.

**Чому інші варіанти неправильні:**

- A: Standard PD (HDD) - найнижча продуктивність, не підходить для high IOPS
- B: Balanced PD - 6 IOPS/GB, недостатньо для мільйонів IOPS
- C: SSD PD - 30 IOPS/GB, краще але все ще недостатньо для extreme workloads

---

## Question 7

You need to ensure that unhealthy instances in your managed instance group are automatically replaced. What should you configure?

A) Autoscaling policy  
B) Health check with autohealing  
C) Load balancer  
D) Instance template

**Правильна відповідь:** B

**Пояснення:** Health check з autohealing автоматично виявляє unhealthy instances (на основі health check failures) та recreates їх. Це забезпечує автоматичне відновлення без ручного втручання.

**Чому інші варіанти неправильні:**

- A: Autoscaling масштабує на основі метрик, але не замінює unhealthy instances
- C: Load balancer використовує health checks для routing, але не recreates instances
- D: Instance template - шаблон для створення instances, не механізм healing

---

## Question 8

Your startup script fails during VM creation, and the instance is in a RUNNING state but not functioning correctly. What is the best way to debug this?

A) Delete and recreate the VM  
B) Check Cloud Logging for startup script output  
C) SSH to the VM and manually run the script  
D) Create a new instance template

**Правильна відповідь:** B

**Пояснення:** Cloud Logging автоматично збирає output startup scripts. Це найшвидший спосіб побачити помилки та debug проблеми зі startup script без необхідності SSH або recreation VM.

**Чому інші варіанти неправильні:**

- A: Неефективно, не допоможе зрозуміти причину проблеми
- C: Можливо, але Cloud Logging надає історію та більш зручний для debugging
- D: Не вирішить проблему, якщо не знаєте причину failure

---

## Question 9

You need to create 100 identical web server instances across three zones in us-central1 region. What is the most efficient approach?

A) Create 100 individual instances manually  
B) Create a regional managed instance group with size=100  
C) Create three zonal managed instance groups with size=33 each  
D) Use a script to create instances in each zone

**Правильна відповідь:** B

**Пояснення:** Regional MIG автоматично розподіляє instances між зонами в регіоні, забезпечуючи високу доступність та автоматичне балансування. Це найпростіший та найефективніший спосіб управління великою кількістю instances.

**Чому інші варіанти неправильні:**

- A: Неефективно, складно управляти, немає autoscaling/autohealing
- C: Складніше управління трьома окремими MIGs, regional MIG робить це автоматично
- D: Ручний підхід, схильний до помилок, немає переваг MIG

---

## Question 10

You need to temporarily store 2 TB of data for high-performance computing that will be deleted after the job completes. Which storage option is most cost-effective?

A) Standard Persistent Disk  
B) SSD Persistent Disk  
C) Local SSD  
D) Cloud Storage

**Правильна відповідь:** C

**Пояснення:** Local SSD надає найвищу продуктивність за найнижчою ціною для temporary data. Оскільки дані будуть видалені після job, ephemeral nature Local SSD ідеально підходить, і ви платите тільки за час використання VM.

**Чому інші варіанти неправильні:**

- A: Дорожче за Local SSD для temporary storage, lower performance
- B: Найдорожчий варіант для temporary data
- D: Cloud Storage має вищу latency, не оптимізований для HPC workloads

---

**Повернутися до:** [Модуль 03 - Compute Engine](README.md)
