# Triggers

## Вступ

**Cloud Functions Triggers** — це джерела подій, які викликають виконання функцій. Розуміння типів тригерів та їх конфігурації критично важливе для побудови event-driven додатків.

### Що таке Trigger?

**Trigger** — це джерело події, яке викликає Cloud Function:

- HTTP запити
- Події Cloud Storage
- Повідомлення Pub/Sub
- Зміни в Firestore
- Події Firebase
- Завдання Cloud Scheduler

### Event-Driven Architecture

**Переваги:**

- Слабка зв'язаність компонентів
- Автоматичне масштабування
- Оплата за виконання
- Обробка в реальному часі

### Зв'язок з іншими модулями

- **[Module 06 - Deployment](deployment.md):** Розгортання функцій
- **[Module 05 - App Engine](../05-app-engine/README.md):** Альтернативна платформа
- **[Module 07 - Storage](../07-storage/README.md):** Cloud Storage тригери
- **[Module 08 - Databases](../08-databases/README.md):** Firestore тригери

---

## HTTP Triggers

### Що таке HTTP Trigger?

**HTTP trigger** — це синхронний виклик через HTTP запит:

- Методи: GET, POST, PUT, DELETE тощо
- Прямий доступ через URL
- Синхронна відповідь
- Опціональна автентифікація

### Створення HTTP функції

**Код функції:**

```python
def hello_http(request):
    """HTTP Cloud Function"""
    request_json = request.get_json(silent=True)
    name = request_json.get('name') if request_json else 'World'
    return f'Hello, {name}!'
```

**Розгортання:**

```bash
gcloud functions deploy hello-http \
  --runtime=python39 \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point=hello_http
```

### HTTP автентифікація

**Публічна (без автентифікації):**

```bash
gcloud functions deploy my-function \
  --trigger-http \
  --allow-unauthenticated
```

**Приватна (з автентифікацією):**

```bash
gcloud functions deploy my-function \
  --trigger-http
```

**Виклик автентифікованої функції:**

```bash
# Отримати ID token
gcloud auth print-identity-token

# Викликати з токеном
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  https://REGION-PROJECT_ID.cloudfunctions.net/my-function
```

### HTTP методи

**Обробка різних методів:**

```python
def handle_request(request):
    if request.method == 'GET':
        return 'GET request'
    elif request.method == 'POST':
        return 'POST request'
    elif request.method == 'PUT':
        return 'PUT request'
    else:
        return 'Method not allowed', 405
```

### Випадки використання

✅ **Найкраще для:**

- RESTful API
- Webhooks
- Синхронна обробка
- Пряма взаємодія з користувачем

---

## Cloud Storage Triggers

### Що таке Cloud Storage Trigger?

**Cloud Storage trigger** — це асинхронний виклик при подіях у bucket:

- Створення об'єкта (finalize)
- Видалення об'єкта
- Архівування об'єкта
- Оновлення метаданих

### Типи подій

**Доступні події:**

| Подія | Опис | Приклад використання |
|-------|------|----------------------|
| `google.storage.object.finalize` | Об'єкт створено/перезаписано | Обробка зображень |
| `google.storage.object.delete` | Об'єкт видалено | Очищення даних |
| `google.storage.object.archive` | Об'єкт заархівовано | Обробка архівів |
| `google.storage.object.metadataUpdate` | Метадані змінено | Індексація метаданих |

### Створення Storage функції

**Код функції:**

```python
def process_file(event, context):
    """Cloud Storage trigger"""
    file_name = event['name']
    bucket_name = event['bucket']
    
    print(f'Обробка файлу: {file_name} з bucket: {bucket_name}')
    
    # Обробка файлу
    # ...
```

**Розгортання:**

```bash
gcloud functions deploy process-file \
  --runtime=python39 \
  --trigger-resource=my-bucket \
  --trigger-event=google.storage.object.finalize \
  --entry-point=process_file
```

### Дані події

**Структура об'єкта події:**

```python
{
    'bucket': 'my-bucket',
    'name': 'path/to/file.jpg',
    'contentType': 'image/jpeg',
    'size': '1024000',
    'timeCreated': '2024-02-10T12:00:00.000Z',
    'updated': '2024-02-10T12:00:00.000Z'
}
```

### Практичний приклад: Створення мініатюр

```python
from google.cloud import storage
from PIL import Image
import io

def create_thumbnail(event, context):
    """Створення мініатюри при завантаженні зображення"""
    
    # Отримати інформацію про файл
    bucket_name = event['bucket']
    file_name = event['name']
    
    # Пропустити якщо вже мініатюра
    if file_name.startswith('thumb_'):
        return
    
    # Завантажити зображення
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    image_data = blob.download_as_bytes()
    
    # Створити мініатюру
    image = Image.open(io.BytesIO(image_data))
    image.thumbnail((200, 200))
    
    # Завантажити мініатюру
    thumb_blob = bucket.blob(f'thumb_{file_name}')
    thumb_buffer = io.BytesIO()
    image.save(thumb_buffer, format='JPEG')
    thumb_blob.upload_from_string(thumb_buffer.getvalue(), content_type='image/jpeg')
```

### Випадки використання

✅ **Найкраще для:**

- Обробка зображень/відео
- Конвертація форматів файлів
- Валідація даних
- Автоматизація резервного копіювання

---

## Pub/Sub Triggers

### Що таке Pub/Sub Trigger?

**Pub/Sub trigger** — це асинхронний виклик при публікації повідомлення:

- Архітектура на основі повідомлень
- Роз'єднані системи
- Гарантована доставка
- Автоматичні повторні спроби

### Створення Pub/Sub функції

**Код функції:**

```python
import base64
import json

def process_message(event, context):
    """Pub/Sub trigger"""
    
    # Декодувати повідомлення
    if 'data' in event:
        message_data = base64.b64decode(event['data']).decode('utf-8')
        print(f'Повідомлення: {message_data}')
    
    # Отримати атрибути
    attributes = event.get('attributes', {})
    print(f'Атрибути: {attributes}')
```

**Розгортання:**

```bash
gcloud functions deploy process-message \
  --runtime=python39 \
  --trigger-topic=my-topic \
  --entry-point=process_message
```

### Публікація повідомлень

**Публікація в topic:**

```bash
# Просте повідомлення
gcloud pubsub topics publish my-topic --message="Hello, World!"

# Повідомлення з атрибутами
gcloud pubsub topics publish my-topic \
  --message="Order data" \
  --attribute=order_id=12345,status=pending
```

**Програмна публікація:**

```python
from google.cloud import pubsub_v1

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path('my-project', 'my-topic')

# Опублікувати повідомлення
data = json.dumps({'order_id': 12345}).encode('utf-8')
future = publisher.publish(topic_path, data, order_id='12345')
message_id = future.result()
```

### Випадки використання

✅ **Найкраще для:**

- Асинхронна обробка
- Розсилка подій
- Комунікація між мікросервісами
- Розподіл навантаження

---

## Firestore Triggers

### Що таке Firestore Trigger?

**Firestore trigger** — це виклик при змінах документа:

- Створення документа
- Оновлення документа
- Видалення документа
- Запис документа (створення або оновлення)

### Типи подій

**Доступні події:**

| Подія | Опис |
|-------|------|
| `providers/cloud.firestore/eventTypes/document.create` | Документ створено |
| `providers/cloud.firestore/eventTypes/document.update` | Документ оновлено |
| `providers/cloud.firestore/eventTypes/document.delete` | Документ видалено |
| `providers/cloud.firestore/eventTypes/document.write` | Документ створено або оновлено |

### Створення Firestore функції

**Код функції:**

```python
def on_user_create(event, context):
    """Firestore trigger при створенні користувача"""
    
    # Отримати дані документа
    user_data = event['value']['fields']
    user_id = context.resource.split('/')[-1]
    
    print(f'Новий користувач створено: {user_id}')
    print(f'Дані користувача: {user_data}')
    
    # Відправити вітальний email
    # ...
```

**Розгортання:**

```bash
gcloud functions deploy on-user-create \
  --runtime=python39 \
  --trigger-event=providers/cloud.firestore/eventTypes/document.create \
  --trigger-resource=projects/MY_PROJECT/databases/(default)/documents/users/{userId} \
  --entry-point=on_user_create
```

### Випадки використання

✅ **Найкраще для:**

- Валідація даних
- Денормалізація
- Сповіщення
- Аудит логування

---

## Firebase Triggers

### Firebase Authentication

**Тригер при створенні/видаленні користувача:**

```bash
gcloud functions deploy on-user-created \
  --runtime=python39 \
  --trigger-event=providers/firebase.auth/eventTypes/user.create
```

### Firebase Realtime Database

**Тригер при змінах даних:**

```bash
gcloud functions deploy on-data-change \
  --runtime=python39 \
  --trigger-event=providers/google.firebase.database/eventTypes/ref.write \
  --trigger-resource=projects/_/instances/MY_PROJECT/refs/messages/{messageId}
```

---

## Cloud Scheduler Triggers

### Що таке Cloud Scheduler Trigger?

**Cloud Scheduler** — це виклик функції за розкладом (cron):

- Заплановане виконання
- Періодичні завдання
- Автоматизація за часом

### Створення запланованої функції

**1. Створити HTTP функцію:**

```bash
gcloud functions deploy scheduled-function \
  --runtime=python39 \
  --trigger-http \
  --entry-point=scheduled_task
```

**2. Створити Cloud Scheduler job:**

```bash
gcloud scheduler jobs create http daily-backup \
  --schedule="0 2 * * *" \
  --uri="https://REGION-PROJECT_ID.cloudfunctions.net/scheduled-function" \
  --http-method=POST \
  --oidc-service-account-email=PROJECT_ID@appspot.gserviceaccount.com
```

### Формат Cron розкладу

```
* * * * *
│ │ │ │ │
│ │ │ │ └─── День тижня (0-7, Неділя=0 або 7)
│ │ │ └───── Місяць (1-12)
│ │ └─────── День місяця (1-31)
│ └───────── Година (0-23)
└─────────── Хвилина (0-59)
```

**Приклади:**

| Розклад | Опис |
|---------|------|
| `0 2 * * *` | Щодня о 2:00 |
| `*/15 * * * *` | Кожні 15 хвилин |
| `0 9 * * 1` | Кожного понеділка о 9:00 |
| `0 0 1 * *` | Першого числа місяця о півночі |

### Випадки використання

✅ **Найкраще для:**

- Щоденні резервні копії
- Генерація звітів
- Очищення даних
- Періодична синхронізація

---

## Eventarc Triggers

### Що таке Eventarc?

**Eventarc** — це уніфікована платформа подій:

- 90+ джерел подій Google Cloud
- Власні події
- Фільтрація подій
- Стандартизований формат CloudEvents

### Створення Eventarc тригера

```bash
gcloud eventarc triggers create my-trigger \
  --destination-run-service=my-function \
  --destination-run-region=us-central1 \
  --event-filters="type=google.cloud.storage.object.v1.finalized" \
  --event-filters="bucket=my-bucket"
```

---

## Практичний сценарій: Обробка замовлень E-commerce

### Вимоги

1. Замовлення подається через HTTP API
2. Дані замовлення зберігаються в Firestore
3. Інвентар оновлюється
4. Відправляється email підтвердження
5. Публікується аналітична подія

### Реалізація

**1. HTTP API для подання замовлення:**

```python
def submit_order(request):
    """HTTP trigger для подання замовлення"""
    from google.cloud import firestore
    
    order_data = request.get_json()
    
    # Зберегти в Firestore
    db = firestore.Client()
    order_ref = db.collection('orders').document()
    order_ref.set(order_data)
    
    return {'order_id': order_ref.id}, 201
```

**2. Firestore trigger для обробки замовлення:**

```python
def process_order(event, context):
    """Firestore trigger при створенні замовлення"""
    from google.cloud import pubsub_v1
    
    order_data = event['value']['fields']
    order_id = context.resource.split('/')[-1]
    
    # Опублікувати в Pub/Sub для асинхронної обробки
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path('my-project', 'order-processing')
    
    publisher.publish(topic_path, 
                     json.dumps({'order_id': order_id}).encode('utf-8'))
```

**3. Pub/Sub trigger для оновлення інвентарю:**

```python
def update_inventory(event, context):
    """Pub/Sub trigger для оновлення інвентарю"""
    import base64
    
    message = json.loads(base64.b64decode(event['data']))
    order_id = message['order_id']
    
    # Оновити інвентар
    # Відправити email підтвердження
    # Опублікувати аналітичну подію
```

---

## Best Practices

### Вибір тригера

✅ **РОБИТИ:**

- Використовувати HTTP для синхронних API
- Використовувати Pub/Sub для асинхронної обробки
- Використовувати Storage тригери для обробки файлів
- Використовувати Firestore тригери для змін даних
- Використовувати Cloud Scheduler для періодичних завдань

❌ **НЕ РОБИТИ:**

- Не використовувати HTTP для довготривалих завдань
- Не використовувати Storage тригери для real-time обробки
- Не створювати циклічні залежності тригерів

### Обробка помилок

✅ **РОБИТИ:**

- Реалізувати логіку повторних спроб для тимчасових помилок
- Використовувати dead-letter topics для невдалих повідомлень
- Логувати помилки для налагодження
- Встановлювати відповідні таймаути

❌ **НЕ РОБИТИ:**

- Не ігнорувати помилки мовчки
- Не повторювати спроби нескінченно
- Не обробляти дублікати подій без ідемпотентності

---

## Exam Tips

> ⚠️ **Важливо для іспиту:**

1. **HTTP Triggers:**
   - Синхронний виклик
   - Прямий доступ через URL
   - Опціональна автентифікація (`--allow-unauthenticated`)
   - Найкраще для: API, webhooks

2. **Cloud Storage Triggers:**
   - Асинхронний виклик
   - Події: finalize, delete, archive, metadataUpdate
   - Найкраще для: Обробка файлів, мініатюри зображень

3. **Pub/Sub Triggers:**
   - На основі повідомлень
   - Гарантована доставка
   - Автоматичні повторні спроби
   - Найкраще для: Асинхронна обробка, розсилка подій

4. **Firestore Triggers:**
   - Події документа: create, update, delete, write
   - Обробка даних в реальному часі
   - Найкраще для: Валідація даних, сповіщення

5. **Cloud Scheduler:**
   - Планування на основі cron
   - Потребує HTTP функцію + Scheduler job
   - Найкраще для: Періодичні завдання, резервні копії

6. **Типові сценарії:**
   - API endpoint → HTTP trigger
   - Обробка зображень → Cloud Storage trigger
   - Асинхронне завдання → Pub/Sub trigger
   - Зміна даних → Firestore trigger
   - Щоденна резервна копія → Cloud Scheduler

---

**Повернутися до:** [Модуль 06 - Cloud Functions](README.md)

- HTTP requests
- Cloud Storage events
- Pub/Sub messages
- Firestore changes
- Firebase events
- Cloud Scheduler jobs

### Event-Driven Architecture

**Benefits:**

- Loose coupling
- Automatic scaling
- Pay-per-execution
- Real-time processing

### Зв'язок з іншими модулями

- **[Module 06 - Deployment](deployment.md):** Function deployment
- **[Module 05 - App Engine](../05-app-engine/README.md):** Alternative platform
- **[Module 07 - Storage](../07-storage/README.md):** Cloud Storage triggers
- **[Module 08 - Databases](../08-databases/README.md):** Firestore triggers

---

## HTTP Triggers

### What is HTTP Trigger?

**HTTP trigger** — це synchronous invocation via HTTP request:

- GET, POST, PUT, DELETE, etc.
- Direct URL access
- Synchronous response
- Authentication optional

### Creating HTTP Function

**Function code:**

```python
def hello_http(request):
    """HTTP Cloud Function"""
    request_json = request.get_json(silent=True)
    name = request_json.get('name') if request_json else 'World'
    return f'Hello, {name}!'
```

**Deployment:**

```bash
gcloud functions deploy hello-http \
  --runtime=python39 \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point=hello_http
```

### HTTP Authentication

**Public (unauthenticated):**

```bash
gcloud functions deploy my-function \
  --trigger-http \
  --allow-unauthenticated
```

**Private (authenticated):**

```bash
gcloud functions deploy my-function \
  --trigger-http
```

**Invoking authenticated function:**

```bash
# Get ID token
gcloud auth print-identity-token

# Invoke with token
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  https://REGION-PROJECT_ID.cloudfunctions.net/my-function
```

### HTTP Methods

**Handling different methods:**

```python
def handle_request(request):
    if request.method == 'GET':
        return 'GET request'
    elif request.method == 'POST':
        return 'POST request'
    elif request.method == 'PUT':
        return 'PUT request'
    else:
        return 'Method not allowed', 405
```

### Use Cases

✅ **Best for:**

- RESTful APIs
- Webhooks
- Synchronous processing
- Direct user interactions

---

## Cloud Storage Triggers

### What is Cloud Storage Trigger?

**Cloud Storage trigger** — це asynchronous invocation on bucket events:

- Object created (finalize)
- Object deleted
- Object archived
- Object metadata updated

### Event Types

**Available events:**

| Event | Description | Use Case |
|-------|-------------|----------|
| `google.storage.object.finalize` | Object created/overwritten | Image processing |
| `google.storage.object.delete` | Object deleted | Cleanup tasks |
| `google.storage.object.archive` | Object archived | Archival processing |
| `google.storage.object.metadataUpdate` | Metadata changed | Metadata indexing |

### Creating Storage Function

**Function code:**

```python
def process_file(event, context):
    """Cloud Storage trigger"""
    file_name = event['name']
    bucket_name = event['bucket']
    
    print(f'Processing file: {file_name} from bucket: {bucket_name}')
    
    # Process file
    # ...
```

**Deployment:**

```bash
gcloud functions deploy process-file \
  --runtime=python39 \
  --trigger-resource=my-bucket \
  --trigger-event=google.storage.object.finalize \
  --entry-point=process_file
```

### Event Data

**Event object structure:**

```python
{
    'bucket': 'my-bucket',
    'name': 'path/to/file.jpg',
    'contentType': 'image/jpeg',
    'size': '1024000',
    'timeCreated': '2024-02-10T12:00:00.000Z',
    'updated': '2024-02-10T12:00:00.000Z'
}
```

### Practical Example: Image Thumbnail

```python
from google.cloud import storage
from PIL import Image
import io

def create_thumbnail(event, context):
    """Create thumbnail on image upload"""
    
    # Get file info
    bucket_name = event['bucket']
    file_name = event['name']
    
    # Skip if already thumbnail
    if file_name.startswith('thumb_'):
        return
    
    # Download image
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    image_data = blob.download_as_bytes()
    
    # Create thumbnail
    image = Image.open(io.BytesIO(image_data))
    image.thumbnail((200, 200))
    
    # Upload thumbnail
    thumb_blob = bucket.blob(f'thumb_{file_name}')
    thumb_buffer = io.BytesIO()
    image.save(thumb_buffer, format='JPEG')
    thumb_blob.upload_from_string(thumb_buffer.getvalue(), content_type='image/jpeg')
```

### Use Cases

✅ **Best for:**

- Image/video processing
- File format conversion
- Data validation
- Backup automation

---

## Pub/Sub Triggers

### What is Pub/Sub Trigger?

**Pub/Sub trigger** — це asynchronous invocation on message publication:

- Message-driven architecture
- Decoupled systems
- Guaranteed delivery
- Automatic retry

### Creating Pub/Sub Function

**Function code:**

```python
import base64
import json

def process_message(event, context):
    """Pub/Sub trigger"""
    
    # Decode message
    if 'data' in event:
        message_data = base64.b64decode(event['data']).decode('utf-8')
        print(f'Message: {message_data}')
    
    # Get attributes
    attributes = event.get('attributes', {})
    print(f'Attributes: {attributes}')
```

**Deployment:**

```bash
gcloud functions deploy process-message \
  --runtime=python39 \
  --trigger-topic=my-topic \
  --entry-point=process_message
```

### Publishing Messages

**Publish to topic:**

```bash
# Simple message
gcloud pubsub topics publish my-topic --message="Hello, World!"

# Message with attributes
gcloud pubsub topics publish my-topic \
  --message="Order data" \
  --attribute=order_id=12345,status=pending
```

**Programmatic publishing:**

```python
from google.cloud import pubsub_v1

publisher = pubsub_v1.PublisherClient()
topic_path = publisher.topic_path('my-project', 'my-topic')

# Publish message
data = json.dumps({'order_id': 12345}).encode('utf-8')
future = publisher.publish(topic_path, data, order_id='12345')
message_id = future.result()
```

### Use Cases

✅ **Best for:**

- Asynchronous processing
- Event broadcasting
- Microservices communication
- Workload distribution

---

## Firestore Triggers

### What is Firestore Trigger?

**Firestore trigger** — це invocation on document changes:

- Document created
- Document updated
- Document deleted
- Document written (create or update)

### Event Types

**Available events:**

| Event | Description |
|-------|-------------|
| `providers/cloud.firestore/eventTypes/document.create` | Document created |
| `providers/cloud.firestore/eventTypes/document.update` | Document updated |
| `providers/cloud.firestore/eventTypes/document.delete` | Document deleted |
| `providers/cloud.firestore/eventTypes/document.write` | Document created or updated |

### Creating Firestore Function

**Function code:**

```python
def on_user_create(event, context):
    """Firestore trigger on user creation"""
    
    # Get document data
    user_data = event['value']['fields']
    user_id = context.resource.split('/')[-1]
    
    print(f'New user created: {user_id}')
    print(f'User data: {user_data}')
    
    # Send welcome email
    # ...
```

**Deployment:**

```bash
gcloud functions deploy on-user-create \
  --runtime=python39 \
  --trigger-event=providers/cloud.firestore/eventTypes/document.create \
  --trigger-resource=projects/MY_PROJECT/databases/(default)/documents/users/{userId} \
  --entry-point=on_user_create
```

### Use Cases

✅ **Best for:**

- Data validation
- Denormalization
- Notifications
- Audit logging

---

## Firebase Triggers

### Firebase Authentication

**Trigger on user creation/deletion:**

```bash
gcloud functions deploy on-user-created \
  --runtime=python39 \
  --trigger-event=providers/firebase.auth/eventTypes/user.create
```

### Firebase Realtime Database

**Trigger on data changes:**

```bash
gcloud functions deploy on-data-change \
  --runtime=python39 \
  --trigger-event=providers/google.firebase.database/eventTypes/ref.write \
  --trigger-resource=projects/_/instances/MY_PROJECT/refs/messages/{messageId}
```

---

## Cloud Scheduler Triggers

### What is Cloud Scheduler Trigger?

**Cloud Scheduler** — це cron-based function invocation:

- Scheduled execution
- Periodic tasks
- Time-based automation

### Creating Scheduled Function

**1. Create HTTP function:**

```bash
gcloud functions deploy scheduled-function \
  --runtime=python39 \
  --trigger-http \
  --entry-point=scheduled_task
```

**2. Create Cloud Scheduler job:**

```bash
gcloud scheduler jobs create http daily-backup \
  --schedule="0 2 * * *" \
  --uri="https://REGION-PROJECT_ID.cloudfunctions.net/scheduled-function" \
  --http-method=POST \
  --oidc-service-account-email=PROJECT_ID@appspot.gserviceaccount.com
```

### Cron Schedule Format

```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday=0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

**Examples:**

| Schedule | Description |
|----------|-------------|
| `0 2 * * *` | Daily at 2 AM |
| `*/15 * * * *` | Every 15 minutes |
| `0 9 * * 1` | Every Monday at 9 AM |
| `0 0 1 * *` | First day of month at midnight |

### Use Cases

✅ **Best for:**

- Daily backups
- Report generation
- Data cleanup
- Periodic synchronization

---

## Eventarc Triggers

### What is Eventarc?

**Eventarc** — це unified eventing platform:

- 90+ Google Cloud event sources
- Custom events
- Event filtering
- Standardized CloudEvents format

### Creating Eventarc Trigger

```bash
gcloud eventarc triggers create my-trigger \
  --destination-run-service=my-function \
  --destination-run-region=us-central1 \
  --event-filters="type=google.cloud.storage.object.v1.finalized" \
  --event-filters="bucket=my-bucket"
```

---

## Практичний сценарій: E-commerce Order Processing

### Requirements

1. Order submitted via HTTP API
2. Order data stored in Firestore
3. Inventory updated
4. Confirmation email sent
5. Analytics event published

### Implementation

**1. HTTP API for order submission:**

```python
def submit_order(request):
    """HTTP trigger for order submission"""
    from google.cloud import firestore
    
    order_data = request.get_json()
    
    # Store in Firestore
    db = firestore.Client()
    order_ref = db.collection('orders').document()
    order_ref.set(order_data)
    
    return {'order_id': order_ref.id}, 201
```

**2. Firestore trigger for order processing:**

```python
def process_order(event, context):
    """Firestore trigger on order creation"""
    from google.cloud import pubsub_v1
    
    order_data = event['value']['fields']
    order_id = context.resource.split('/')[-1]
    
    # Publish to Pub/Sub for async processing
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path('my-project', 'order-processing')
    
    publisher.publish(topic_path, 
                     json.dumps({'order_id': order_id}).encode('utf-8'))
```

**3. Pub/Sub trigger for inventory update:**

```python
def update_inventory(event, context):
    """Pub/Sub trigger for inventory update"""
    import base64
    
    message = json.loads(base64.b64decode(event['data']))
    order_id = message['order_id']
    
    # Update inventory
    # Send confirmation email
    # Publish analytics event
```

---

## Best Practices

### Trigger Selection

✅ **DO:**

- Use HTTP for synchronous APIs
- Use Pub/Sub for asynchronous processing
- Use Storage triggers for file processing
- Use Firestore triggers for data changes
- Use Cloud Scheduler for periodic tasks

❌ **DON'T:**

- Don't use HTTP for long-running tasks
- Don't use Storage triggers for real-time processing
- Don't create circular trigger dependencies

### Error Handling

✅ **DO:**

- Implement retry logic for transient errors
- Use dead-letter topics for failed messages
- Log errors for debugging
- Set appropriate timeouts

❌ **DON'T:**

- Don't ignore errors silently
- Don't retry indefinitely
- Don't process duplicate events without idempotency

---

## Exam Tips

> ⚠️ **Важливо для іспиту:**

1. **HTTP Triggers:**
   - Synchronous invocation
   - Direct URL access
   - Authentication optional (`--allow-unauthenticated`)
   - Best for: APIs, webhooks

2. **Cloud Storage Triggers:**
   - Asynchronous invocation
   - Events: finalize, delete, archive, metadataUpdate
   - Best for: File processing, image thumbnails

3. **Pub/Sub Triggers:**
   - Message-driven
   - Guaranteed delivery
   - Automatic retry
   - Best for: Async processing, event broadcasting

4. **Firestore Triggers:**
   - Document events: create, update, delete, write
   - Real-time data processing
   - Best for: Data validation, notifications

5. **Cloud Scheduler:**
   - Cron-based scheduling
   - Requires HTTP function + Scheduler job
   - Best for: Periodic tasks, backups

6. **Common Scenarios:**
   - API endpoint → HTTP trigger
   - Image processing → Cloud Storage trigger
   - Async task → Pub/Sub trigger
   - Data change → Firestore trigger
   - Daily backup → Cloud Scheduler

---

**Повернутися до:** [Модуль 06 - Cloud Functions](README.md)
