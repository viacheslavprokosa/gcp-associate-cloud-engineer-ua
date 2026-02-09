# Deployment Manager

Infrastructure as Code для GCP.

## Template (YAML)

```yaml
resources:
- name: my-vm
  type: compute.v1.instance
  properties:
    zone: us-central1-a
    machineType: zones/us-central1-a/machineTypes/e2-medium
```

**Повернутися до:** [Модуль 12 - Deployment & Management](README.md)
