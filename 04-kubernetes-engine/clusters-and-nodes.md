# Clusters and Nodes

## Вступ

**GKE Clusters and Nodes** — це infrastructure layer для running containerized workloads. Розуміння cluster architecture та node management критично важливе для operating production Kubernetes.

### Що таке Cluster?

**Cluster** — це набір Compute Engine VMs (nodes), які run Kubernetes workloads:

- **Control Plane:** Managed by Google (API server, scheduler, etcd)
- **Nodes:** Compute Engine VMs running your containers
- **Node Pools:** Groups of nodes з однаковою конфігурацією

### Навіщо потрібні Node Pools?

1. **Workload Isolation:** Різні workloads на різних node types
2. **Cost Optimization:** Mix of machine types
3. **Scaling Flexibility:** Independent scaling per pool
4. **Upgrade Control:** Gradual upgrades per pool

### Зв'язок з іншими модулями

- **[Module 04 - GKE Basics](gke-basics.md):** GKE fundamentals
- **[Module 03 - Compute Engine](../03-compute-engine/README.md):** Node VMs
- **[Module 09 - Networking](../09-networking/README.md):** Cluster networking
- **[Module 10 - IAM & Security](../10-iam-security/README.md):** Node service accounts

---

## Cluster Types

### Zonal Cluster

**Control plane in single zone:**

```bash
gcloud container clusters create zonal-cluster \
  --zone=us-central1-a \
  --num-nodes=3
```

**Characteristics:**

- Control plane in one zone
- Nodes in one zone
- **SLA:** 99.5% uptime
- **Cost:** Lower
- **Use case:** Development, testing

**Pros:**

- ✅ Lower cost
- ✅ Simpler configuration
- ✅ Faster cluster operations

**Cons:**

- ❌ Single point of failure
- ❌ Lower availability
- ❌ Zone outage affects entire cluster

### Multi-Zonal Cluster

**Nodes across multiple zones:**

```bash
gcloud container clusters create multi-zonal-cluster \
  --zone=us-central1-a \
  --node-locations=us-central1-a,us-central1-b,us-central1-c \
  --num-nodes=3
```

**Characteristics:**

- Control plane in one zone
- Nodes distributed across zones
- **SLA:** 99.5% uptime (control plane single zone)
- **Cost:** Medium
- **Use case:** Better availability than zonal

**Pros:**

- ✅ Node distribution across zones
- ✅ Automatic zone balancing
- ✅ Survives single zone failure (for workloads)

**Cons:**

- ❌ Control plane still single zone
- ❌ Control plane outage affects cluster

### Regional Cluster

**Control plane and nodes across zones:**

```bash
gcloud container clusters create regional-cluster \
  --region=us-central1 \
  --num-nodes=3  # per zone (total 9 nodes)
```

**Characteristics:**

- Control plane replicated across 3 zones
- Nodes distributed across 3 zones
- **SLA:** 99.95% uptime
- **Cost:** Higher (3x control plane)
- **Use case:** Production workloads

**Pros:**

- ✅ Highest availability
- ✅ Control plane survives zone failure
- ✅ Recommended for production
- ✅ Automatic failover

**Cons:**

- ❌ Higher cost
- ❌ More complex networking

### Cluster Type Comparison

| Feature | Zonal | Multi-Zonal | Regional |
|---------|-------|-------------|----------|
| **Control plane zones** | 1 | 1 | 3 |
| **Node zones** | 1 | Multiple | 3 |
| **SLA** | 99.5% | 99.5% | 99.95% |
| **Cost** | $ | $$ | $$$ |
| **Production ready** | No | Maybe | Yes |
| **Zone failure** | Full outage | Partial | Resilient |

> ⚠️ **Best Practice:** Use regional clusters for production workloads.

---

## Node Pools

### What are Node Pools?

**Node pool** — це група nodes з identical configuration:

- Same machine type
- Same disk configuration
- Same labels and taints
- Same auto-scaling settings
- Independent lifecycle

### Creating Node Pools

**Default node pool (created with cluster):**

```bash
gcloud container clusters create my-cluster \
  --zone=us-central1-a \
  --num-nodes=3 \
  --machine-type=e2-medium
```

**Additional node pool:**

```bash
gcloud container node-pools create high-mem-pool \
  --cluster=my-cluster \
  --zone=us-central1-a \
  --machine-type=n2-highmem-8 \
  --num-nodes=2 \
  --disk-size=100GB \
  --disk-type=pd-ssd
```

### Node Pool Use Cases

**1. Different workload types:**

```bash
# General workloads
gcloud container node-pools create general-pool \
  --cluster=my-cluster \
  --machine-type=e2-standard-4 \
  --num-nodes=3

# CPU-intensive workloads
gcloud container node-pools create cpu-pool \
  --cluster=my-cluster \
  --machine-type=c2-standard-8 \
  --num-nodes=2

# Memory-intensive workloads
gcloud container node-pools create memory-pool \
  --cluster=my-cluster \
  --machine-type=n2-highmem-8 \
  --num-nodes=2
```

**2. GPU workloads:**

```bash
gcloud container node-pools create gpu-pool \
  --cluster=my-cluster \
  --machine-type=n1-standard-4 \
  --accelerator=type=nvidia-tesla-t4,count=1 \
  --num-nodes=1
```

**3. Preemptible nodes (cost optimization):**

```bash
gcloud container node-pools create preemptible-pool \
  --cluster=my-cluster \
  --machine-type=e2-standard-4 \
  --preemptible \
  --num-nodes=5
```

### Node Pool Management

**List node pools:**

```bash
gcloud container node-pools list \
  --cluster=my-cluster \
  --zone=us-central1-a
```

**Describe node pool:**

```bash
gcloud container node-pools describe high-mem-pool \
  --cluster=my-cluster \
  --zone=us-central1-a
```

**Resize node pool:**

```bash
gcloud container node-pools resize high-mem-pool \
  --cluster=my-cluster \
  --zone=us-central1-a \
  --num-nodes=5
```

**Delete node pool:**

```bash
gcloud container node-pools delete high-mem-pool \
  --cluster=my-cluster \
  --zone=us-central1-a
```

---

## Node Taints and Tolerations

### What are Taints?

**Taints** prevent pods from scheduling on nodes unless they have matching tolerations.

### Adding Taints

```bash
gcloud container node-pools create dedicated-pool \
  --cluster=my-cluster \
  --machine-type=n2-standard-8 \
  --num-nodes=2 \
  --node-taints=workload=database:NoSchedule
```

### Using Tolerations

**Pod with toleration:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: database-pod
spec:
  tolerations:
  - key: "workload"
    operator: "Equal"
    value: "database"
    effect: "NoSchedule"
  containers:
  - name: postgres
    image: postgres:14
```

### Common Taint Use Cases

**1. Dedicated nodes for specific workloads:**

```bash
# Database nodes
gcloud container node-pools create db-pool \
  --node-taints=dedicated=database:NoSchedule

# ML training nodes
gcloud container node-pools create ml-pool \
  --node-taints=dedicated=ml:NoSchedule
```

**2. Preemptible nodes:**

```bash
gcloud container node-pools create preemptible-pool \
  --preemptible \
  --node-taints=preemptible=true:NoSchedule
```

---

## Cluster Autoscaling

### Cluster Autoscaler

**Automatically adds/removes nodes based on pod demands:**

```bash
# Enable on new cluster
gcloud container clusters create autoscaling-cluster \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=10 \
  --zone=us-central1-a

# Enable on existing cluster
gcloud container clusters update my-cluster \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=10 \
  --zone=us-central1-a
```

### Per-Node-Pool Autoscaling

```bash
gcloud container node-pools create autoscaling-pool \
  --cluster=my-cluster \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=5 \
  --zone=us-central1-a
```

### How Cluster Autoscaler Works

**Scale Up:**

1. Pods cannot be scheduled (insufficient resources)
2. Cluster Autoscaler detects pending pods
3. New nodes are added to the cluster
4. Pods are scheduled on new nodes

**Scale Down:**

1. Nodes are underutilized (< 50% for 10 minutes)
2. Pods can be moved to other nodes
3. Node is drained and deleted
4. Cluster size reduced

### Autoscaling Configuration

```bash
gcloud container clusters update my-cluster \
  --enable-autoscaling \
  --min-nodes=2 \
  --max-nodes=20 \
  --zone=us-central1-a \
  --autoscaling-profile=optimize-utilization
```

**Autoscaling profiles:**

- `balanced`: Default, balanced scaling
- `optimize-utilization`: Aggressive scale-down

---

## Node Auto-Repair and Auto-Upgrade

### Node Auto-Repair

**Automatically repairs unhealthy nodes:**

```bash
gcloud container node-pools create auto-repair-pool \
  --cluster=my-cluster \
  --enable-autorepair \
  --zone=us-central1-a
```

**How it works:**

1. Node health check fails
2. Node marked as unhealthy
3. Node is drained (pods evicted)
4. Node is recreated
5. Pods rescheduled

### Node Auto-Upgrade

**Automatically upgrades nodes to match control plane:**

```bash
gcloud container node-pools create auto-upgrade-pool \
  --cluster=my-cluster \
  --enable-autoupgrade \
  --zone=us-central1-a
```

**How it works:**

1. Control plane upgraded
2. Auto-upgrade triggers for nodes
3. Nodes upgraded one by one
4. Pods rescheduled during upgrade

### Maintenance Windows

**Control when upgrades happen:**

```bash
gcloud container clusters create my-cluster \
  --maintenance-window-start=2023-01-01T00:00:00Z \
  --maintenance-window-duration=4h \
  --maintenance-window-recurrence="FREQ=WEEKLY;BYDAY=SU" \
  --zone=us-central1-a
```

---

## Release Channels

### What are Release Channels?

**Release channels** control Kubernetes version updates:

- **Rapid:** Latest features, frequent updates
- **Regular:** Balanced updates (recommended)
- **Stable:** Conservative updates

### Creating Cluster with Release Channel

```bash
gcloud container clusters create my-cluster \
  --release-channel=regular \
  --zone=us-central1-a
```

### Release Channel Comparison

| Channel | Update Frequency | Use Case |
|---------|-----------------|----------|
| **Rapid** | Weekly | Testing, early adopters |
| **Regular** | Monthly | Production (recommended) |
| **Stable** | Quarterly | Conservative production |

### Changing Release Channel

```bash
gcloud container clusters update my-cluster \
  --release-channel=stable \
  --zone=us-central1-a
```

---

## Node Upgrades

### Manual Node Upgrade

```bash
# Upgrade control plane first
gcloud container clusters upgrade my-cluster \
  --master \
  --cluster-version=1.27.3-gke.100 \
  --zone=us-central1-a

# Upgrade nodes
gcloud container clusters upgrade my-cluster \
  --zone=us-central1-a
```

### Node Pool Upgrade

```bash
gcloud container node-pools upgrade my-pool \
  --cluster=my-cluster \
  --zone=us-central1-a
```

### Surge Upgrades

**Control upgrade speed:**

```bash
gcloud container node-pools update my-pool \
  --cluster=my-cluster \
  --max-surge-upgrade=3 \
  --max-unavailable-upgrade=1 \
  --zone=us-central1-a
```

**Parameters:**

- `--max-surge-upgrade`: Extra nodes during upgrade
- `--max-unavailable-upgrade`: Max unavailable nodes

---

## Node Metadata and Labels

### Node Labels

**Add labels to nodes:**

```bash
gcloud container node-pools create labeled-pool \
  --cluster=my-cluster \
  --node-labels=environment=production,team=backend \
  --zone=us-central1-a
```

**Use in pod scheduling:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: backend-pod
spec:
  nodeSelector:
    environment: production
    team: backend
  containers:
  - name: app
    image: gcr.io/my-project/backend
```

### Node Metadata

**Add custom metadata:**

```bash
gcloud container node-pools create metadata-pool \
  --cluster=my-cluster \
  --metadata=key1=value1,key2=value2 \
  --zone=us-central1-a
```

---

## Практичний сценарій: Multi-Tier Application

### Вимоги

1. Web tier (3-10 nodes, e2-standard-4)
2. Application tier (2-8 nodes, n2-standard-8)
3. Database tier (2 nodes, n2-highmem-16, dedicated)
4. Batch processing (0-20 preemptible nodes)

### Implementation

```bash
# Create regional cluster
gcloud container clusters create multi-tier-cluster \
  --region=us-central1 \
  --num-nodes=1 \
  --machine-type=e2-small \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=3 \
  --release-channel=regular \
  --enable-autorepair \
  --enable-autoupgrade

# Web tier node pool
gcloud container node-pools create web-pool \
  --cluster=multi-tier-cluster \
  --region=us-central1 \
  --machine-type=e2-standard-4 \
  --enable-autoscaling \
  --min-nodes=3 \
  --max-nodes=10 \
  --node-labels=tier=web

# Application tier node pool
gcloud container node-pools create app-pool \
  --cluster=multi-tier-cluster \
  --region=us-central1 \
  --machine-type=n2-standard-8 \
  --enable-autoscaling \
  --min-nodes=2 \
  --max-nodes=8 \
  --node-labels=tier=application

# Database tier node pool (dedicated)
gcloud container node-pools create db-pool \
  --cluster=multi-tier-cluster \
  --region=us-central1 \
  --machine-type=n2-highmem-16 \
  --num-nodes=2 \
  --node-labels=tier=database \
  --node-taints=dedicated=database:NoSchedule

# Batch processing pool (preemptible)
gcloud container node-pools create batch-pool \
  --cluster=multi-tier-cluster \
  --region=us-central1 \
  --machine-type=e2-standard-8 \
  --preemptible \
  --enable-autoscaling \
  --min-nodes=0 \
  --max-nodes=20 \
  --node-labels=tier=batch \
  --node-taints=preemptible=true:NoSchedule
```

---

## Best Practices

### Cluster Design

✅ **DO:**

- Use regional clusters for production
- Enable auto-repair and auto-upgrade
- Use release channels
- Set maintenance windows
- Plan for zone failures

❌ **DON'T:**

- Don't use zonal clusters for production
- Don't disable auto-repair
- Don't manually manage versions
- Don't ignore upgrade notifications

### Node Pools

✅ **DO:**

- Create separate pools for different workload types
- Use taints for dedicated pools
- Enable autoscaling per pool
- Use appropriate machine types
- Label nodes for scheduling

❌ **DON'T:**

- Don't use single node pool for all workloads
- Don't over-provision nodes
- Don't mix workload types on same pool
- Don't forget to set resource limits

### Autoscaling

✅ **DO:**

- Set realistic min/max nodes
- Use `optimize-utilization` profile for cost savings
- Monitor autoscaling events
- Test autoscaling behavior
- Set pod resource requests/limits

❌ **DON'T:**

- Don't set min=max (defeats purpose)
- Don't autoscale without resource limits
- Don't ignore pending pods
- Don't forget about costs

### Upgrades

✅ **DO:**

- Use release channels
- Test upgrades in staging first
- Set maintenance windows
- Monitor upgrade progress
- Plan for pod disruptions

❌ **DON'T:**

- Don't skip versions
- Don't upgrade during peak hours
- Don't disable auto-upgrade in production
- Don't forget to upgrade nodes after control plane

---

## Exam Tips

> ⚠️ **Важливо для іспиту:**

1. **Cluster Types:**
   - Zonal: 99.5% SLA, single zone
   - Regional: 99.95% SLA, 3 zones
   - Use regional for production

2. **Node Pools:**
   - Group nodes with same config
   - Independent scaling
   - Different pools for different workloads
   - Use taints for dedicated pools

3. **Autoscaling:**
   - Cluster Autoscaler: adds/removes nodes
   - Enable per node pool
   - Set min/max nodes
   - Requires pod resource requests

4. **Auto-Repair:**
   - Automatically fixes unhealthy nodes
   - Drains and recreates nodes
   - Enable for production

5. **Auto-Upgrade:**
   - Keeps nodes up to date
   - Follows control plane version
   - Use maintenance windows
   - Enable for production

6. **Release Channels:**
   - Rapid: frequent updates
   - Regular: recommended
   - Stable: conservative

7. **Common Scenarios:**
   - High availability → Regional cluster
   - Different workloads → Multiple node pools
   - Cost optimization → Autoscaling + preemptible
   - Dedicated resources → Taints and tolerations
   - Automatic maintenance → Auto-repair + auto-upgrade

---

**Повернутися до:** [Модуль 04 - Kubernetes Engine](README.md)
