# Deployment

## Function Code (main.py)

```python
def hello_world(request):
    return 'Hello, World!'
```

## Deploy

```bash
gcloud functions deploy hello_world \
  --runtime=python39 \
  --trigger-http \
  --entry-point=hello_world
```

## View Logs

```bash
gcloud functions logs read hello_world
```

**Повернутися до:** [Модуль 06 - Cloud Functions](README.md)
