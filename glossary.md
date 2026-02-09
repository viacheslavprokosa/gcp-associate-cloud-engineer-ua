# Глосарій термінів GCP

Цей глосарій містить ключові терміни Google Cloud Platform, які важливі для іспиту Associate Cloud Engineer.

---

## A

**ACL (Access Control List)** / Список контролю доступу  
Механізм для визначення прав доступу до ресурсів Cloud Storage на рівні об'єктів. → [IAM & Security](10-iam-security/README.md)

**App Engine** / Апп Енджин  
Повністю керована PaaS платформа для розгортання веб-додатків без управління інфраструктурою. → [App Engine](05-app-engine/README.md)

**Autoscaling** / Автомасштабування  
Автоматичне збільшення або зменшення кількості ресурсів на основі навантаження. → [Compute Engine](03-compute-engine/README.md)

**Availability Zone** / Зона доступності  
Ізольований датацентр в межах регіону GCP. → [Cloud Fundamentals](01-cloud-fundamentals/README.md)

---

## B

**Bigtable** / Байгтейбл  
NoSQL база даних типу wide-column для великих обсягів даних (IoT, аналітика, time-series). → [Databases](08-databases/README.md)

**Bucket** / Бакет  
Контейнер для зберігання об'єктів у Cloud Storage. → [Storage](07-storage/README.md)

---

## C

**Cloud Build** / Клауд Білд  
Сервіс для CI/CD, автоматизації збірки та розгортання додатків. → [Deployment & Management](12-deployment-management/README.md)

**Cloud CDN** / Клауд CDN  
Content Delivery Network для прискорення доставки контенту користувачам. → [Networking](09-networking/README.md)

**Cloud DNS** / Клауд DNS  
Керований сервіс DNS для публікації доменних імен. → [Networking](09-networking/README.md)

**Cloud Functions** / Клауд Функшнс  
Serverless платформа для запуску коду у відповідь на події без управління серверами. → [Cloud Functions](06-cloud-functions/README.md)

**Cloud Interconnect** / Клауд Інтерконнект  
Виділене з'єднання між вашою мережею та GCP (Dedicated або Partner Interconnect). → [Networking](09-networking/README.md)

**Cloud Logging** / Клауд Логінг  
Централізований сервіс для збору, зберігання та аналізу логів. → [Monitoring & Logging](11-monitoring-logging/README.md)

**Cloud Monitoring** / Клауд Моніторинг  
Сервіс для моніторингу метрик, створення дашбордів та алертів. → [Monitoring & Logging](11-monitoring-logging/README.md)

**Cloud Run** / Клауд Ран  
Serverless платформа для запуску контейнерів без управління інфраструктурою. → [GCP Core Services](02-gcp-core-services/README.md)

**Cloud SDK** / Клауд SDK  
Набір інструментів командного рядка (gcloud, gsutil, bq) для роботи з GCP. → [Deployment & Management](12-deployment-management/README.md)

**Cloud Shell** / Клауд Шелл  
Браузерний термінал з попередньо встановленим Cloud SDK. → [Deployment & Management](12-deployment-management/README.md)

**Cloud Spanner** / Клауд Спаннер  
Глобально розподілена реляційна база даних з сильною консистентністю. → [Databases](08-databases/README.md)

**Cloud SQL** / Клауд SQL  
Керований сервіс реляційних баз даних (MySQL, PostgreSQL, SQL Server). → [Databases](08-databases/README.md)

**Cloud Storage** / Клауд Стораж  
Об'єктне сховище для зберігання неструктурованих даних. → [Storage](07-storage/README.md)

**Cloud VPN** / Клауд VPN  
Безпечне з'єднання між вашою мережею та VPC через IPsec VPN. → [Networking](09-networking/README.md)

**Compute Engine** / Ком'ют Енджин  
IaaS сервіс для створення та управління віртуальними машинами. → [Compute Engine](03-compute-engine/README.md)

**Custom Role** / Кастомна роль  
Роль IAM зі спеціально визначеним набором прав доступу. → [IAM & Security](10-iam-security/README.md)

---

## D

**Deployment Manager** / Деплоймент Менеджер  
Infrastructure as Code сервіс для автоматизації створення ресурсів GCP. → [Deployment & Management](12-deployment-management/README.md)

---

## F

**Filestore** / Файлстор  
Керований NFS файловий сервіс для VM та GKE. → [Storage](07-storage/README.md)

**Firestore** / Файрстор  
NoSQL документна база даних для веб та мобільних додатків. → [Databases](08-databases/README.md)

**Firewall Rules** / Правила фаєрволу  
Правила для контролю вхідного та вихідного трафіку у VPC. → [Networking](09-networking/README.md)

---

## G

**gcloud** / джіклауд  
Інструмент командного рядка для управління ресурсами GCP. → [Deployment & Management](12-deployment-management/README.md)

**GKE (Google Kubernetes Engine)** / ДжіКейІ  
Керований сервіс Kubernetes для оркестрації контейнерів. → [Kubernetes Engine](04-kubernetes-engine/README.md)

**gsutil** / джіесютіл  
Інструмент командного рядка для роботи з Cloud Storage. → [Deployment & Management](12-deployment-management/README.md)

---

## H

**Health Check** / Хелс Чек  
Перевірка стану екземплярів для балансувальників навантаження та instance groups. → [Compute Engine](03-compute-engine/README.md)

**Horizontal Pod Autoscaler (HPA)** / Горизонтальний автоскейлер подів  
Автоматичне масштабування кількості подів у GKE на основі метрик. → [Kubernetes Engine](04-kubernetes-engine/README.md)

---

## I

**IaaS (Infrastructure as a Service)** / Інфраструктура як сервіс  
Модель хмарних обчислень, де провайдер надає віртуалізовану інфраструктуру. → [Cloud Fundamentals](01-cloud-fundamentals/README.md)

**IAM (Identity and Access Management)** / Управління ідентифікацією та доступом  
Система для контролю доступу до ресурсів GCP. → [IAM & Security](10-iam-security/README.md)

**Image** / Імідж  
Шаблон для створення VM екземплярів з попередньо налаштованою ОС та ПЗ. → [Compute Engine](03-compute-engine/README.md)

**Instance Group** / Група екземплярів  
Колекція VM екземплярів, якими можна управляти як єдиним цілим. → [Compute Engine](03-compute-engine/README.md)

---

## K

**kubectl** / кубконтрол  
Інструмент командного рядка для управління Kubernetes кластерами. → [Kubernetes Engine](04-kubernetes-engine/README.md)

---

## L

**Load Balancer** / Балансувальник навантаження  
Розподіляє трафік між кількома екземплярами для забезпечення високої доступності. → [Networking](09-networking/README.md)

**Local SSD** / Локальний SSD  
Високопродуктивне локальне сховище, прикріплене до VM (дані не зберігаються після видалення VM). → [Compute Engine](03-compute-engine/README.md)

---

## M

**Machine Type** / Тип машини  
Конфігурація VM (кількість vCPU, пам'ять). Може бути predefined або custom. → [Compute Engine](03-compute-engine/README.md)

**Managed Instance Group (MIG)** / Керована група екземплярів  
Група ідентичних VM з автоматичним масштабуванням та самовідновленням. → [Compute Engine](03-compute-engine/README.md)

**Memorystore** / Меморістор  
Керований сервіс Redis та Memcached для кешування. → [Databases](08-databases/README.md)

---

## N

**Node Pool** / Пул нодів  
Група нодів (VM) у GKE кластері з однаковою конфігурацією. → [Kubernetes Engine](04-kubernetes-engine/README.md)

---

## P

**PaaS (Platform as a Service)** / Платформа як сервіс  
Модель хмарних обчислень для розробки додатків без управління інфраструктурою. → [Cloud Fundamentals](01-cloud-fundamentals/README.md)

**Persistent Disk** / Персистентний диск  
Блокове сховище для VM, яке зберігає дані незалежно від життєвого циклу VM. → [Storage](07-storage/README.md)

**Preemptible VM** / Пріємптібл VM  
Дешевий короткостроковий VM екземпляр (може бути зупинений GCP у будь-який момент). → [Compute Engine](03-compute-engine/README.md)

**Primitive Role** / Примітивна роль  
Базові ролі IAM: Owner, Editor, Viewer (не рекомендуються для production). → [IAM & Security](10-iam-security/README.md)

**Project** / Проект  
Базова організаційна одиниця в GCP для групування ресурсів. → [Cloud Fundamentals](01-cloud-fundamentals/README.md)

---

## R

**Region** / Регіон  
Географічна локація з кількома зонами доступності. → [Cloud Fundamentals](01-cloud-fundamentals/README.md)

**Resource Hierarchy** / Ієрархія ресурсів  
Організаційна структура: Organization → Folder → Project → Resources. → [IAM & Security](10-iam-security/README.md)

---

## S

**SaaS (Software as a Service)** / Програмне забезпечення як сервіс  
Модель хмарних обчислень, де користувачі отримують доступ до готового ПЗ. → [Cloud Fundamentals](01-cloud-fundamentals/README.md)

**Service Account** / Сервісний акаунт  
Спеціальний тип облікового запису для додатків та сервісів (не для людей). → [IAM & Security](10-iam-security/README.md)

**Shared VPC** / Спільний VPC  
VPC, яким можуть користуватися кілька проектів в організації. → [Networking](09-networking/README.md)

**Snapshot** / Снепшот  
Резервна копія Persistent Disk для відновлення даних. → [Storage](07-storage/README.md)

**Spot VM** / Спот VM  
Новіша версія Preemptible VM з додатковими можливостями. → [Compute Engine](03-compute-engine/README.md)

**Storage Class** / Клас сховища  
Тип Cloud Storage: Standard, Nearline, Coldline, Archive (відрізняються ціною та доступністю). → [Storage](07-storage/README.md)

**Subnet** / Підмережа  
Діапазон IP адрес у VPC в конкретному регіоні. → [Networking](09-networking/README.md)

---

## V

**VPC (Virtual Private Cloud)** / Віртуальна приватна хмара  
Ізольована віртуальна мережа в GCP. → [Networking](09-networking/README.md)

**VPC Peering** / Пірінг VPC  
З'єднання двох VPC мереж для обміну трафіком. → [Networking](09-networking/README.md)

---

## Z

**Zone** / Зона  
Ізольований датацентр в межах регіону (наприклад, us-central1-a). → [Cloud Fundamentals](01-cloud-fundamentals/README.md)

---

**Останнє оновлення:** 2026-02-09
