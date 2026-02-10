# Deployment Manager

## Fundamentals

**Deployment Manager** - Infrastructure as Code (IaC) сервіс для автоматизації створення та управління GCP ресурсами.

### Key Concepts

- **Configuration**: YAML файл з описом ресурсів
- **Template**: Reusable configuration patterns (Python або Jinja2)
- **Deployment**: Instance of configuration
- **Manifest**: Expanded configuration з всіма ресурсами

---

## Infrastructure as Code (IaC)

### Переваги IaC

**1. Version Control:**

```bash
git log deployment.yaml
# Track all infrastructure changes
```

**2. Repeatability:**

```bash
# Same configuration → Same infrastructure
gcloud deployment-manager deployments create prod --config=deployment.yaml
```

**3. Automation:**

```bash
# No manual clicking in Console
# Automated deployments via CI/CD
```

**4. Documentation:**

```yaml
# Configuration = Documentation
# Self-documenting infrastructure
```

---

## Configuration Files (YAML)

### Basic Structure

```yaml
resources:
- name: RESOURCE_NAME
  type: RESOURCE_TYPE
  properties:
    PROPERTY_NAME: PROPERTY_VALUE
```

### Example: Compute Engine VM

```yaml
resources:
- name: my-vm
  type: compute.v1.instance
  properties:
    zone: us-central1-a
    machineType: zones/us-central1-a/machineTypes/e2-medium
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: projects/debian-cloud/global/images/family/debian-11
    networkInterfaces:
    - network: global/networks/default
      accessConfigs:
      - name: External NAT
        type: ONE_TO_ONE_NAT
```

### Example: Cloud Storage Bucket

```yaml
resources:
- name: my-bucket
  type: storage.v1.bucket
  properties:
    location: US
    storageClass: STANDARD
```

---

## Templates

**Templates** - reusable configuration patterns.

### Jinja2 Template

**vm-template.jinja:**

```jinja
resources:
- name: {{ env["name"] }}
  type: compute.v1.instance
  properties:
    zone: {{ properties["zone"] }}
    machineType: zones/{{ properties["zone"] }}/machineTypes/{{ properties["machineType"] }}
    disks:
    - deviceName: boot
      type: PERSISTENT
      boot: true
      autoDelete: true
      initializeParams:
        sourceImage: {{ properties["image"] }}
    networkInterfaces:
    - network: global/networks/default
      accessConfigs:
      - name: External NAT
        type: ONE_TO_ONE_NAT
```

**vm-template.jinja.schema:**

```yaml
info:
  title: VM Template
  description: Creates a Compute Engine VM

imports:
- path: vm-template.jinja

required:
- zone
- machineType
- image

properties:
  zone:
    type: string
    description: Zone for the VM
  machineType:
    type: string
    description: Machine type
  image:
    type: string
    description: Boot disk image
```

**Using Template:**

```yaml
imports:
- path: vm-template.jinja

resources:
- name: web-server
  type: vm-template.jinja
  properties:
    zone: us-central1-a
    machineType: e2-medium
    image: projects/debian-cloud/global/images/family/debian-11
```

---

## Python Templates

**vm-template.py:**

```python
def GenerateConfig(context):
    """Generate VM configuration."""
    resources = [{
        'name': context.env['name'],
        'type': 'compute.v1.instance',
        'properties': {
            'zone': context.properties['zone'],
            'machineType': 'zones/{}/machineTypes/{}'.format(
                context.properties['zone'],
                context.properties['machineType']
            ),
            'disks': [{
                'deviceName': 'boot',
                'type': 'PERSISTENT',
                'boot': True,
                'autoDelete': True,
                'initializeParams': {
                    'sourceImage': context.properties['image']
                }
            }],
            'networkInterfaces': [{
                'network': 'global/networks/default',
                'accessConfigs': [{
                    'name': 'External NAT',
                    'type': 'ONE_TO_ONE_NAT'
                }]
            }]
        }
    }]
    return {'resources': resources}
```

**Using Python Template:**

```yaml
imports:
- path: vm-template.py

resources:
- name: web-server
  type: vm-template.py
  properties:
    zone: us-central1-a
    machineType: e2-medium
    image: projects/debian-cloud/global/images/family/debian-11
```

---

## Deployment Commands

### Create Deployment

```bash
gcloud deployment-manager deployments create my-deployment \
  --config=deployment.yaml
```

### Update Deployment

```bash
gcloud deployment-manager deployments update my-deployment \
  --config=deployment.yaml
```

### Delete Deployment

```bash
gcloud deployment-manager deployments delete my-deployment
```

### List Deployments

```bash
gcloud deployment-manager deployments list
```

### Describe Deployment

```bash
gcloud deployment-manager deployments describe my-deployment
```

### Preview Changes

```bash
gcloud deployment-manager deployments create my-deployment \
  --config=deployment.yaml \
  --preview
```

---

## Practical Scenario: Multi-Tier Web Application

### Scenario

Deploy web application з:

- Load Balancer
- 2 VM instances (web servers)
- Cloud SQL database
- Cloud Storage bucket

### Solution

**deployment.yaml:**

```yaml
imports:
- path: vm-template.jinja

resources:
# Cloud Storage Bucket
- name: app-bucket
  type: storage.v1.bucket
  properties:
    location: US
    storageClass: STANDARD

# Cloud SQL Instance
- name: app-database
  type: sqladmin.v1beta4.instance
  properties:
    region: us-central1
    databaseVersion: MYSQL_8_0
    settings:
      tier: db-n1-standard-1
      backupConfiguration:
        enabled: true
        binaryLogEnabled: true

# VM Instance 1
- name: web-server-1
  type: vm-template.jinja
  properties:
    zone: us-central1-a
    machineType: e2-medium
    image: projects/debian-cloud/global/images/family/debian-11

# VM Instance 2
- name: web-server-2
  type: vm-template.jinja
  properties:
    zone: us-central1-b
    machineType: e2-medium
    image: projects/debian-cloud/global/images/family/debian-11

# Instance Group
- name: web-server-group
  type: compute.v1.instanceGroup
  properties:
    zone: us-central1-a
    network: global/networks/default

# Health Check
- name: web-health-check
  type: compute.v1.httpHealthCheck
  properties:
    port: 80
    requestPath: /health

# Backend Service
- name: web-backend
  type: compute.v1.backendService
  properties:
    protocol: HTTP
    healthChecks:
    - $(ref.web-health-check.selfLink)
    backends:
    - group: $(ref.web-server-group.selfLink)

# URL Map
- name: web-url-map
  type: compute.v1.urlMap
  properties:
    defaultService: $(ref.web-backend.selfLink)

# HTTP Proxy
- name: web-http-proxy
  type: compute.v1.targetHttpProxy
  properties:
    urlMap: $(ref.web-url-map.selfLink)

# Forwarding Rule
- name: web-forwarding-rule
  type: compute.v1.globalForwardingRule
  properties:
    IPProtocol: TCP
    portRange: 80
    target: $(ref.web-http-proxy.selfLink)
```

**Deploy:**

```bash
gcloud deployment-manager deployments create web-app \
  --config=deployment.yaml
```

---

## Best Practices

### 1. Use Templates

```yaml
# Good: Reusable template
imports:
- path: vm-template.jinja

resources:
- name: web-1
  type: vm-template.jinja
  properties:
    zone: us-central1-a

# Bad: Duplicate configuration
resources:
- name: web-1
  type: compute.v1.instance
  properties:
    zone: us-central1-a
    # ... 50 lines of config
- name: web-2
  type: compute.v1.instance
  properties:
    zone: us-central1-b
    # ... 50 lines of duplicate config
```

### 2. Use References

```yaml
# Good: Use references
resources:
- name: my-bucket
  type: storage.v1.bucket
  
- name: my-vm
  type: compute.v1.instance
  properties:
    metadata:
      items:
      - key: bucket
        value: $(ref.my-bucket.name)

# Bad: Hardcode values
- name: my-vm
  properties:
    metadata:
      items:
      - key: bucket
        value: my-bucket-12345
```

### 3. Use Schema Files

```yaml
# vm-template.jinja.schema
required:
- zone
- machineType

properties:
  zone:
    type: string
    description: Zone for the VM
```

### 4. Version Control

```bash
git add deployment.yaml
git commit -m "Add web server deployment"
git push
```

### 5. Preview Before Deploy

```bash
# Always preview first
gcloud deployment-manager deployments create my-deployment \
  --config=deployment.yaml \
  --preview

# Review changes, then update
gcloud deployment-manager deployments update my-deployment
```

---

## Deployment Manager vs Terraform

| Feature | Deployment Manager | Terraform |
|---------|-------------------|-----------|
| **Provider** | Google-native | Multi-cloud |
| **Language** | YAML, Jinja2, Python | HCL |
| **State** | Server-side | Local/Remote |
| **Cost** | Free | Free (OSS) |
| **Learning Curve** | Easy | Moderate |
| **GCP Integration** | Excellent | Good |
| **Multi-cloud** | No | Yes |

**When to use Deployment Manager:**

- ✅ GCP-only infrastructure
- ✅ Simple deployments
- ✅ Team familiar with YAML
- ✅ No state management needed

**When to use Terraform:**

- ✅ Multi-cloud infrastructure
- ✅ Complex deployments
- ✅ Advanced state management
- ✅ Large community/modules

---

## Cross-References

**[Module 03 - Compute Engine](../03-compute-engine/vm-instances.md)**

- Creating VMs with Deployment Manager

**[Module 07 - Cloud Storage](../07-storage/cloud-storage.md)**

- Creating buckets with Deployment Manager

**[Module 09 - Networking](../09-networking/vpc.md)**

- Network infrastructure as code

**[Module 12 - Cloud SDK](cloud-sdk.md)**

- gcloud deployment-manager commands

**[Module 12 - Cloud Build](cloud-build.md)**

- Automated deployments with CI/CD

---

> ⚠️ **Важливо для іспиту**: Розуміння основ Infrastructure as Code, YAML configuration syntax, та різниці між Deployment Manager і Terraform критично важливе для ACE exam.

---

**Повернутися до:** [Модуль 12 - Deployment & Management](README.md)
