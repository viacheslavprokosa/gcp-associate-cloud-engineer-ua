# Deployment

## app.yaml

```yaml
runtime: python39
entrypoint: gunicorn -b :$PORT main:app

automatic_scaling:
  min_instances: 1
  max_instances: 10
```

## Deployment Commands

```bash
# Deploy
gcloud app deploy

# Deploy specific version
gcloud app deploy --version=v2 --no-promote

# Traffic splitting
gcloud app services set-traffic default --splits=v1=0.9,v2=0.1

# View logs
gcloud app logs tail
```

**Повернутися до:** [Модуль 05 - App Engine](README.md)
