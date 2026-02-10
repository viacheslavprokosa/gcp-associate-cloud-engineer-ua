# Deployment

## Вступ

**Cloud Functions Deployment** — це процес розгортання serverless функцій у Google Cloud. Розуміння deployment процесу, конфігурації та best practices критично важливе для production deployments.

### Що таке Deployment?

**Deployment** — це завантаження та запуск функції в Cloud Functions:

- Завантаження коду
- Конфігурація runtime
- Налаштування тригерів
- Управління версіями
- Моніторинг та логування

### Ключові концепції

1. **Runtime:** Середовище виконання (Python, Node.js, Go, Java, .NET, Ruby, PHP)
2. **Entry Point:** Функція, яка викликається
3. **Trigger:** Джерело події
4. **Region:** Географічне розташування

### Зв'язок з іншими модулями

- **[Module 06 - Triggers](triggers.md):** Типи тригерів
- **[Module 05 - App Engine](../05-app-engine/README.md):** Альтернативна платформа
- **[Module 12 - Deployment Management](../12-deployment-management/README.md):** CI/CD pipelines

---

## Структура проєкту

### Мінімальний проєкт

**Структура файлів:**

```
my-function/
├── main.py
└── requirements.txt
```

**main.py:**

```python
def hello_world(request):
    """HTTP Cloud Function"""
    return 'Hello, World!'
```

**requirements.txt:**

```
# Залежності (якщо потрібні)
google-cloud-storage==2.10.0
```

### Розширений проєкт

**Структура з модулями:**

```
my-function/
├── main.py
├── requirements.txt
├── utils/
│   ├── __init__.py
│   └── helpers.py
└── config/
    └── settings.py
```

---

## Deployment Commands

### Базове розгортання

**HTTP функція:**

```bash
gcloud functions deploy hello-world \
  --runtime=python39 \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point=hello_world
```

**Pub/Sub функція:**

```bash
gcloud functions deploy process-message \
  --runtime=python39 \
  --trigger-topic=my-topic \
  --entry-point=process_message
```

**Cloud Storage функція:**

```bash
gcloud functions deploy process-file \
  --runtime=python39 \
  --trigger-resource=my-bucket \
  --trigger-event=google.storage.object.finalize \
  --entry-point=process_file
```

### Deployment опції

**Регіон:**

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --region=europe-west1
```

**Пам'ять та timeout:**

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --memory=512MB \
  --timeout=60s
```

**Environment variables:**

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --set-env-vars=DATABASE_URL=postgresql://...,API_KEY=secret123
```

**Service account:**

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --service-account=my-sa@project.iam.gserviceaccount.com
```

---

## Runtimes

### Підтримувані runtimes

**Доступні версії:**

| Runtime | Версії | Рекомендована |
|---------|--------|---------------|
| Python | 3.7, 3.8, 3.9, 3.10, 3.11 | 3.11 |
| Node.js | 14, 16, 18, 20 | 20 |
| Go | 1.16, 1.18, 1.19, 1.20, 1.21 | 1.21 |
| Java | 11, 17 | 17 |
| .NET | 3.1, 6 | 6 |
| Ruby | 2.7, 3.0, 3.1, 3.2 | 3.2 |
| PHP | 7.4, 8.1, 8.2 | 8.2 |

### Вибір runtime

**Python приклад:**

```bash
# Python 3.11 (рекомендовано)
gcloud functions deploy my-function \
  --runtime=python311 \
  --trigger-http
```

**Node.js приклад:**

```bash
# Node.js 20 (рекомендовано)
gcloud functions deploy my-function \
  --runtime=nodejs20 \
  --trigger-http
```

---

## Конфігурація функції

### Пам'ять

**Доступні значення:**

- 128MB (default)
- 256MB
- 512MB
- 1024MB
- 2048MB
- 4096MB
- 8192MB

**Приклад:**

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --memory=1024MB
```

### Timeout

**Діапазон:** 1s - 540s (9 хвилин)

**Приклад:**

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --timeout=300s  # 5 хвилин
```

### Concurrency

**Максимальна кількість одночасних запитів:**

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --max-instances=100 \
  --min-instances=1
```

---

## Environment Variables

### Встановлення змінних

**При deployment:**

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --set-env-vars=DB_HOST=10.0.0.1,DB_PORT=5432,DEBUG=false
```

**Оновлення змінних:**

```bash
gcloud functions deploy my-function \
  --update-env-vars=DEBUG=true
```

**Видалення змінних:**

```bash
gcloud functions deploy my-function \
  --remove-env-vars=DEBUG
```

### Використання в коді

**Python:**

```python
import os

def my_function(request):
    db_host = os.environ.get('DB_HOST')
    db_port = os.environ.get('DB_PORT')
    debug = os.environ.get('DEBUG', 'false') == 'true'
    
    return f'DB: {db_host}:{db_port}, Debug: {debug}'
```

---

## Secret Manager Integration

### Використання секретів

**Створення секрету:**

```bash
echo -n "my-secret-password" | \
  gcloud secrets create database-password --data-file=-
```

**Надання доступу:**

```bash
gcloud secrets add-iam-policy-binding database-password \
  --member=serviceAccount:PROJECT_ID@appspot.gserviceaccount.com \
  --role=roles/secretmanager.secretAccessor
```

**Deployment з секретами:**

```bash
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --set-secrets=DATABASE_PASSWORD=database-password:latest
```

**Використання в коді:**

```python
import os

def my_function(request):
    # Секрет доступний як environment variable
    db_password = os.environ.get('DATABASE_PASSWORD')
    return 'Connected to database'
```

---

## Управління версіями

### Перегляд функцій

```bash
# Список всіх функцій
gcloud functions list

# Деталі функції
gcloud functions describe my-function --region=us-central1
```

### Оновлення функції

```bash
# Оновити код
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http

# Оновити тільки конфігурацію
gcloud functions deploy my-function \
  --memory=1024MB \
  --timeout=120s
```

### Видалення функції

```bash
gcloud functions delete my-function --region=us-central1
```

---

## Логування та моніторинг

### Перегляд логів

**Real-time logs:**

```bash
gcloud functions logs read my-function --limit=50
```

**Follow logs:**

```bash
gcloud functions logs read my-function --limit=50 --follow
```

**Фільтрація за severity:**

```bash
gcloud functions logs read my-function \
  --limit=50 \
  --filter="severity>=ERROR"
```

### Логування в коді

**Python:**

```python
import logging

def my_function(request):
    logging.info('Function started')
    logging.warning('This is a warning')
    logging.error('This is an error')
    
    return 'Done'
```

**Structured logging:**

```python
import json
import logging

def my_function(request):
    log_entry = {
        'severity': 'INFO',
        'message': 'Processing request',
        'user_id': '12345',
        'request_id': request.headers.get('X-Request-ID')
    }
    print(json.dumps(log_entry))
    
    return 'Done'
```

---

## Практичний сценарій: Image Processing Function

### Вимоги

1. Обробка зображень при завантаженні в Cloud Storage
2. Створення мініатюр різних розмірів
3. Збереження в окремий bucket
4. Логування процесу

### Реалізація

**requirements.txt:**

```
google-cloud-storage==2.10.0
Pillow==10.0.0
```

**main.py:**

```python
from google.cloud import storage
from PIL import Image
import io
import logging

def process_image(event, context):
    """
    Обробка зображення при завантаженні в Cloud Storage
    
    Args:
        event: Дані події Storage
        context: Контекст виклику
    """
    # Отримати інформацію про файл
    bucket_name = event['bucket']
    file_name = event['name']
    
    logging.info(f'Обробка файлу: {file_name} з bucket: {bucket_name}')
    
    # Пропустити якщо це вже мініатюра
    if file_name.startswith('thumb_'):
        logging.info('Пропускаємо мініатюру')
        return
    
    # Перевірити тип файлу
    content_type = event.get('contentType', '')
    if not content_type.startswith('image/'):
        logging.warning(f'Не зображення: {content_type}')
        return
    
    try:
        # Завантажити зображення
        storage_client = storage.Client()
        source_bucket = storage_client.bucket(bucket_name)
        source_blob = source_bucket.blob(file_name)
        image_data = source_blob.download_as_bytes()
        
        # Створити мініатюри різних розмірів
        sizes = [(200, 200), (400, 400), (800, 800)]
        
        for width, height in sizes:
            # Відкрити зображення
            image = Image.open(io.BytesIO(image_data))
            image.thumbnail((width, height))
            
            # Зберегти мініатюру
            thumb_buffer = io.BytesIO()
            image.save(thumb_buffer, format='JPEG', quality=85)
            
            # Завантажити в bucket
            thumb_name = f'thumb_{width}x{height}_{file_name}'
            dest_bucket = storage_client.bucket(f'{bucket_name}-thumbs')
            dest_blob = dest_bucket.blob(thumb_name)
            dest_blob.upload_from_string(
                thumb_buffer.getvalue(),
                content_type='image/jpeg'
            )
            
            logging.info(f'Створено мініатюру: {thumb_name}')
        
        logging.info('Обробка завершена успішно')
        
    except Exception as e:
        logging.error(f'Помилка обробки: {str(e)}')
        raise
```

**Deployment:**

```bash
# Створити buckets
gsutil mb gs://my-images
gsutil mb gs://my-images-thumbs

# Розгорнути функцію
gcloud functions deploy process-image \
  --runtime=python311 \
  --trigger-resource=my-images \
  --trigger-event=google.storage.object.finalize \
  --entry-point=process_image \
  --memory=512MB \
  --timeout=120s \
  --region=us-central1
```

**Тестування:**

```bash
# Завантажити тестове зображення
gsutil cp test-image.jpg gs://my-images/

# Перевірити логи
gcloud functions logs read process-image --limit=20

# Перевірити мініатюри
gsutil ls gs://my-images-thumbs/
```

---

## Best Practices

### Deployment

✅ **РОБИТИ:**

- Використовувати останні версії runtime
- Встановлювати відповідні memory та timeout
- Використовувати Secret Manager для sensitive data
- Налаштовувати min/max instances для production
- Тестувати локально перед deployment

❌ **НЕ РОБИТИ:**

- Не hardcode secrets в коді
- Не використовувати deprecated runtimes
- Не ігнорувати timeout limits
- Не забувати про cold start latency

### Код

✅ **РОБИТИ:**

- Писати ідемпотентні функції
- Логувати важливі події
- Обробляти помилки gracefully
- Використовувати structured logging
- Оптимізувати розмір dependencies

❌ **НЕ РОБИТИ:**

- Не зберігати state в функції
- Не використовувати global variables для state
- Не робити довгі synchronous operations
- Не ігнорувати помилки

### Безпека

✅ **РОБИТИ:**

- Використовувати least privilege service accounts
- Обмежувати доступ через IAM
- Використовувати VPC для приватних ресурсів
- Валідувати вхідні дані
- Використовувати HTTPS для HTTP functions

❌ **НЕ РОБИТИ:**

- Не використовувати `--allow-unauthenticated` для sensitive functions
- Не зберігати credentials в коді
- Не логувати sensitive data
- Не ігнорувати security updates

---

## Exam Tips

> ⚠️ **Важливо для іспиту:**

1. **Deployment Commands:**
   - `gcloud functions deploy` - Розгорнути функцію
   - `--runtime=python39` - Вказати runtime
   - `--trigger-http` - HTTP trigger
   - `--trigger-topic=my-topic` - Pub/Sub trigger
   - `--trigger-resource=bucket` - Storage trigger
   - `--entry-point=function_name` - Entry point

2. **Конфігурація:**
   - `--memory=512MB` - Пам'ять (128MB-8192MB)
   - `--timeout=60s` - Timeout (1s-540s)
   - `--max-instances=100` - Максимум instances
   - `--min-instances=1` - Мінімум instances
   - `--region=us-central1` - Регіон

3. **Environment Variables:**
   - `--set-env-vars=KEY=value` - Встановити
   - `--update-env-vars=KEY=value` - Оновити
   - `--remove-env-vars=KEY` - Видалити

4. **Secrets:**
   - Використовувати Secret Manager
   - `--set-secrets=ENV_VAR=secret:version`
   - Надати доступ service account

5. **Runtimes:**
   - Python: 3.7-3.11
   - Node.js: 14, 16, 18, 20
   - Go, Java, .NET, Ruby, PHP
   - Використовувати останні версії

6. **Типові сценарії:**
   - Image processing → Storage trigger + PIL
   - API endpoint → HTTP trigger
   - Async task → Pub/Sub trigger
   - Scheduled job → HTTP + Cloud Scheduler
   - Database trigger → Firestore trigger

---

**Повернутися до:** [Модуль 06 - Cloud Functions](README.md)
