# IAM Basics

## IAM Policy

```bash
gcloud projects add-iam-policy-binding my-project \
  --member=user:email@example.com \
  --role=roles/viewer
```

## Hierarchy

Organization → Folder → Project → Resource

**Повернутися до:** [Модуль 10 - IAM & Security](README.md)
