# Compute Engine

## Мета модуля

Цей модуль охоплює Google Compute Engine - IaaS сервіс для створення та управління віртуальними машинами. Ви навчитесь створювати VM instances, вибирати правильні machine types, управляти дисками та використовувати instance groups для масштабування.

## Module Goal (English)

This module covers Google Compute Engine - an IaaS service for creating and managing virtual machines. You will learn to create VM instances, choose the right machine types, manage disks, and use instance groups for scaling.

## Topics

- [VM Instances](vm-instances.md) - Створення, управління, SSH, metadata, preemptible VMs
- [Machine Types](machine-types.md) - Predefined, custom, shared-core types
- [Disks and Images](disks-and-images.md) - Persistent disks, local SSDs, snapshots, images
- [Instance Groups](instance-groups.md) - Managed vs unmanaged, autoscaling, health checks

## Key Exam Takeaways

- ✅ Know how to create and manage VM instances using gcloud and Console
- ✅ Understand the difference between predefined, custom, and shared-core machine types
- ✅ Know when to use preemptible/spot VMs for cost optimization
- ✅ Understand persistent disk types (Standard, Balanced, SSD, Extreme)
- ✅ Know how to create and use snapshots for backup and disaster recovery
- ✅ Understand managed instance groups (MIGs) with autoscaling
- ✅ Know how to configure health checks and rolling updates

## VM Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Provisioning: Create Instance
    Provisioning --> Staging: Resources Allocated
    Staging --> Running: Boot Complete
    Running --> Stopping: Stop Command
    Stopping --> Terminated: Stopped
    Terminated --> Running: Start Command
    Running --> Terminated: Delete Command
    Terminated --> [*]: Resources Released
    
    Running --> Running: Reset
    Running --> Suspended: Suspend (Beta)
    Suspended --> Running: Resume
```

## Compute Engine Architecture

```mermaid
graph TB
    subgraph "Compute Engine"
        VM1[VM Instance]
        VM2[VM Instance]
        VM3[VM Instance]
    end
    
    subgraph "Storage"
        PD1[Boot Disk<br/>Persistent Disk]
        PD2[Data Disk<br/>Persistent Disk]
        SSD[Local SSD]
    end
    
    subgraph "Networking"
        VPC[VPC Network]
        FW[Firewall Rules]
        LB[Load Balancer]
    end
    
    subgraph "Management"
        MIG[Managed Instance Group]
        AS[Autoscaler]
        HC[Health Check]
    end
    
    VM1 --> PD1
    VM1 --> PD2
    VM1 --> SSD
    VM1 --> VPC
    
    MIG --> VM1
    MIG --> VM2
    MIG --> VM3
    
    AS --> MIG
    HC --> MIG
    LB --> MIG
    
    VPC --> FW
    
    style VM1 fill:#4285f4,color:#fff
    style MIG fill:#34a853,color:#fff
    style LB fill:#fbbc04
```

## 📝 [Practice Questions](exam-questions.md)
