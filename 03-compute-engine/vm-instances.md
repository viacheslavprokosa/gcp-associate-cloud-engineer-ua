# VM Instances

## Створення VM Instances

### Через Console

1. Navigation menu → Compute Engine → VM instances
2. CREATE INSTANCE
3. Налаштування: name, region, zone, machine type, boot disk
4. CREATE

### Через gcloud

```bash
gcloud compute instances create my-vm \
  --zone=us-central1-a \
  --machine-type=e2-medium \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --boot-disk-size=20GB \
  --boot-disk-type=pd-balanced
```

---

## SSH Доступ

### Через Console

- Click SSH button в VM instances list

### Через gcloud

```bash
gcloud compute ssh my-vm --zone=us-central1-a
```

### Через SSH keys

```bash
# Додати SSH key до metadata
gcloud compute instances add-metadata my-vm \
  --metadata-from-file ssh-keys=~/.ssh/id_rsa.pub
```

---

## Metadata та Startup Scripts

### Metadata

Ключ-значення пари для конфігурації VM:

```bash
gcloud compute instances create my-vm \
  --metadata=key1=value1,key2=value2
```

### Startup Script

Виконується при кожному запуску VM:

```bash
gcloud compute instances create my-vm \
  --metadata-from-file startup-script=startup.sh
```

Приклад startup.sh:

```bash
#!/bin/bash
apt-get update
apt-get install -y nginx
systemctl start nginx
```

---

## Preemptible VMs

**Опис:** Короткострокові VM з 60-91% знижкою, можуть бути зупинені GCP в будь-який момент.

### Характеристики

- До 24 годин роботи
- 30-секундне попередження перед зупинкою
- Не гарантована доступність
- Не підходять для production баз даних

### Створення

```bash
gcloud compute instances create my-preemptible-vm \
  --preemptible \
  --zone=us-central1-a
```

### Коли використовувати

- ✅ Batch processing
- ✅ Fault-tolerant workloads
- ✅ Тестування та розробка
- ❌ Критичні production workloads

---

## Spot VMs

**Опис:** Новіша версія Preemptible VMs з додатковими можливостями.

### Відмінності від Preemptible

- Немає максимального часу роботи (24 години)
- Динамічна ціна (може змінюватися)
- Можливість встановити max price

```bash
gcloud compute instances create my-spot-vm \
  --provisioning-model=SPOT \
  --zone=us-central1-a
```

---

## Управління VM

### Зупинка

```bash
gcloud compute instances stop my-vm --zone=us-central1-a
```

### Запуск

```bash
gcloud compute instances start my-vm --zone=us-central1-a
```

### Перезавантаження

```bash
gcloud compute instances reset my-vm --zone=us-central1-a
```

### Видалення

```bash
gcloud compute instances delete my-vm --zone=us-central1-a
```

### Зміна machine type (потребує зупинки)

```bash
gcloud compute instances set-machine-type my-vm \
  --machine-type=e2-standard-4 \
  --zone=us-central1-a
```

---

## Labels та Tags

### Labels

Для організації та біллінгу:

```bash
gcloud compute instances add-labels my-vm \
  --labels=env=prod,team=backend
```

### Network Tags

Для firewall rules:

```bash
gcloud compute instances add-tags my-vm \
  --tags=web-server,https-server
```

---

## Live Migration

- Автоматична міграція VM між хостами без downtime
- Відбувається при maintenance подіях
- Можна вимкнути (VM буде перезавантажена)

```bash
gcloud compute instances create my-vm \
  --maintenance-policy=MIGRATE  # або TERMINATE
```

---

## Best Practices

- ✅ Використовуйте startup scripts для автоматизації
- ✅ Застосовуйте labels для організації
- ✅ Використовуйте preemptible/spot VMs для cost savings
- ✅ Налаштуйте автоматичні snapshots
- ✅ Використовуйте service accounts замість user credentials
- ✅ Увімкніть OS Login для централізованого управління SSH

---

**Повернутися до:** [Модуль 03 - Compute Engine](README.md)
