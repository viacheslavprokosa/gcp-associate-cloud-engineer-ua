# Networking Services

## Огляд

GCP надає повний набір мережевих сервісів для з'єднання, захисту та масштабування ваших додатків.

---

## VPC (Virtual Private Cloud)

**Опис:** Глобальна віртуальна приватна мережа в GCP.

### Ключові характеристики

- **Глобальний ресурс**: Одна VPC охоплює всі регіони
- **Subnets**: Регіональні ресурси з IP ranges
- **Firewall Rules**: Контроль трафіку
- **Routes**: Визначення шляхів трафіку
- **VPC Peering**: З'єднання VPC мереж

### Типи VPC

- **Auto mode**: Автоматично створює subnet в кожному регіоні
- **Custom mode**: Повний контроль над subnets

### Firewall Rules

- Stateful (автоматично дозволяє return traffic)
- Пріоритет (0-65535, менше = вищий пріоритет)
- Ingress (вхідний) та Egress (вихідний) трафік
- Targets: tags, service accounts, IP ranges

### Коли використовувати

- ✅ Ізоляція ресурсів
- ✅ Контроль мережевого трафіку
- ✅ Приватне з'єднання між ресурсами
- ✅ Hybrid cloud архітектура

### Приклади команд

```bash
# Створити VPC
gcloud compute networks create my-vpc \
  --subnet-mode=custom

# Створити subnet
gcloud compute networks subnets create my-subnet \
  --network=my-vpc \
  --region=us-central1 \
  --range=10.0.1.0/24

# Створити firewall rule
gcloud compute firewall-rules create allow-ssh \
  --network=my-vpc \
  --allow=tcp:22 \
  --source-ranges=0.0.0.0/0

# VPC Peering
gcloud compute networks peerings create peer-1-to-2 \
  --network=vpc-1 \
  --peer-network=vpc-2
```

---

## Cloud Load Balancing

**Опис:** Розподіл трафіку між екземплярами для високої доступності та масштабування.

### Типи Load Balancers

#### Global Load Balancers

**HTTP(S) Load Balancer**

- Layer 7 (application layer)
- Глобальний anycast IP
- SSL termination
- URL-based routing
- CDN integration

**SSL Proxy Load Balancer**

- Layer 4 (TCP with SSL)
- Глобальний anycast IP
- SSL offloading
- Non-HTTP(S) SSL traffic

**TCP Proxy Load Balancer**

- Layer 4 (TCP without SSL)
- Глобальний anycast IP
- TCP traffic

#### Regional Load Balancers

**Network Load Balancer**

- Layer 4 (TCP/UDP)
- Регіональний
- Pass-through (не terminating)
- Найвища продуктивність

**Internal Load Balancer**

- Layer 4 (TCP/UDP)
- Приватний IP
- Внутрішній трафік в VPC
- Regional або global

### Вибір Load Balancer

| Трафік | Scope | Тип |
|--------|-------|-----|
| HTTP(S) | Global | HTTP(S) LB |
| SSL (non-HTTP) | Global | SSL Proxy LB |
| TCP (non-SSL) | Global | TCP Proxy LB |
| TCP/UDP | Regional, external | Network LB |
| TCP/UDP | Internal | Internal LB |

### Приклад команди

```bash
# Створити backend service
gcloud compute backend-services create my-backend \
  --protocol=HTTP \
  --health-checks=my-health-check \
  --global

# Створити URL map
gcloud compute url-maps create my-url-map \
  --default-service=my-backend

# Створити HTTP proxy
gcloud compute target-http-proxies create my-http-proxy \
  --url-map=my-url-map

# Створити forwarding rule
gcloud compute forwarding-rules create my-http-rule \
  --global \
  --target-http-proxy=my-http-proxy \
  --ports=80
```

---

## Cloud CDN

**Опис:** Content Delivery Network для прискорення доставки контенту.

### Ключові характеристики

- Кешування контенту в edge locations
- Інтеграція з HTTP(S) Load Balancer
- Cache invalidation
- Signed URLs для приватного контенту

### Коли використовувати

- ✅ Статичний контент (зображення, відео, CSS, JS)
- ✅ Глобальна аудиторія
- ✅ Зменшення latency
- ✅ Зменшення навантаження на origin

### Приклад команди

```bash
# Увімкнути Cloud CDN для backend service
gcloud compute backend-services update my-backend \
  --enable-cdn \
  --global
```

---

## Cloud DNS

**Опис:** Керований DNS сервіс для публікації доменних імен.

### Ключові характеристики

- Високодоступний (100% SLA)
- Низька latency
- Підтримка DNSSEC
- Private DNS zones для internal names

### Типи зон

- **Public zones**: Публічні DNS записи
- **Private zones**: Приватні DNS для VPC

### Приклади команд

```bash
# Створити DNS zone
gcloud dns managed-zones create my-zone \
  --dns-name=example.com \
  --description="My DNS zone"

# Додати A record
gcloud dns record-sets create www.example.com \
  --zone=my-zone \
  --type=A \
  --ttl=300 \
  --rrdatas=1.2.3.4
```

---

## Cloud VPN

**Опис:** Безпечне з'єднання між on-premises мережею та VPC через IPsec VPN.

### Типи VPN

#### Classic VPN

- 99.9% SLA
- Один тунель
- Static або dynamic routing (BGP)

#### HA VPN

- 99.99% SLA
- Два тунелі для redundancy
- Тільки dynamic routing (BGP)
- Рекомендується для production

### Коли використовувати

- ✅ Hybrid cloud connectivity
- ✅ Бюджетне рішення (vs Interconnect)
- ✅ Bandwidth < 10 Gbps
- ✅ Можна толерувати Internet latency

### Приклад команди

```bash
# Створити VPN gateway
gcloud compute vpn-gateways create my-vpn-gateway \
  --network=my-vpc \
  --region=us-central1

# Створити VPN tunnel
gcloud compute vpn-tunnels create my-tunnel \
  --peer-address=203.0.113.1 \
  --shared-secret=SECRET \
  --ike-version=2 \
  --vpn-gateway=my-vpn-gateway \
  --region=us-central1
```

---

## Cloud Interconnect

**Опис:** Виділене приватне з'єднання між on-premises та GCP.

### Типи

#### Dedicated Interconnect

- Пряме фізичне з'єднання (10 Gbps або 100 Gbps)
- Найнижча latency
- Найвища bandwidth
- Потребує фізичну присутність в colocation facility

#### Partner Interconnect

- З'єднання через service provider
- Гнучкі bandwidth опції (50 Mbps - 50 Gbps)
- Не потребує colocation

### Cloud VPN vs Interconnect

| Характеристика | Cloud VPN | Dedicated Interconnect | Partner Interconnect |
|----------------|-----------|------------------------|----------------------|
| **Bandwidth** | До 3 Gbps/tunnel | 10/100 Gbps | 50 Mbps - 50 Gbps |
| **Latency** | Internet | Lowest | Low |
| **SLA** | 99.99% (HA VPN) | 99.99% | 99.9% - 99.99% |
| **Ціна** | $ | $$$ | $$ |
| **Setup** | Швидко | Повільно | Середньо |

### Коли використовувати Interconnect

- ✅ Потрібна висока bandwidth (> 10 Gbps)
- ✅ Критична latency
- ✅ Compliance вимоги (приватне з'єднання)
- ✅ Великі обсяги даних

---

## Shared VPC

**Опис:** Спільне використання VPC між кількома проектами.

### Ключові характеристики

- Host project: Володіє VPC
- Service projects: Використовують VPC
- Централізоване управління мережею
- Розподілене управління ресурсами

### Коли використовувати

- ✅ Організація з кількома проектами
- ✅ Централізоване управління мережею
- ✅ Спільні ресурси (VPN, Interconnect)

---

## Networking Decision Tree

```mermaid
graph TD
    A[Networking потреба?] --> B{Тип з'єднання?}
    
    B -->|Internal VPC| C[VPC + Subnets]
    B -->|Load Balancing| D{Тип трафіку?}
    B -->|Hybrid Cloud| E{Bandwidth?}
    B -->|DNS| F[Cloud DNS]
    B -->|CDN| G[Cloud CDN]
    
    D -->|HTTP/HTTPS| D1[HTTP(S) LB]
    D -->|TCP/UDP External| D2[Network LB]
    D -->|TCP/UDP Internal| D3[Internal LB]
    
    E -->|< 10 Gbps| E1[Cloud VPN]
    E -->|> 10 Gbps| E2{Colocation?}
    E2 -->|Так| E3[Dedicated Interconnect]
    E2 -->|Ні| E4[Partner Interconnect]
    
    style C fill:#4285f4,color:#fff
    style D1 fill:#34a853,color:#fff
    style E1 fill:#fbbc04
    style E3 fill:#ea4335,color:#fff
```

---

> ⚠️ **Важливо для іспиту**: Розуміння різниці між типами load balancers та коли використовувати VPN vs Interconnect - критично важливе для іспиту ACE.

---

**Повернутися до:** [Модуль 02 - Основні сервіси GCP](README.md)
