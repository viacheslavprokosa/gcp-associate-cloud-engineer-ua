# Workloads

## Вступ

**Kubernetes Workloads** — це applications running on GKE. Розуміння workload types та їх lifecycle критично важливе для deploying та managing applications.

### Що таке Workload?

**Workload** — це application або service running in Kubernetes:

- **Pods:** Smallest deployable units
- **Deployments:** Stateless applications
- **StatefulSets:** Stateful applications
- **DaemonSets:** One pod per node
- **Jobs/CronJobs:** Batch processing

### Навіщо потрібні різні Workload Types?

1. **Stateless Apps:** Deployments для web servers
2. **Stateful Apps:** StatefulSets для databases
3. **Background Tasks:** Jobs для batch processing
4. **Node-level Services:** DaemonSets для logging agents

### Зв'язок з іншими модулями

- **[Module 04 - GKE Basics](gke-basics.md):** GKE fundamentals
- **[Module 04 - Clusters and Nodes](clusters-and-nodes.md):** Node management
- **[Module 07 - Storage](../07-storage/README.md):** Persistent volumes
- **[Module 09 - Networking](../09-networking/README.md):** Services and ingress

---

## Pods

### What is a Pod?

**Pod** — це smallest deployable unit в Kubernetes:

- One or more containers
- Shared network namespace
- Shared storage volumes
- Ephemeral (not meant to be long-lived)

### Pod Lifecycle

1. **Pending:** Pod accepted, waiting for scheduling
2. **Running:** Pod scheduled, containers running
3. **Succeeded:** All containers terminated successfully
4. **Failed:** At least one container failed
5. **Unknown:** Pod state cannot be determined

### Creating a Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80
```

```bash
kubectl apply -f pod.yaml
kubectl get pods
kubectl describe pod my-pod
kubectl logs my-pod
kubectl delete pod my-pod
```

> ⚠️ **Note:** Pods are rarely created directly. Use Deployments instead.

---

## Deployments

### What is a Deployment?

**Deployment** — це declarative way to manage stateless applications:

- Manages ReplicaSets
- Rolling updates
- Rollback capability
- Self-healing

### Creating a Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
```

### Deployment Commands

```bash
# Create deployment
kubectl apply -f deployment.yaml

# List deployments
kubectl get deployments

# Describe deployment
kubectl describe deployment web-app

# Scale deployment
kubectl scale deployment web-app --replicas=5

# Update image
kubectl set image deployment/web-app nginx=nginx:1.22

# Rollout status
kubectl rollout status deployment/web-app

# Rollout history
kubectl rollout history deployment/web-app

# Rollback
kubectl rollout undo deployment/web-app

# Rollback to specific revision
kubectl rollout undo deployment/web-app --to-revision=2
```

### Rolling Updates

**Strategy:**

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Max extra pods during update
      maxUnavailable: 0  # Max unavailable pods
```

**Update process:**

1. Create new ReplicaSet
2. Scale up new ReplicaSet
3. Scale down old ReplicaSet
4. Repeat until complete

---

## Services

### What is a Service?

**Service** — це stable network endpoint для accessing pods:

- Stable IP address
- DNS name
- Load balancing
- Service discovery

### Service Types

#### 1. ClusterIP (Default)

**Internal cluster IP:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: ClusterIP
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
```

**Use case:** Internal communication between services

#### 2. NodePort

**Exposes service on each node's IP:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-nodeport
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 30080  # 30000-32767
```

**Use case:** Development, testing, direct node access

#### 3. LoadBalancer

**Creates external load balancer:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-lb
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
```

**Use case:** Production external access

#### 4. ExternalName

**Maps service to DNS name:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db
spec:
  type: ExternalName
  externalName: database.example.com
```

**Use case:** External service integration

### Service Discovery

**DNS names:**

- `<service-name>.<namespace>.svc.cluster.local`
- `<service-name>.<namespace>`
- `<service-name>` (same namespace)

**Example:**

```bash
# From pod in same namespace
curl http://web-service

# From pod in different namespace
curl http://web-service.default.svc.cluster.local
```

---

## ConfigMaps

### What is a ConfigMap?

**ConfigMap** — це key-value configuration data:

- Non-sensitive configuration
- Environment variables
- Configuration files
- Command-line arguments

### Creating ConfigMaps

**From literal values:**

```bash
kubectl create configmap app-config \
  --from-literal=database_host=postgres.default \
  --from-literal=database_port=5432
```

**From file:**

```bash
kubectl create configmap app-config \
  --from-file=config.properties
```

**From YAML:**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  database_host: postgres.default
  database_port: "5432"
  app.properties: |
    server.port=8080
    logging.level=INFO
```

### Using ConfigMaps

**As environment variables:**

```yaml
spec:
  containers:
  - name: app
    image: my-app:v1
    env:
    - name: DATABASE_HOST
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: database_host
```

**As volume:**

```yaml
spec:
  containers:
  - name: app
    image: my-app:v1
    volumeMounts:
    - name: config
      mountPath: /etc/config
  volumes:
  - name: config
    configMap:
      name: app-config
```

---

## Secrets

### What is a Secret?

**Secret** — це sensitive data storage:

- Passwords
- API keys
- Certificates
- Base64 encoded (not encrypted!)

### Creating Secrets

**From literal:**

```bash
kubectl create secret generic db-secret \
  --from-literal=username=admin \
  --from-literal=password=secret123
```

**From file:**

```bash
kubectl create secret generic tls-secret \
  --from-file=tls.crt \
  --from-file=tls.key
```

**From YAML:**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  username: YWRtaW4=      # base64: admin
  password: c2VjcmV0MTIz  # base64: secret123
```

### Using Secrets

**As environment variables:**

```yaml
spec:
  containers:
  - name: app
    image: my-app:v1
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
```

**As volume:**

```yaml
spec:
  containers:
  - name: app
    image: my-app:v1
    volumeMounts:
    - name: secret
      mountPath: /etc/secrets
      readOnly: true
  volumes:
  - name: secret
    secret:
      secretName: db-secret
```

> ⚠️ **Security:** Use Google Secret Manager або Workload Identity для production secrets.

---

## StatefulSets

### What is a StatefulSet?

**StatefulSet** — це workload для stateful applications:

- Stable network identity
- Stable persistent storage
- Ordered deployment and scaling
- Ordered rolling updates

### When to Use StatefulSets

- ✅ Databases (MySQL, PostgreSQL, MongoDB)
- ✅ Distributed systems (Kafka, ZooKeeper)
- ✅ Applications requiring stable network identity

### Creating a StatefulSet

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:14
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

### StatefulSet Features

**Stable network identity:**

- `<pod-name>-<ordinal>.<service-name>`
- `postgres-0.postgres`, `postgres-1.postgres`, `postgres-2.postgres`

**Ordered operations:**

- Pods created in order: 0, 1, 2
- Pods deleted in reverse: 2, 1, 0
- Updates in reverse order

---

## DaemonSets

### What is a DaemonSet?

**DaemonSet** — це pod on every node:

- Runs on all nodes (or selected nodes)
- Automatically added to new nodes
- Removed when nodes are deleted

### When to Use DaemonSets

- ✅ Logging agents (Fluentd, Filebeat)
- ✅ Monitoring agents (Prometheus Node Exporter)
- ✅ Network plugins
- ✅ Storage daemons

### Creating a DaemonSet

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
spec:
  selector:
    matchLabels:
      app: fluentd
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd:v1.14
        volumeMounts:
        - name: varlog
          mountPath: /var/log
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
```

---

## Jobs and CronJobs

### Jobs

**One-time batch processing:**

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-import
spec:
  template:
    spec:
      containers:
      - name: import
        image: my-import-tool:v1
        command: ["python", "import.py"]
      restartPolicy: Never
  backoffLimit: 4
```

**Parallel jobs:**

```yaml
spec:
  parallelism: 3      # Run 3 pods in parallel
  completions: 10     # Complete 10 tasks total
```

### CronJobs

**Scheduled batch processing:**

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: backup
spec:
  schedule: "0 2 * * *"  # Every day at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: backup-tool:v1
            command: ["sh", "backup.sh"]
          restartPolicy: OnFailure
```

**Schedule format:** `minute hour day month weekday`

---

## Практичний сценарій: Full Application Stack

### Вимоги

1. Web frontend (3 replicas, LoadBalancer)
2. API backend (5 replicas, ClusterIP)
3. PostgreSQL database (StatefulSet, 3 replicas)
4. Redis cache (Deployment, 1 replica)
5. Daily backup job (CronJob)

### Implementation

**1. PostgreSQL StatefulSet:**

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:14
        env:
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 20Gi
---
apiVersion: v1
kind: Service
metadata:
  name: postgres
spec:
  clusterIP: None  # Headless service
  selector:
    app: postgres
  ports:
  - port: 5432
```

**2. API Backend Deployment:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  replicas: 5
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: gcr.io/my-project/api:v1
        env:
        - name: DATABASE_URL
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: database_url
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: api
spec:
  type: ClusterIP
  selector:
    app: api
  ports:
  - port: 80
    targetPort: 8080
```

**3. Web Frontend Deployment:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: gcr.io/my-project/web:v1
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
```

---

## Best Practices

### Deployments

✅ **DO:**

- Set resource requests and limits
- Use rolling updates
- Define health checks (liveness, readiness)
- Use multiple replicas for HA
- Tag images with versions (not `latest`)

❌ **DON'T:**

- Don't use `latest` tag in production
- Don't skip resource limits
- Don't deploy without health checks
- Don't use single replica for critical apps

### Services

✅ **DO:**

- Use ClusterIP for internal services
- Use LoadBalancer for external access
- Define proper selectors
- Use meaningful service names

### ConfigMaps and Secrets

✅ **DO:**

- Use ConfigMaps for non-sensitive data
- Use Secrets for sensitive data
- Use Google Secret Manager for production
- Mount as volumes for large configs
- Use environment variables for simple values

❌ **DON'T:**

- Don't put sensitive data in ConfigMaps
- Don't commit secrets to git
- Don't use base64 as encryption

---

## Exam Tips

> ⚠️ **Важливо для іспиту:**

1. **Deployments:**
   - Stateless applications
   - Rolling updates and rollbacks
   - ReplicaSets management
   - Self-healing

2. **Services:**
   - ClusterIP: internal only
   - NodePort: development/testing
   - LoadBalancer: production external access
   - DNS: `<service>.<namespace>.svc.cluster.local`

3. **StatefulSets:**
   - Stateful applications (databases)
   - Stable network identity
   - Ordered deployment
   - Persistent storage per pod

4. **ConfigMaps:**
   - Non-sensitive configuration
   - Environment variables or volumes
   - Not encrypted

5. **Secrets:**
   - Sensitive data
   - Base64 encoded (not encrypted!)
   - Use Secret Manager for production

6. **Common Scenarios:**
   - Web app → Deployment + LoadBalancer Service
   - Database → StatefulSet + Headless Service
   - Logging agent → DaemonSet
   - Batch job → Job or CronJob
   - Internal API → Deployment + ClusterIP Service

---

**Повернутися до:** [Модуль 04 - Kubernetes Engine](README.md)
