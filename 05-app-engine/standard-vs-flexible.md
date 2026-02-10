# Standard vs Flexible

## Вступ

**App Engine** — це fully managed serverless platform для deploying applications. Розуміння різниці між Standard та Flexible environments критично важливе для вибору правильного environment.

### Що таке App Engine?

**App Engine** — це Platform as a Service (PaaS):

- Fully managed infrastructure
- Automatic scaling
- Built-in services (Memcache, Task Queues, Cron)
- Multiple runtime support
- Zero server management

### Два Environment Types

1. **Standard Environment:** Sandbox execution, fast startup
2. **Flexible Environment:** Docker containers, more control

### Зв'язок з іншими модулями

- **[Module 03 - Compute Engine](../03-compute-engine/README.md):** IaaS alternative
- **[Module 04 - Kubernetes Engine](../04-kubernetes-engine/README.md):** Container orchestration
- **[Module 06 - Cloud Functions](../06-cloud-functions/README.md):** Serverless functions
- **[Module 09 - Networking](../09-networking/README.md):** VPC and load balancing

---

## Standard Environment

### Architecture

**Sandbox execution environment:**

- Pre-configured runtime
- Restricted system access
- Fast instance startup (milliseconds)
- Automatic scaling to zero
- Free tier available

### Supported Runtimes

**First Generation (Python 2.7, PHP 5.5, Go 1.11):**

- Legacy runtimes
- More restrictions
- Being phased out

**Second Generation (Python 3, Java 11/17, Node.js, PHP 7/8, Ruby, Go 1.12+):**

- Modern runtimes
- Fewer restrictions
- Full language support
- Native dependencies allowed

### Key Features

**1. Fast Startup:**

```yaml
# Instance starts in milliseconds
runtime: python39
```

**2. Scale to Zero:**

- No instances when no traffic
- Pay only for actual usage
- Automatic scale up on demand

**3. Free Tier:**

- 28 instance hours/day
- 1 GB outbound data/day
- Shared memcache

**4. Built-in Services:**

- Memcache
- Task Queues
- Scheduled tasks (Cron)
- Users API

### Limitations

**Standard Environment restrictions:**

❌ **Cannot:**

- SSH into instances
- Write to local filesystem (except /tmp)
- Install arbitrary system packages
- Use custom Docker images
- Run background threads (1st gen)

✅ **Can:**

- Use supported runtimes
- Access Google Cloud services
- Use built-in services
- Scale automatically

### Pricing

**Instance hours:**

```
B1 (128 MB): $0.05/hour
B2 (256 MB): $0.10/hour
B4 (512 MB): $0.20/hour
B8 (1024 MB): $0.40/hour
```

**Free tier:**

- 28 B1 instance hours/day
- 1 GB outbound data/day
- 1 GB Cloud Storage

### Use Cases

✅ **Best for:**

- Web applications
- Mobile backends
- RESTful APIs
- Microservices
- Low-traffic applications
- Cost-sensitive workloads

❌ **Not suitable for:**

- Custom system dependencies
- Long-running background tasks
- SSH access required
- Custom Docker images

---

## Flexible Environment

### Architecture

**Docker container execution:**

- Custom or pre-built containers
- Full system access
- Slower startup (minutes)
- Minimum 1 instance always running
- No free tier

### Supported Runtimes

**Pre-configured runtimes:**

- Python 3.7+
- Java 8/11/17
- Node.js
- PHP 7/8
- Ruby
- Go 1.11+
- .NET Core

**Custom runtimes:**

- Any Docker image
- Custom Dockerfile
- Full control over environment

### Key Features

**1. Docker Containers:**

```yaml
runtime: custom
env: flex
```

**2. SSH Access:**

```bash
gcloud app instances ssh [INSTANCE] --service=[SERVICE] --version=[VERSION]
```

**3. Custom Dependencies:**

- Install any system package
- Use custom libraries
- Full filesystem access

**4. Background Threads:**

- Long-running processes
- Background workers
- Websockets

### Limitations

**Flexible Environment characteristics:**

❌ **Cannot:**

- Scale to zero (min 1 instance)
- Use free tier
- Start instantly (minutes startup)

✅ **Can:**

- SSH into instances
- Write to local filesystem
- Install system packages
- Use custom Docker images
- Run background threads
- Use websockets

### Pricing

**vCPU and memory:**

```
vCPU: $0.0526/hour
Memory (GB): $0.0071/hour

Example (1 vCPU, 2 GB):
$0.0526 + (2 × $0.0071) = $0.0668/hour
≈ $48/month (always running)
```

**No free tier!**

### Use Cases

✅ **Best for:**

- Applications with custom dependencies
- Microservices requiring SSH access
- Applications using websockets
- Background processing
- Custom Docker images
- Applications needing specific system packages

❌ **Not suitable for:**

- Low-traffic applications (cost)
- Applications needing instant startup
- Cost-sensitive workloads
- Simple web apps

---

## Detailed Comparison

### Startup Time

| Environment | Startup Time | Reason |
|-------------|--------------|--------|
| **Standard** | Milliseconds | Pre-warmed sandbox |
| **Flexible** | Minutes | Docker container initialization |

### Scaling

| Feature | Standard | Flexible |
|---------|----------|----------|
| **Scale to zero** | ✅ Yes | ❌ No (min 1) |
| **Auto-scaling** | ✅ Automatic | ✅ Automatic |
| **Manual scaling** | ✅ Supported | ✅ Supported |
| **Max instances** | 1000+ | Limited by quota |
| **Scaling speed** | Instant | Slow (minutes) |

### Runtime Support

| Feature | Standard | Flexible |
|---------|----------|----------|
| **Pre-configured runtimes** | ✅ Limited | ✅ More options |
| **Custom runtimes** | ❌ No | ✅ Yes (Docker) |
| **System packages** | ❌ Limited | ✅ Full access |
| **Native dependencies** | ⚠️ 2nd gen only | ✅ Yes |

### System Access

| Feature | Standard | Flexible |
|---------|----------|----------|
| **SSH access** | ❌ No | ✅ Yes |
| **Filesystem write** | ⚠️ /tmp only | ✅ Full access |
| **Background threads** | ⚠️ 2nd gen only | ✅ Yes |
| **Websockets** | ❌ No | ✅ Yes |
| **Custom Docker** | ❌ No | ✅ Yes |

### Pricing

| Feature | Standard | Flexible |
|---------|----------|----------|
| **Billing model** | Instance hours | vCPU + Memory |
| **Free tier** | ✅ 28 hours/day | ❌ No |
| **Minimum cost** | $0 (scales to 0) | ~$48/month |
| **Cost for low traffic** | Very low | High |
| **Cost for high traffic** | Medium | Medium-High |

### Built-in Services

| Service | Standard | Flexible |
|---------|----------|----------|
| **Memcache** | ✅ Built-in | ⚠️ Via Redis |
| **Task Queues** | ✅ Built-in | ⚠️ Via Cloud Tasks |
| **Cron** | ✅ Built-in | ✅ Built-in |
| **Users API** | ✅ Yes | ❌ No |

---

## Практичний сценарій: Environment Selection

### Scenario 1: Simple Web Application

**Requirements:**

- Python Flask web app
- Low traffic (100 requests/day)
- Standard dependencies
- Cost-sensitive

**Recommendation:** **Standard Environment**

**Reasoning:**

- ✅ Fast startup for sporadic traffic
- ✅ Scales to zero (no cost when idle)
- ✅ Free tier covers usage
- ✅ Python 3.9 supported

**Configuration:**

```yaml
runtime: python39
entrypoint: gunicorn -b :$PORT main:app

automatic_scaling:
  min_instances: 0
  max_instances: 5
```

### Scenario 2: Microservice with Custom Dependencies

**Requirements:**

- Node.js API
- Custom system libraries (ImageMagick)
- Moderate traffic (1000 requests/hour)
- Needs SSH for debugging

**Recommendation:** **Flexible Environment**

**Reasoning:**

- ✅ Custom system packages (ImageMagick)
- ✅ SSH access for debugging
- ✅ Full filesystem access
- ⚠️ Higher cost acceptable for requirements

**Configuration:**

```yaml
runtime: nodejs
env: flex

automatic_scaling:
  min_num_instances: 2
  max_num_instances: 10
  cpu_utilization:
    target_utilization: 0.6
```

### Scenario 3: Real-time Chat Application

**Requirements:**

- WebSocket support
- Real-time bidirectional communication
- Background message processing

**Recommendation:** **Flexible Environment**

**Reasoning:**

- ✅ WebSocket support
- ✅ Background threads
- ✅ Long-running connections
- ❌ Standard doesn't support WebSockets

**Configuration:**

```yaml
runtime: nodejs
env: flex

network:
  session_affinity: true

automatic_scaling:
  min_num_instances: 2
  max_num_instances: 20
```

### Scenario 4: Mobile Backend API

**Requirements:**

- RESTful API
- High traffic (10,000 requests/hour)
- Standard Python libraries
- Cost optimization important

**Recommendation:** **Standard Environment**

**Reasoning:**

- ✅ Fast auto-scaling for traffic spikes
- ✅ Cost-effective for API workloads
- ✅ No custom dependencies needed
- ✅ Built-in services (Memcache, Task Queues)

**Configuration:**

```yaml
runtime: python39

automatic_scaling:
  min_instances: 2
  max_instances: 50
  target_cpu_utilization: 0.65
  target_throughput_utilization: 0.75
```

---

## Migration Considerations

### Standard → Flexible

**When to migrate:**

- Need custom system packages
- Require SSH access
- Need WebSocket support
- Long-running background tasks

**Challenges:**

- Higher cost (always-on instances)
- Slower startup time
- Need to handle built-in services differently

### Flexible → Standard

**When to migrate:**

- Reduce costs (low traffic)
- Faster startup needed
- No custom dependencies
- Want free tier

**Challenges:**

- Remove custom system packages
- Adapt to sandbox restrictions
- Rewrite background tasks as Cloud Tasks

---

## Best Practices

### Standard Environment

✅ **DO:**

- Use for cost-sensitive applications
- Leverage free tier
- Use built-in services (Memcache, Task Queues)
- Configure appropriate instance class
- Use 2nd generation runtimes

❌ **DON'T:**

- Don't use for custom dependencies
- Don't expect SSH access
- Don't write to filesystem (except /tmp)
- Don't use 1st generation runtimes

### Flexible Environment

✅ **DO:**

- Use for custom requirements
- Optimize Docker image size
- Set appropriate min/max instances
- Use health checks
- Monitor costs closely

❌ **DON'T:**

- Don't use for simple web apps (cost)
- Don't ignore startup time
- Don't forget minimum instance cost
- Don't over-provision resources

---

## Exam Tips

> ⚠️ **Важливо для іспиту:**

1. **Standard Environment:**
   - Fast startup (milliseconds)
   - Scales to zero
   - Free tier available
   - Sandbox restrictions
   - Best for: simple web apps, APIs, low traffic

2. **Flexible Environment:**
   - Docker containers
   - SSH access
   - Custom dependencies
   - Minimum 1 instance (no scale to zero)
   - No free tier
   - Best for: custom requirements, WebSockets

3. **Key Differences:**
   - Startup: Standard (ms) vs Flexible (minutes)
   - Scaling: Standard (to 0) vs Flexible (min 1)
   - Cost: Standard (free tier) vs Flexible (always paid)
   - Access: Standard (no SSH) vs Flexible (SSH)
   - Docker: Standard (no) vs Flexible (yes)

4. **Common Scenarios:**
   - Low traffic + cost-sensitive → Standard
   - Custom dependencies → Flexible
   - WebSockets → Flexible
   - Simple REST API → Standard
   - Need SSH → Flexible
   - Free tier → Standard only

5. **Pricing:**
   - Standard: Instance hours
   - Flexible: vCPU + Memory
   - Standard has free tier
   - Flexible minimum ~$48/month

---

**Повернутися до:** [Модуль 05 - App Engine](README.md)
