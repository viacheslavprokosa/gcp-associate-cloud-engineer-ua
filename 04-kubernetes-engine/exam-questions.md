# Exam Questions - Kubernetes Engine

## Question 1

You want to deploy a containerized application on GKE with minimal operational overhead. You don't need specific node configurations. Which GKE mode should you use?

A) GKE Standard  
B) GKE Autopilot  
C) Compute Engine with Docker  
D) Cloud Run

**Правильна відповідь:** B

**Пояснення:** GKE Autopilot надає найменший operational overhead, оскільки Google автоматично управляє nodes, оптимізацією та scaling. Ви платите тільки за pods та не потребуєте управління infrastructure.

**Чому інші варіанти неправильні:**

- A: Standard mode потребує управління nodes
- C: Compute Engine потребує ще більше управління
- D: Cloud Run не надає повної Kubernetes функціональності

---

## Question 2

Your GKE application needs to expose a web service to the internet. Which Service type should you use?

A) ClusterIP  
B) NodePort  
C) LoadBalancer  
D) ExternalName

**Правильна відповідь:** C

**Пояснення:** LoadBalancer Service автоматично створює зовнішній load balancer з публічним IP, що дозволяє доступ з інтернету.

**Чому інші варіанти неправильні:**

- A: ClusterIP - тільки внутрішній доступ в кластері
- B: NodePort - відкриває порт на nodes, але не створює load balancer
- D: ExternalName - для mapping до зовнішніх DNS імен

---

## Question 3

You need to store database credentials for your GKE application. What should you use?

A) ConfigMap  
B) Secret  
C) Environment variables in Deployment  
D) Store in application code

**Правильна відповідь:** B

**Пояснення:** Secrets призначені для зберігання sensitive даних як passwords, tokens, keys. Вони base64 encoded та можуть бути encrypted at rest.

**Чому інші варіанти неправильні:**

- A: ConfigMaps для non-sensitive configuration
- C: Hardcoded environment variables не secure
- D: Storing credentials в коді - security risk

---

**Повернутися до:** [Модуль 04 - Kubernetes Engine](README.md)
