# Основи хмарних обчислень

## Module Goal

Цей модуль охоплює основи хмарних обчислень, моделі обслуговування (IaaS, PaaS, SaaS)
та географічну структуру Google Cloud Platform (регіони та зони). Ви дізнаєтесь про регіони, зони доступності та основні переваги використання хмарних технологій.

## Module Goal (English)

This module covers cloud computing fundamentals, service models (IaaS, PaaS, SaaS),
and the geographic structure of Google Cloud Platform (regions and zones). You will learn about regions, availability zones, and key benefits of using cloud technologies.

## Topics

- [Моделі хмарних обчислень](cloud-models.md) - IaaS, PaaS, SaaS
- [Регіони та зони GCP](gcp-regions-zones.md) - Географія та доступність

## Key Exam Takeaways

- ✅ Understand the difference between IaaS, PaaS, and SaaS service models
- ✅ Know which GCP services belong to each service model category
- ✅ Understand the concept of regions and zones for high availability
- ✅ Know how to choose the right region based on latency, compliance, and cost
- ✅ Understand multi-region resources vs regional vs zonal resources
- ✅ Know the benefits of cloud computing: scalability, elasticity, pay-as-you-go
- ✅ Understand CAPEX vs OPEX cost model transformation

## Architecture Diagram

```mermaid
graph TB
    subgraph "Cloud Service Models"
        A[SaaS<br/>Software as a Service]
        B[PaaS<br/>Platform as a Service]
        C[IaaS<br/>Infrastructure as a Service]
    end
    
    subgraph "User Responsibility"
        A --> A1[Applications Only]
        B --> B1[Applications + Data]
        C --> C1[OS + Applications + Data]
    end
    
    subgraph "GCP Examples"
        A --> A2[Gmail, Workspace]
        B --> B2[App Engine, Cloud Functions]
        C --> C2[Compute Engine, Cloud Storage]
    end
    
    style A fill:#e1f5ff
    style B fill:#fff4e1
    style C fill:#ffe1e1
```

## GCP Geography

```mermaid
graph LR
    A[Organization] --> B[Multi-Region<br/>e.g., EU, US]
    B --> C1[Region<br/>europe-west1]
    B --> C2[Region<br/>us-central1]
    
    C1 --> D1[Zone<br/>europe-west1-a]
    C1 --> D2[Zone<br/>europe-west1-b]
    C1 --> D3[Zone<br/>europe-west1-c]
    
    C2 --> E1[Zone<br/>us-central1-a]
    C2 --> E2[Zone<br/>us-central1-b]
    
    style A fill:#4285f4,color:#fff
    style B fill:#34a853,color:#fff
    style C1 fill:#fbbc04
    style C2 fill:#fbbc04
```

## 📝 [Practice Questions](exam-questions.md)
