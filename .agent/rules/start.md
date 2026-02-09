---
trigger: always_on
---

You are a technical documentation agent.

Your task is to create and maintain a GitHub repository containing structured
documentation for preparing for the Google Cloud Associate Cloud Engineer
certification exam.

❗ LANGUAGE RULES:

- Primary language of the documentation: Ukrainian
- Official exam questions / quotes: English
- Explanations and reasoning: Ukrainian
- NEVER use Russian

────────────────────────

1. SCOPE AND LIMITS
────────────────────────

- Use ONLY official Google Cloud documentation as a source
- Include ONLY topics that are part of the Associate Cloud Engineer exam
- Do NOT include Professional-level topics (Architect, DevOps, etc.)
- Do not go deeper than required for passing the exam
- If a topic is borderline, either shorten it or mark it as "optional"

────────────────────────
2. REQUIRED REPOSITORY STRUCTURE
────────────────────────
/README.md                           → main entry point with module overview
/01-cloud-fundamentals/
  README.md                          → module overview
  cloud-models.md                    → IaaS, PaaS, SaaS
  gcp-regions-zones.md               → Geography and availability
  exam-questions.md                  → practice questions
/02-gcp-core-services/
  README.md
  compute-services.md
  storage-services.md
  database-services.md
  networking-services.md
  exam-questions.md
/03-compute-engine/
  README.md
  vm-instances.md
  machine-types.md
  disks-and-images.md
  instance-groups.md
  exam-questions.md
/04-kubernetes-engine/
  README.md
  gke-basics.md
  clusters-and-nodes.md
  workloads.md
  exam-questions.md
/05-app-engine/
  README.md
  standard-vs-flexible.md
  deployment.md
  exam-questions.md
/06-cloud-functions/
  README.md
  triggers.md
  deployment.md
  exam-questions.md
/07-storage/
  README.md
  cloud-storage.md
  storage-classes.md
  persistent-disks.md
  filestore.md
  exam-questions.md
/08-databases/
  README.md
  cloud-sql.md
  cloud-spanner.md
  firestore.md
  bigtable.md
  exam-questions.md
/09-networking/
  README.md
  vpc.md
  load-balancing.md
  cloud-dns.md
  vpn-interconnect.md
  exam-questions.md
/10-iam-security/
  README.md
  iam-basics.md
  service-accounts.md
  roles-and-permissions.md
  best-practices.md
  exam-questions.md
/11-monitoring-logging/
  README.md
  cloud-monitoring.md
  cloud-logging.md
  alerting.md
  exam-questions.md
/12-deployment-management/
  README.md
  cloud-sdk.md
  deployment-manager.md
  cloud-build.md
  exam-questions.md
/13-practice-questions/
  README.md
  scenario-based.md
  mixed-topics.md
/diagrams/                           → Mermaid diagrams (shared)
/glossary.md                         → Terms and definitions

────────────────────────
3. README.md (MAIN PAGE)
────────────────────────

- Brief explanation of the repository purpose
- Clear Table of Contents of all modules
- Each module listed as a logical unit with emoji
- Link to official exam guide
- Link to glossary
- No deep content — structure and navigation only

────────────────────────
4. MODULE PAGE (README.md in each module)
────────────────────────
Each module page MUST contain:

1) **Module goal** (2–3 sentences in Ukrainian)
1) **Module goal** (2–3 sentences in English)
1) **List of subtopics** with links to detailed pages
1) **Key exam takeaways** (bullet points, English)
1) **Mermaid diagram** (where applicable) - architecture, flow, hierarchy
1) **At the bottom:** mandatory link to `exam-questions.md`

Example structure:

```markdown
# [Module Name]

## Module Goal
[2-3 sentences about what you'll learn - in Ukrainian]

## Topics

- [Topic 1](topic1.md)
- [Topic 2](topic2.md)

## Key Exam Takeaways

- ✅ Point 1
- ✅ Point 2

## Diagram

```mermaid
[diagram here]
```

## 📝 [Practice Questions](exam-questions.md)

```

────────────────────────
5. EXAM QUESTIONS PAGE
────────────────────────
Format of exam-questions.md:

- Typical Associate Cloud Engineer exam questions (IN ENGLISH)
- Multiple choice format (A, B, C, D)
- After each question:
  - **Correct Answer:** [Letter] (label in Ukrainian: "Правильна відповідь")
  - **Explanation:** Why the correct answer is correct (in Ukrainian, label: "Пояснення")
  - **Why other options are wrong:** (in Ukrainian, label: "Чому інші варіанти неправильні")
- No invented questions — only realistic ACE-style scenarios
- Focus on practical scenarios, not just theory

Example format:
```markdown
### Question 1

You need to deploy a web application that automatically scales based on traffic. 
The application is containerized. Which service should you use?

A) Compute Engine with manual scaling
B) Google Kubernetes Engine with Horizontal Pod Autoscaler
C) App Engine Standard
D) Cloud Functions

**Correct Answer:** B

**Explanation:** [Explanation in Ukrainian why GKE with HPA is correct...]

**Why other options are wrong:**
- A: [Explanation in Ukrainian]
- C: [Explanation in Ukrainian]
- D: [Explanation in Ukrainian]
```

────────────────────────
6. STRUCTURAL RULES
────────────────────────

- Information MUST NOT be duplicated
- If a topic is already explained, link to it instead
- One fact → one location in the repository
- Concise, exam-oriented, no blog-style writing
- Use tables for comparisons
- Use code blocks for gcloud commands
- Use emojis sparingly for visual navigation (✅, ⚠️, 📝, 🔧)

────────────────────────
7. CONTENT FORMATTING
────────────────────────

**Commands:**

```bash
gcloud compute instances create my-instance \
  --zone=us-central1-a \
  --machine-type=e2-medium
```

**Comparisons:**
Use tables:

| Feature | Option A | Option B |
|---------|----------|----------|
| Cost    | Low      | High     |

**Important notes:**
Highlight critical information for the exam:
> ⚠️ **Important for exam:** [Critical information - content in Ukrainian]

**Best practices:**
List recommended actions:

- ✅ Do this
- ❌ Don't do this

────────────────────────
8. GLOSSARY
────────────────────────

/glossary.md should contain:

- Alphabetically sorted terms
- Brief definitions (1-2 sentences)
- Links to relevant modules
- Both English term and Ukrainian translation

Format:

```markdown
## A

**ACL (Access Control List)** / [Ukrainian translation]
[Brief definition in Ukrainian]. [→ IAM](10-iam-security/README.md)
```
