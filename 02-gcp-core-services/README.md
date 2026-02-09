# Основні сервіси GCP

## Мета модуля

Цей модуль надає огляд основних сервісів Google Cloud Platform, згрупованих за категоріями: обчислення (Compute), сховища (Storage), бази даних (Databases) та мережі (Networking). Ви навчитесь вибирати правильний сервіс для конкретного сценарію використання.

## Module Goal (English)

This module provides an overview of core Google Cloud Platform services grouped by categories: Compute, Storage, Databases, and Networking. You will learn to select the right service for specific use cases.

## Topics

- [Compute Services](compute-services.md) - Compute Engine, GKE, App Engine, Cloud Functions, Cloud Run
- [Storage Services](storage-services.md) - Cloud Storage, Persistent Disk, Filestore
- [Database Services](database-services.md) - Cloud SQL, Spanner, Firestore, Bigtable, Memorystore
- [Networking Services](networking-services.md) - VPC, Load Balancing, Cloud CDN, DNS, VPN, Interconnect

## Key Exam Takeaways

- ✅ Know when to use Compute Engine vs GKE vs App Engine vs Cloud Functions
- ✅ Understand the difference between object storage (Cloud Storage) and block storage (Persistent Disk)
- ✅ Know which database to choose based on data structure and scale requirements
- ✅ Understand VPC concepts and how to connect resources securely
- ✅ Know the different types of load balancers and when to use each
- ✅ Understand the difference between Cloud VPN and Cloud Interconnect

## GCP Services Overview

```mermaid
graph TB
    subgraph Compute
        CE[Compute Engine<br/>IaaS VMs]
        GKE[Google Kubernetes Engine<br/>Managed Kubernetes]
        AE[App Engine<br/>PaaS Platform]
        CF[Cloud Functions<br/>Serverless Functions]
        CR[Cloud Run<br/>Serverless Containers]
    end
    
    subgraph Storage
        CS[Cloud Storage<br/>Object Storage]
        PD[Persistent Disk<br/>Block Storage]
        FS[Filestore<br/>NFS File Storage]
    end
    
    subgraph Databases
        SQL[Cloud SQL<br/>Relational DB]
        SP[Cloud Spanner<br/>Global Relational DB]
        FI[Firestore<br/>NoSQL Document DB]
        BT[Bigtable<br/>NoSQL Wide-Column]
        MS[Memorystore<br/>Redis/Memcached]
    end
    
    subgraph Networking
        VPC[VPC<br/>Virtual Network]
        LB[Load Balancing<br/>Traffic Distribution]
        CDN[Cloud CDN<br/>Content Delivery]
        DNS[Cloud DNS<br/>Domain Name System]
        VPN[Cloud VPN<br/>Secure Connection]
    end
    
    style CE fill:#e1f5ff
    style GKE fill:#e1f5ff
    style AE fill:#fff4e1
    style CF fill:#fff4e1
    style CR fill:#fff4e1
    style CS fill:#ffe1e1
    style PD fill:#ffe1e1
    style SQL fill:#e1ffe1
    style SP fill:#e1ffe1
```

## Service Selection Decision Tree

```mermaid
graph TD
    A[What do you need?] --> B{Compute?}
    A --> C{Storage?}
    A --> D{Database?}
    A --> E{Networking?}
    
    B --> B1{Need full OS control?}
    B1 -->|Yes| B2[Compute Engine]
    B1 -->|No| B3{Containerized?}
    B3 -->|Yes, orchestration| B4[GKE]
    B3 -->|Yes, simple| B5[Cloud Run]
    B3 -->|No| B6{Event-driven?}
    B6 -->|Yes| B7[Cloud Functions]
    B6 -->|No| B8[App Engine]
    
    C --> C1{What type?}
    C1 -->|Objects/Files| C2[Cloud Storage]
    C1 -->|Block for VMs| C3[Persistent Disk]
    C1 -->|NFS shares| C4[Filestore]
    
    D --> D1{Relational or NoSQL?}
    D1 -->|Relational| D2{Global scale?}
    D2 -->|Yes| D3[Cloud Spanner]
    D2 -->|No| D4[Cloud SQL]
    D1 -->|NoSQL| D5{Data model?}
    D5 -->|Document| D6[Firestore]
    D5 -->|Wide-column| D7[Bigtable]
    D5 -->|Cache| D8[Memorystore]
    
    style B2 fill:#4285f4,color:#fff
    style B4 fill:#4285f4,color:#fff
    style B5 fill:#4285f4,color:#fff
    style B7 fill:#4285f4,color:#fff
    style B8 fill:#4285f4,color:#fff
```

## 📝 [Practice Questions](exam-questions.md)
