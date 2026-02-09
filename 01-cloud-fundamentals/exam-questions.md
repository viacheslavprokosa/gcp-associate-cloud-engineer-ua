# Exam Questions - Cloud Fundamentals

## Question 1

Your company wants to deploy a web application that requires full control over the operating system and the ability to install custom software packages. Which service model should you choose?

A) SaaS (Software as a Service)  
B) PaaS (Platform as a Service)  
C) IaaS (Infrastructure as a Service)  
D) FaaS (Function as a Service)

**Правильна відповідь:** C

**Пояснення:** IaaS (Infrastructure as a Service) надає повний контроль над віртуальною машиною, включаючи операційну систему та можливість встановлення будь-якого програмного забезпечення. Compute Engine є прикладом IaaS в GCP.

**Чому інші варіанти неправильні:**

- A: SaaS надає готове програмне забезпечення без можливості контролю над ОС
- B: PaaS керує операційною системою автоматично, обмежуючи контроль користувача
- D: FaaS (як Cloud Functions) призначений для виконання окремих функцій, а не повноцінних додатків з кастомним ПЗ

---

## Question 2

You need to ensure high availability for your application by deploying it across multiple isolated locations within the same geographic area. What GCP concept should you use?

A) Deploy across multiple regions  
B) Deploy across multiple zones within a region  
C) Deploy across multiple projects  
D) Deploy using multi-regional storage

**Правильна відповідь:** B

**Пояснення:** Розгортання додатку в кількох зонах в межах одного регіону забезпечує високу доступність при збої однієї зони, зберігаючи низьку латентність між зонами. Це найкращий баланс між доступністю та вартістю для більшості випадків.

**Чому інші варіанти неправильні:**

- A: Розгортання в кількох регіонах забезпечує найвищу доступність, але збільшує вартість та латентність між регіонами
- C: Проекти - це організаційна одиниця, а не механізм забезпечення високої доступності
- D: Multi-regional storage стосується тільки сховищ даних, а не розгортання додатків

---

## Question 3

Your organization has users primarily located in Europe and needs to comply with GDPR regulations requiring data to remain within the EU. Which factor is MOST important when selecting a GCP region?

A) Cost optimization  
B) Latency to users  
C) Data residency and compliance requirements  
D) Availability of specific machine types

**Правильна відповідь:** C

**Пояснення:** Коли є регуляторні вимоги (як GDPR), compliance та data residency є найвищим пріоритетом. Дані повинні зберігатися в регіонах ЄС (наприклад, europe-west1, europe-west2) для відповідності GDPR.

**Чому інші варіанти неправильні:**

- A: Хоча вартість важлива, compliance вимоги мають вищий пріоритет
- B: Латентність важлива, але не може порушувати регуляторні вимоги
- D: Доступність machine types - технічний фактор, який не перевищує compliance вимоги

---

## Question 4

Which of the following GCP services is an example of PaaS (Platform as a Service)?

A) Compute Engine  
B) Cloud Storage  
C) App Engine  
D) Gmail

**Правильна відповідь:** C

**Пояснення:** App Engine є PaaS сервісом, який надає платформу для розгортання додатків без необхідності управління операційною системою, middleware або runtime середовищем. Розробник фокусується тільки на коді додатку.

**Чому інші варіанти неправильні:**

- A: Compute Engine - це IaaS, надає віртуальні машини з повним контролем
- B: Cloud Storage - це IaaS, надає об'єктне сховище
- D: Gmail - це SaaS, готовий продукт для кінцевих користувачів

---

## Question 5

You are deploying a Compute Engine instance and want to ensure it survives a zone failure. What should you do?

A) Create the instance in a multi-regional location  
B) Create snapshots of the instance in multiple zones  
C) Deploy multiple instances across different zones in the same region  
D) Use a global load balancer

**Правильна відповідь:** C

**Пояснення:** Compute Engine instances є zonal ресурсами. Для забезпечення доступності при збої зони потрібно створити кілька екземплярів у різних зонах одного регіону та використовувати load balancer для розподілу трафіку.

**Чому інші варіанти неправильні:**

- A: Compute Engine instances не можуть бути створені в multi-regional location, вони завжди zonal
- B: Snapshots допомагають відновити дані, але не забезпечують автоматичну високу доступність
- D: Global load balancer сам по собі не створює екземпляри в інших зонах

---

## Question 6

What is the main benefit of the cloud computing pay-as-you-go pricing model compared to traditional on-premises infrastructure?

A) Better security  
B) Faster network speeds  
C) Converting CAPEX to OPEX  
D) Unlimited storage capacity

**Правильна відповідь:** C

**Пояснення:** Основна перевага pay-as-you-go моделі - це перехід від капітальних витрат (CAPEX) на купівлю обладнання до операційних витрат (OPEX), де ви платите тільки за використані ресурси. Це зменшує початкові інвестиції та фінансові ризики.

**Чому інші варіанти неправильні:**

- A: Безпека залежить від конфігурації, а не від моделі оплати
- B: Швидкість мережі не пов'язана з моделлю оплати
- D: Хмара надає велику ємність, але не безмежну, і це не основна перевага pay-as-you-go

---

## Question 7

Which type of GCP resource is a VPC network?

A) Zonal resource  
B) Regional resource  
C) Multi-regional resource  
D) Global resource

**Правильна відповідь:** D

**Пояснення:** VPC (Virtual Private Cloud) network є глобальним ресурсом у GCP. Одна VPC може охоплювати всі регіони та зони, а subnets всередині VPC є регіональними ресурсами.

**Чому інші варіанти неправильні:**

- A: Zonal ресурси існують тільки в одній зоні (наприклад, VM instances)
- B: Regional ресурси існують в одному регіоні (наприклад, subnets)
- C: Multi-regional ресурси реплікуються між кількома регіонами (наприклад, Cloud Storage buckets)

---

**Повернутися до:** [Модуль 01 - Основи хмарних обчислень](README.md)
