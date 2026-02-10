# Filestore

## Fundamentals

**Filestore** - це повністю керований NFS (Network File System) сервіс для спільного доступу до файлів між VM instances та GKE pods.

### Що таке NFS?

**NFS (Network File System)** - це протокол для спільного доступу до файлів через мережу.

**Характеристики:**

- **POSIX-compliant**: Стандартна файлова система
- **Shared access**: Кілька VM можуть читати/писати одночасно
- **File locking**: Підтримка file locks для consistency
- **Permissions**: Standard Linux file permissions (chmod, chown)

**Порівняння з іншими storage:**

| Feature | Filestore (NFS) | Cloud Storage | Persistent Disk |
|---------|----------------|---------------|-----------------|
| **Access** | Multiple VMs | HTTP API | Single VM |
| **Protocol** | NFS | REST/gRPC | Block device |
| **Use Case** | Shared files | Object storage | VM disks |
| **Latency** | Low (ms) | Higher | Lowest |
| **Consistency** | Strong | Eventual | Strong |

---

## Filestore Tiers

### Basic HDD

**Опис:** Entry-level tier з HDD storage.

**Характеристики:**

- **Capacity**: 1 TB - 63.9 TB
- **Performance**:
  - Read: 100 MB/s + 0.1 MB/s per GB
  - Write: 100 MB/s + 0.1 MB/s per GB
  - IOPS: 1,000 + 1 per GB
- **Availability**: Zonal (single zone)
- **Price**: ~$0.20/GB/month

**Use Cases:**

- ✅ File sharing
- ✅ Development environments
- ✅ Cost-sensitive workloads
- ❌ High-performance applications

**Example:**

```bash
gcloud filestore instances create my-filestore \
  --tier=BASIC_HDD \
  --file-share=name=vol1,capacity=1TB \
  --network=name=default \
  --zone=us-central1-a
```

**Performance Calculation:**

```
1 TB (1024 GB) Basic HDD:
- Read: 100 + (1024 × 0.1) = 202.4 MB/s
- Write: 100 + (1024 × 0.1) = 202.4 MB/s
- IOPS: 1,000 + 1024 = 2,024 IOPS
```

---

### Basic SSD

**Опис:** SSD-based tier для кращої performance.

**Характеристики:**

- **Capacity**: 2.5 TB - 63.9 TB
- **Performance**:
  - Read: 350 MB/s + 0.35 MB/s per GB
  - Write: 350 MB/s + 0.35 MB/s per GB
  - IOPS: 6,000 + 6 per GB
- **Availability**: Zonal
- **Price**: ~$0.30/GB/month

**Use Cases:**

- ✅ High-performance applications
- ✅ Databases (shared storage)
- ✅ Media processing
- ✅ Analytics workloads

**Example:**

```bash
gcloud filestore instances create my-ssd-filestore \
  --tier=BASIC_SSD \
  --file-share=name=vol1,capacity=2.5TB \
  --network=name=default \
  --zone=us-central1-a
```

**Performance Calculation:**

```
2.5 TB (2560 GB) Basic SSD:
- Read: 350 + (2560 × 0.35) = 1,246 MB/s
- Write: 350 + (2560 × 0.35) = 1,246 MB/s
- IOPS: 6,000 + (2560 × 6) = 21,360 IOPS
```

---

### High Scale SSD

**Опис:** Для великих обсягів даних та високої performance.

**Характеристики:**

- **Capacity**: 10 TB - 100 TB
- **Performance**:
  - Read: Up to 1,200 MB/s per TB (max 12 GB/s)
  - Write: Up to 1,200 MB/s per TB (max 12 GB/s)
  - IOPS: Up to 100,000 per TB (max 1M IOPS)
- **Availability**: Zonal
- **Price**: ~$0.35/GB/month

**Use Cases:**

- ✅ High-performance computing (HPC)
- ✅ Genomics
- ✅ Financial modeling
- ✅ Large-scale analytics

**Example:**

```bash
gcloud filestore instances create my-highscale \
  --tier=HIGH_SCALE_SSD \
  --file-share=name=vol1,capacity=10TB \
  --network=name=default \
  --zone=us-central1-a
```

**Performance:**

```
10 TB High Scale SSD:
- Read: 12 GB/s
- Write: 12 GB/s
- IOPS: 1M IOPS
```

---

### Enterprise

**Опис:** Regional tier з high availability.

**Характеристики:**

- **Capacity**: 1 TB - 10 TB
- **Performance**:
  - Read: 100 MB/s + 1 MB/s per GB
  - Write: 100 MB/s + 1 MB/s per GB
  - IOPS: 5,000 + 5 per GB
- **Availability**: Regional (multi-zone)
- **SLA**: 99.99%
- **Price**: ~$0.60/GB/month

**Use Cases:**

- ✅ Production workloads
- ✅ Business-critical applications
- ✅ High availability requirements
- ✅ Disaster recovery

**Example:**

```bash
gcloud filestore instances create my-enterprise \
  --tier=ENTERPRISE \
  --file-share=name=vol1,capacity=1TB \
  --network=name=default \
  --region=us-central1
```

**Performance Calculation:**

```
1 TB (1024 GB) Enterprise:
- Read: 100 + (1024 × 1) = 1,124 MB/s
- Write: 100 + (1024 × 1) = 1,124 MB/s
- IOPS: 5,000 + (1024 × 5) = 10,120 IOPS
```

---

## Tier Comparison

| Tier | Capacity | Throughput | IOPS | Availability | Price | Use Case |
|------|----------|------------|------|--------------|-------|----------|
| **Basic HDD** | 1-63.9 TB | 100-6,490 MB/s | 1K-65K | Zonal | $ | File sharing |
| **Basic SSD** | 2.5-63.9 TB | 350-22,715 MB/s | 6K-390K | Zonal | $$ | High performance |
| **High Scale SSD** | 10-100 TB | Up to 12 GB/s | Up to 1M | Zonal | $$$ | HPC, Analytics |
| **Enterprise** | 1-10 TB | 100-10,340 MB/s | 5K-55K | Regional | $$$$ | HA, Production |

---

## Mounting Filestore

### On Compute Engine VM

**1. Create Filestore instance:**

```bash
gcloud filestore instances create my-filestore \
  --tier=BASIC_SSD \
  --file-share=name=vol1,capacity=2.5TB \
  --network=name=default \
  --zone=us-central1-a
```

**2. Get instance details:**

```bash
gcloud filestore instances describe my-filestore \
  --zone=us-central1-a
```

**Output:**

```
name: my-filestore
fileShares:
- name: vol1
  capacityGb: 2560
networks:
- ipAddresses:
  - 10.0.0.2
  network: default
```

**3. Mount on VM:**

```bash
# Install NFS client
sudo apt-get update
sudo apt-get install nfs-common

# Create mount point
sudo mkdir -p /mnt/filestore

# Mount Filestore
sudo mount 10.0.0.2:/vol1 /mnt/filestore

# Verify
df -h /mnt/filestore
```

**4. Auto-mount on boot (add to /etc/fstab):**

```bash
echo "10.0.0.2:/vol1 /mnt/filestore nfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
```

---

### On GKE

**1. Create PersistentVolume:**

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: filestore-pv
spec:
  capacity:
    storage: 2.5Ti
  accessModes:
  - ReadWriteMany
  nfs:
    path: /vol1
    server: 10.0.0.2
  mountOptions:
  - hard
  - nfsvers=3
```

**2. Create PersistentVolumeClaim:**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: filestore-pvc
spec:
  accessModes:
  - ReadWriteMany
  storageClassName: ""
  volumeName: filestore-pv
  resources:
    requests:
      storage: 2.5Ti
```

**3. Use in Pod:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-server
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: filestore
      mountPath: /usr/share/nginx/html
  volumes:
  - name: filestore
    persistentVolumeClaim:
      claimName: filestore-pvc
```

---

## Filestore Features

### Snapshots

**Опис:** Point-in-time copies для backup та recovery.

**Characteristics:**

- Incremental (тільки зміни)
- Швидке створення (секунди)
- Restore до нового instance

**Create Snapshot:**

```bash
gcloud filestore backups create my-backup \
  --instance=my-filestore \
  --instance-zone=us-central1-a \
  --file-share=vol1 \
  --region=us-central1
```

**Restore from Snapshot:**

```bash
gcloud filestore instances create restored-filestore \
  --tier=BASIC_SSD \
  --file-share=name=vol1,capacity=2.5TB,source-backup=my-backup \
  --network=name=default \
  --zone=us-central1-a
```

---

### Scaling

**Capacity Scaling:**

```bash
# Increase capacity (no downtime)
gcloud filestore instances update my-filestore \
  --file-share=name=vol1,capacity=5TB \
  --zone=us-central1-a
```

> ⚠️ **Important**:
>
> - Can only increase capacity, not decrease
> - No downtime during scaling
> - Performance scales with capacity

---

### Monitoring

**Key Metrics:**

- **Storage utilization**: Used vs total capacity
- **Throughput**: Read/write MB/s
- **IOPS**: Operations per second
- **Latency**: Average operation time

**View Metrics:**

```bash
# In Cloud Console: Monitoring > Metrics Explorer
# Metric: filestore.googleapis.com/nfs/server/used_bytes_percent
```

---

## Best Practices

### 1. Choose Right Tier

**Decision Tree:**

```
Performance needs?
├─ Low (file sharing) → Basic HDD
├─ Medium (apps) → Basic SSD
├─ High (HPC) → High Scale SSD
└─ HA required → Enterprise
```

### 2. Network Configuration

```bash
# Use same VPC as VMs
# Enable Private Google Access for management
# Configure firewall rules for NFS (port 2049)
```

### 3. Security

```bash
# Use VPC Service Controls
# Limit access with firewall rules
# Use service accounts for GKE
# Enable audit logging
```

### 4. Backup Strategy

```bash
# Regular snapshots (daily/weekly)
# Test restore procedures
# Store backups in different region
```

### 5. Performance Optimization

```bash
# Use NFSv3 for better performance
# Mount with hard option (prevent data loss)
# Use async for better write performance (if acceptable)
# Monitor metrics and scale capacity
```

---

## Practical Scenario: Shared Media Storage

### Scenario

Media company з video editing workloads.

**Requirements:**

- Multiple editors working on same files
- High-performance storage (4K video)
- 10 TB capacity
- Shared between 20 VMs

### Solution

**1. Create High Scale SSD Filestore:**

```bash
gcloud filestore instances create media-storage \
  --tier=HIGH_SCALE_SSD \
  --file-share=name=media,capacity=10TB \
  --network=name=production-vpc \
  --zone=us-central1-a
```

**2. Create VM template with auto-mount:**

```bash
# Create startup script
cat > mount-filestore.sh <<'EOF'
#!/bin/bash
apt-get update
apt-get install -y nfs-common
mkdir -p /mnt/media
echo "10.0.0.2:/media /mnt/media nfs defaults,_netdev,hard 0 0" >> /etc/fstab
mount /mnt/media
EOF

# Create instance template
gcloud compute instance-templates create editor-template \
  --machine-type=n2-standard-16 \
  --metadata-from-file=startup-script=mount-filestore.sh \
  --network=production-vpc \
  --zone=us-central1-a
```

**3. Create instance group:**

```bash
gcloud compute instance-groups managed create editors \
  --template=editor-template \
  --size=20 \
  --zone=us-central1-a
```

**4. Configure backup:**

```bash
# Daily snapshots
gcloud filestore backups create media-backup-$(date +%Y%m%d) \
  --instance=media-storage \
  --instance-zone=us-central1-a \
  --file-share=media \
  --region=us-central1
```

### Results

**Performance:**

```
10 TB High Scale SSD:
- Throughput: 12 GB/s (sufficient for 4K video)
- IOPS: 1M (handles concurrent access)
- Latency: Sub-millisecond
```

**Cost (monthly):**

```
Storage: 10,240 GB × $0.35 = $3,584
Snapshots: 10,240 GB × $0.12 = $1,229 (if full backup)
Total: ~$4,813/month
```

**Benefits:**

- ✅ All editors access same files
- ✅ No file copying between VMs
- ✅ Standard Linux permissions
- ✅ High performance for 4K editing
- ✅ Easy scaling

---

## Filestore vs Alternatives

### Filestore vs Cloud Storage

| Feature | Filestore | Cloud Storage |
|---------|-----------|---------------|
| **Protocol** | NFS | HTTP/REST |
| **Access** | POSIX filesystem | Object storage |
| **Latency** | Low (ms) | Higher |
| **Use Case** | Shared files | Object storage |
| **Price** | Higher | Lower |

**When to use Filestore:**

- ✅ Need POSIX filesystem
- ✅ Multiple VMs accessing same files
- ✅ Low latency required
- ✅ File locking needed

**When to use Cloud Storage:**

- ✅ Object storage
- ✅ HTTP access
- ✅ Cost-sensitive
- ✅ Archival storage

---

### Filestore vs Persistent Disk

| Feature | Filestore | Persistent Disk |
|---------|-----------|-----------------|
| **Access** | Multiple VMs | Single VM |
| **Protocol** | NFS | Block device |
| **Sharing** | Yes | No |
| **Performance** | Good | Better |
| **Use Case** | Shared files | VM disks |

**When to use Filestore:**

- ✅ Multiple VMs need same data
- ✅ Shared application data
- ✅ Content management systems

**When to use Persistent Disk:**

- ✅ Single VM storage
- ✅ Database storage
- ✅ Boot disks

---

## Cross-References

**[Module 02 - Storage Services](../02-gcp-core-services/storage-services.md)**

- Storage types overview
- Decision tree for storage selection

**[Module 03 - Disks and Images](../03-compute-engine/disks-and-images.md)**

- Persistent Disks comparison
- Storage performance

**[Module 04 - GKE Workloads](../04-kubernetes-engine/workloads.md)**

- PersistentVolumes in GKE
- Storage classes

**[Module 07 - Cloud Storage](cloud-storage.md)**

- Object storage comparison
- Storage classes

**[Module 11 - Monitoring](../11-monitoring-logging/cloud-monitoring.md)**

- Filestore metrics
- Performance monitoring

---

> ⚠️ **Важливо для іспиту**: Розуміння коли використовувати Filestore vs Cloud Storage vs Persistent Disk критично важливе. Filestore - це NFS для shared access між кількома VMs, не плутати з object storage або block storage.

---

**Повернутися до:** [Модуль 07 - Storage](README.md)
