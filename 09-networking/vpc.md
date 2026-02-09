# VPC

Глобальна віртуальна приватна мережа.

## Firewall Rules

```bash
gcloud compute firewall-rules create allow-ssh \
  --network=my-vpc \
  --allow=tcp:22 \
  --source-ranges=0.0.0.0/0
```

**Повернутися до:** [Модуль 09 - Networking](README.md)
