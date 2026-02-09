# Clusters and Nodes

## Node Pools

Група nodes з однаковою конфігурацією.

```bash
# Створити node pool
gcloud container node-pools create my-pool \
  --cluster=my-cluster \
  --machine-type=e2-standard-4 \
  --num-nodes=3 \
  --zone=us-central1-a

# Список node pools
gcloud container node-pools list --cluster=my-cluster --zone=us-central1-a
```

---

## Cluster Autoscaling

```bash
# Увімкнути autoscaling
gcloud container clusters update my-cluster \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=10 \
  --zone=us-central1-a
```

---

## Regional vs Zonal Clusters

- **Zonal**: Control plane в одній зоні
- **Regional**: Control plane реплікується в 3 зонах (HA)

```bash
# Regional cluster
gcloud container clusters create my-regional-cluster \
  --region=us-central1 \
  --num-nodes=1  # per zone
```

---

**Повернутися до:** [Модуль 04 - Kubernetes Engine](README.md)
