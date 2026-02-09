# Cloud SQL

Керований MySQL, PostgreSQL, SQL Server.

## HA Configuration

- Primary + standby instance
- Автоматичний failover
- SLA 99.95%

```bash
gcloud sql instances create my-instance \
  --database-version=MYSQL_8_0 \
  --tier=db-n1-standard-1
```

**Повернутися до:** [Модуль 08 - Databases](README.md)
