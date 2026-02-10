# Persistent Disks

> ⚠️ **Примітка:** Детальна інформація про Persistent Disks знаходиться в [Module 03 - Disks and Images](../03-compute-engine/disks-and-images.md)

---

## Швидкий огляд

Persistent Disks - block storage для Compute Engine VMs з різними типами для різних workloads:

| Type | Technology | Max IOPS (Read/Write) | Max Throughput | Use Case |
|------|------------|----------------------|----------------|----------|
| **Standard PD** | HDD | 7,500 / 15,000 | 1,200 MB/s | Sequential, bulk |
| **Balanced PD** | SSD | 80,000 / 30,000 | 1,200 MB/s | General purpose |
| **SSD PD** | SSD | 100,000 / 60,000 | 1,200 MB/s | High performance |
| **Extreme PD** | SSD | 120,000 / 120,000 | 2,400 MB/s | Ultra-high IOPS |

---

## Детальна документація

Для повної інформації про Persistent Disks, включаючи:

- ✅ Disk types та performance characteristics
- ✅ IOPS/throughput calculations
- ✅ Performance factors (disk size, VM vCPUs)
- ✅ Snapshots (incremental backups, chains)
- ✅ Disk encryption (Google-managed, CMEK, CSEK)
- ✅ Regional persistent disks для HA
- ✅ Практичні сценарії

**Дивіться:** [Module 03 - Disks and Images](../03-compute-engine/disks-and-images.md)

---

## Основні команди

### Створити persistent disk

```bash
# Standard PD (HDD)
gcloud compute disks create my-disk \
  --size=100GB \
  --type=pd-standard \
  --zone=us-central1-a

# Balanced PD (SSD)
gcloud compute disks create my-balanced-disk \
  --size=100GB \
  --type=pd-balanced \
  --zone=us-central1-a

# SSD PD
gcloud compute disks create my-ssd-disk \
  --size=100GB \
  --type=pd-ssd \
  --zone=us-central1-a

# Extreme PD
gcloud compute disks create my-extreme-disk \
  --size=500GB \
  --type=pd-extreme \
  --provisioned-iops=100000 \
  --zone=us-central1-a
```

### Attach disk до VM

```bash
gcloud compute instances attach-disk my-instance \
  --disk=my-disk \
  --zone=us-central1-a
```

### Створити snapshot

```bash
gcloud compute disks snapshot my-disk \
  --snapshot-names=my-snapshot \
  --zone=us-central1-a
```

### Створити disk з snapshot

```bash
gcloud compute disks create my-restored-disk \
  --source-snapshot=my-snapshot \
  --zone=us-central1-a
```

### Regional persistent disk (HA)

```bash
gcloud compute disks create my-regional-disk \
  --size=100GB \
  --type=pd-ssd \
  --region=us-central1 \
  --replica-zones=us-central1-a,us-central1-b
```

---

## Cross-References

**Детальна теорія:**

- [Module 03 - Disks and Images](../03-compute-engine/disks-and-images.md)
- [Module 03 - Persistent Disk Types](../03-compute-engine/disks-and-images.md#persistent-disk-types)
- [Module 03 - Snapshots](../03-compute-engine/disks-and-images.md#snapshots)
- [Module 03 - Disk Encryption](../03-compute-engine/disks-and-images.md#disk-encryption)

**Практичні сценарії:**

- [Module 03 - Multi-Tier Application Storage](../03-compute-engine/disks-and-images.md#practical-scenario-multi-tier-application-storage-strategy)

**Інші модулі:**

- [Module 03 - VM Instances](../03-compute-engine/vm-instances.md)
- [Module 07 - Cloud Storage](cloud-storage.md) - Object storage alternative
- [Module 07 - Filestore](filestore.md) - NFS alternative

---

## Persistent Disk vs Alternatives

| Feature | Persistent Disk | Local SSD | Cloud Storage | Filestore |
|---------|----------------|-----------|---------------|-----------|
| **Type** | Block storage | Block storage | Object storage | File storage |
| **Persistence** | Yes | No (ephemeral) | Yes | Yes |
| **Latency** | 1-2ms | Sub-ms | Higher | 1-3ms |
| **Sharing** | No (single VM) | No | Yes | Yes (NFS) |
| **Use Case** | VM boot/data | Temp/cache | Unstructured data | Shared files |

---

> ⚠️ **Важливо для іспиту:** Розуміння різниці між disk types, IOPS/throughput limits, snapshot strategies, та encryption options критично важливе для ACE exam.

---

**Повернутися до:** [Модуль 07 - Storage](README.md)
