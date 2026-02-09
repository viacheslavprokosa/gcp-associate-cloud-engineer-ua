# Disks and Images

## Persistent Disks

### Типи дисків

| Type | Performance | Use Case | Price |
|------|-------------|----------|-------|
| **Standard PD** (HDD) | 0.75-1.2 MB/s per GB | Sequential I/O, throughput | $ |
| **Balanced PD** (SSD) | 6 IOPS per GB | General purpose (recommended) | $$ |
| **SSD PD** | 30 IOPS per GB | Low-latency, transactional | $$$ |
| **Extreme PD** | 120 IOPS per GB | Highest performance | $$$$ |

### Характеристики

- Незалежні від VM lifecycle
- Автоматична реплікація в зоні
- Можна змінювати розмір без downtime
- До 64 TB на диск
- До 128 дисків на VM

### Zonal vs Regional PD

- **Zonal**: Реплікується в одній зоні (стандарт)
- **Regional**: Реплікується в двох зонах (HA, дорожче)

### Створення та приєднання

```bash
# Створити диск
gcloud compute disks create my-disk \
  --size=100GB \
  --type=pd-balanced \
  --zone=us-central1-a

# Приєднати до VM
gcloud compute instances attach-disk my-vm \
  --disk=my-disk \
  --zone=us-central1-a

# Відключити диск
gcloud compute instances detach-disk my-vm \
  --disk=my-disk \
  --zone=us-central1-a

# Змінити розмір
gcloud compute disks resize my-disk \
  --size=200GB \
  --zone=us-central1-a
```

---

## Local SSDs

**Опис:** Фізично прикріплені SSD диски до VM host.

### Характеристики

- Найвища продуктивність (375 GB, 3 TB IOPS)
- Дані втрачаються при зупинці/видаленні VM
- До 24 local SSDs на VM (9 TB)
- Не можна відключити без видалення VM

### Коли використовувати

- ✅ Temporary cache
- ✅ Scratch space
- ✅ High-performance computing
- ❌ Persistent data

### Створення

```bash
gcloud compute instances create my-vm \
  --local-ssd=interface=NVME \
  --zone=us-central1-a
```

---

## Snapshots

**Опис:** Incremental backup persistent disks.

### Характеристики

- Incremental (тільки зміни)
- Глобальний ресурс
- Можна створювати з running VM
- Автоматичне стиснення

### Створення та використання

```bash
# Створити snapshot
gcloud compute disks snapshot my-disk \
  --snapshot-names=my-snapshot \
  --zone=us-central1-a

# Створити диск зі snapshot
gcloud compute disks create new-disk \
  --source-snapshot=my-snapshot \
  --zone=us-central1-b

# Список snapshots
gcloud compute snapshots list

# Видалити snapshot
gcloud compute snapshots delete my-snapshot
```

### Snapshot Schedule

Автоматичні snapshots за розкладом:

```bash
# Створити schedule
gcloud compute resource-policies create snapshot-schedule daily-backup \
  --max-retention-days=7 \
  --start-time=02:00 \
  --daily-schedule \
  --region=us-central1

# Приєднати до диску
gcloud compute disks add-resource-policies my-disk \
  --resource-policies=daily-backup \
  --zone=us-central1-a
```

---

## Images

**Опис:** Boot disk templates для створення VM.

### Типи

- **Public images**: Надані Google та партнерами (Debian, Ubuntu, Windows)
- **Custom images**: Створені з ваших дисків
- **Machine images**: Повна конфігурація VM (диски + metadata)

### Створення custom image

```bash
# З диску
gcloud compute images create my-image \
  --source-disk=my-disk \
  --source-disk-zone=us-central1-a

# З snapshot
gcloud compute images create my-image \
  --source-snapshot=my-snapshot

# З іншого image
gcloud compute images create my-image \
  --source-image=source-image \
  --source-image-project=source-project
```

### Використання image

```bash
gcloud compute instances create my-vm \
  --image=my-image \
  --zone=us-central1-a
```

---

## Machine Images

**Опис:** Повна конфігурація VM instance (всі диски + metadata + network).

### Відмінності від Custom Image

- Machine Image: Вся VM конфігурація
- Custom Image: Тільки boot disk

### Створення

```bash
gcloud compute machine-images create my-machine-image \
  --source-instance=my-vm \
  --source-instance-zone=us-central1-a

# Створити VM з machine image
gcloud compute instances create new-vm \
  --source-machine-image=my-machine-image \
  --zone=us-central1-b
```

---

## Image Families

**Опис:** Групування версій images.

### Використання

```bash
# Створити image в family
gcloud compute images create my-image-v2 \
  --source-disk=my-disk \
  --family=my-app \
  --source-disk-zone=us-central1-a

# Використати latest image з family
gcloud compute instances create my-vm \
  --image-family=my-app \
  --zone=us-central1-a
```

---

## Порівняльна таблиця

| Feature | Persistent Disk | Local SSD | Snapshot | Image |
|---------|----------------|-----------|----------|-------|
| **Persistence** | Так | Ні | Так | Так |
| **Performance** | Середня-Висока | Найвища | N/A | N/A |
| **Scope** | Zonal/Regional | VM-local | Global | Global |
| **Use Case** | Data storage | Temp cache | Backup | Templates |
| **Max Size** | 64 TB | 9 TB | Unlimited | N/A |

---

## Best Practices

### Persistent Disks

- ✅ Використовуйте pd-balanced для більшості workloads
- ✅ Regional PD для критичних даних
- ✅ Моніторьте IOPS та throughput
- ✅ Збільшуйте розмір для більшої performance

### Snapshots

- ✅ Налаштуйте snapshot schedules
- ✅ Зберігайте snapshots в іншому регіоні для DR
- ✅ Видаляйте старі snapshots
- ✅ Використовуйте incremental nature

### Images

- ✅ Використовуйте image families для версіонування
- ✅ Створюйте custom images для стандартизації
- ✅ Шифруйте sensitive images
- ✅ Діліться images між projects через IAM

---

> ⚠️ **Важливо для іспиту**: Розуміння різниці між persistent disk types, snapshots, images та machine images критично важливе. Знайте коли використовувати кожен тип та їх обмеження.

---

**Повернутися до:** [Модуль 03 - Compute Engine](README.md)
