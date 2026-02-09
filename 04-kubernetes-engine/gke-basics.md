# GKE Basics

## GKE Modes

### Standard Mode

- Повний контроль над кластером
- Управління nodes
- Налаштування node pools
- Більше опцій конфігурації

### Autopilot Mode

- Google управляє nodes
- Автоматична оптимізація
- Оплата за pods, не за nodes
- Менше управління, більше автоматизації

**Рекомендація:** Autopilot для більшості workloads, Standard для специфічних вимог.

---

## kubectl Basics

```bash
# Отримати credentials
gcloud container clusters get-credentials my-cluster --zone=us-central1-a

# Список pods
kubectl get pods

# Список services
kubectl get services

# Деталі pod
kubectl describe pod my-pod

# Логи pod
kubectl logs my-pod

# Виконати команду в pod
kubectl exec -it my-pod -- /bin/bash
```

---

## Створення GKE Cluster

### Standard Mode

```bash
gcloud container clusters create my-cluster \
  --zone=us-central1-a \
  --num-nodes=3 \
  --machine-type=e2-medium
```

### Autopilot Mode

```bash
gcloud container clusters create-auto my-autopilot-cluster \
  --region=us-central1
```

---

**Повернутися до:** [Модуль 04 - Kubernetes Engine](README.md)
