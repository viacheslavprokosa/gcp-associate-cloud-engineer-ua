# Cloud Build

CI/CD сервіс для автоматизації builds.

## cloudbuild.yaml

```yaml
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', 'gcr.io/$PROJECT_ID/my-image', '.']
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'gcr.io/$PROJECT_ID/my-image']
```

**Повернутися до:** [Модуль 12 - Deployment & Management](README.md)
