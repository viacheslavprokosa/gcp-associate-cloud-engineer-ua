# Networking

## Вступ до модуля

Networking - це основа cloud інфраструктури. Розуміння VPC, subnets, load balancing та інших networking концепцій критично важливе для проектування безпечних та ефективних архітектур.

### Структура модуля

```mermaid
graph TB
    A[Networking] --> B[VPC]
    A --> C[Load Balancing]
    A --> D[Cloud DNS]
    A --> E[VPN/Interconnect]
    
    B --> B1[Subnets]
    B --> B2[Firewall Rules]
    B --> B3[Routes]
    
    C --> C1[Global LB]
    C --> C2[Regional LB]
    C --> C3[Internal LB]
    
    style A fill:#4285f4,color:#fff
    style B fill:#34a853,color:#fff
```

---

## Module Goal

Цей модуль надає розуміння networking в GCP. Ви навчитесь створювати VPC, налаштовувати load balancing, та забезпечувати connectivity.

---

## Topics

### 1. [VPC](vpc.md)

**Virtual Private Cloud:**

- Global resource
- Subnets (regional)
- Firewall rules
- Routes

---

### 2. [Load Balancing](load-balancing.md)

**Types:**

- Global HTTP(S) Load Balancer
- Regional Network Load Balancer
- Internal Load Balancer

---

### 3. [Cloud DNS](cloud-dns.md)

**Managed DNS:**

- Public zones
- Private zones
- DNSSEC

---

### 4. [VPN/Interconnect](vpn-interconnect.md)

**Hybrid Connectivity:**

- Cloud VPN: Encrypted connection
- Cloud Interconnect: Dedicated connection

---

## Key Exam Takeaways

✅ **VPC:** Global network, regional subnets
✅ **Load Balancer:** Global для HTTP(S), Regional для TCP/UDP
✅ **Cloud VPN:** Encrypted hybrid connectivity

---

**Попередній модуль:** [Module 08 - Databases](../08-databases/README.md)

**Наступний модуль:** [Module 10 - IAM & Security](../10-iam-security/README.md)
