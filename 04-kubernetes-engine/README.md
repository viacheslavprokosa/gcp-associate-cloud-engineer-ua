# Google Kubernetes Engine (GKE)

## Мета модуля

Цей модуль охоплює Google Kubernetes Engine - керований Kubernetes сервіс для оркестрації контейнерів. Ви навчитесь створювати кластери, управляти workloads та використовувати GKE для production deployments.

## Module Goal (English)

This module covers Google Kubernetes Engine - a managed Kubernetes service for container orchestration. You will learn to create clusters, manage workloads, and use GKE for production deployments.

## Topics

- [GKE Basics](gke-basics.md) - Standard vs Autopilot, kubectl basics
- [Clusters and Nodes](clusters-and-nodes.md) - Creating clusters, node pools, autoscaling
- [Workloads](workloads.md) - Deployments, Services, ConfigMaps, Secrets

## Key Exam Takeaways

- ✅ Know the difference between GKE Standard and Autopilot modes
- ✅ Understand node pools and cluster autoscaling
- ✅ Know how to deploy applications using kubectl
- ✅ Understand Services (ClusterIP, NodePort, LoadBalancer)
- ✅ Know how to use ConfigMaps and Secrets
- ✅ Understand Persistent Volumes in GKE

## GKE Architecture

```mermaid
graph TB
    subgraph "GKE Cluster"
        CP[Control Plane<br/>Managed by Google]
        
        subgraph "Node Pool 1"
            N1[Node 1]
            N2[Node 2]
        end
        
        subgraph "Node Pool 2"
            N3[Node 3]
            N4[Node 4]
        end
        
        CP --> N1
        CP --> N2
        CP --> N3
        CP --> N4
    end
    
    subgraph "Workloads"
        D[Deployment]
        S[Service]
        CM[ConfigMap]
        SEC[Secret]
    end
    
    D --> N1
    D --> N2
    S --> D
    CM --> D
    SEC --> D
    
    LB[Load Balancer] --> S
    
    style CP fill:#4285f4,color:#fff
    style LB fill:#34a853,color:#fff
```

## 📝 [Practice Questions](exam-questions.md)
