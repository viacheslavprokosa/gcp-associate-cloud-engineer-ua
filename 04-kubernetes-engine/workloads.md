# Workloads

## Deployments

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: gcr.io/my-project/my-app:v1
        ports:
        - containerPort: 8080
```

```bash
kubectl apply -f deployment.yaml
kubectl get deployments
kubectl scale deployment my-app --replicas=5
```

---

## Services

### ClusterIP (default)

Внутрішній IP в кластері.

### NodePort

Відкриває порт на кожному node.

### LoadBalancer

Створює зовнішній load balancer.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 8080
```

---

## ConfigMaps

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  database_url: "postgres://..."
  api_key: "abc123"
```

```bash
kubectl create configmap my-config --from-literal=key=value
```

---

## Secrets

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  password: cGFzc3dvcmQxMjM=  # base64 encoded
```

```bash
kubectl create secret generic my-secret --from-literal=password=password123
```

---

**Повернутися до:** [Модуль 04 - Kubernetes Engine](README.md)
