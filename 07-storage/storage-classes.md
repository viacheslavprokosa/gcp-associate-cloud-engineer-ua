# Storage Classes

> ⚠️ **Примітка:** Детальна інформація про Storage Classes знаходиться в [cloud-storage.md](cloud-storage.md#storage-classes)

---

## Швидкий огляд

Cloud Storage має 4 storage classes, оптимізовані для різних patterns доступу:

| Class | Use Case | Min Duration | Cost/GB/month | Retrieval Cost |
|-------|----------|--------------|---------------|----------------|
| **Standard** | Frequent access | None | $0.020 | None |
| **Nearline** | < 1/month | 30 days | $0.010 | $0.01/GB |
| **Coldline** | < 1/quarter | 90 days | $0.004 | $0.02/GB |
| **Archive** | < 1/year | 365 days | $0.0012 | $0.05/GB |

---

## Детальна документація

Для повної інформації про Storage Classes, включаючи:

- ✅ Детальний опис кожного класу
- ✅ Pricing analysis та cost optimization
- ✅ Use cases та selection criteria
- ✅ Lifecycle policies для автоматичного переходу між класами
- ✅ Autoclass feature
- ✅ Практичні сценарії

**Дивіться:** [Cloud Storage - Storage Classes](cloud-storage.md#storage-classes)

---

## Основні команди

### Створити bucket з specific storage class

```bash
gsutil mb -c STANDARD gs://my-bucket
gsutil mb -c NEARLINE gs://my-nearline-bucket
gsutil mb -c COLDLINE gs://my-coldline-bucket
gsutil mb -c ARCHIVE gs://my-archive-bucket
```

### Змінити storage class існуючого object

```bash
gsutil rewrite -s NEARLINE gs://my-bucket/file.txt
```

### Lifecycle policy для автоматичного переходу

```bash
gsutil lifecycle set lifecycle.json gs://my-bucket
```

**lifecycle.json:**

```json
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "SetStorageClass", "storageClass": "NEARLINE"},
        "condition": {"age": 30}
      },
      {
        "action": {"type": "SetStorageClass", "storageClass": "COLDLINE"},
        "condition": {"age": 90}
      },
      {
        "action": {"type": "SetStorageClass", "storageClass": "ARCHIVE"},
        "condition": {"age": 365}
      }
    ]
  }
}
```

---

## Cross-References

**Детальна теорія:**

- [Cloud Storage - Storage Classes](cloud-storage.md#storage-classes)
- [Cloud Storage - Lifecycle Management](cloud-storage.md#object-lifecycle-management)

**Практичні сценарії:**

- [Cloud Storage - Multi-Tier Storage Scenario](cloud-storage.md#practical-scenario-multi-tier-storage-strategy)

**Інші модулі:**

- [Module 02 - Storage Services](../02-gcp-core-services/storage-services.md)
- [Module 11 - Cloud Monitoring](../11-monitoring-logging/cloud-monitoring.md)

---

> ⚠️ **Важливо для іспиту:** Розуміння різниці між storage classes, minimum storage duration, та retrieval costs критично важливе для cost optimization питань на ACE exam.

---

**Повернутися до:** [Модуль 07 - Storage](README.md)
