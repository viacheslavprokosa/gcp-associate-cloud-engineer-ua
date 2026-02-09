# Triggers

## HTTP Triggers

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --allow-unauthenticated
```

## Cloud Storage Triggers

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-resource=my-bucket \
  --trigger-event=google.storage.object.finalize
```

## Pub/Sub Triggers

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-topic=my-topic
```

**Повернутися до:** [Модуль 06 - Cloud Functions](README.md)
