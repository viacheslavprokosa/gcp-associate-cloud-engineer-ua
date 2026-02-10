# PDF Book Generation

Автоматична генерація PDF книги з Markdown документації.

## Як це працює

При кожному push в гілку `master`, GitHub Actions автоматично:

1. Збирає всі `.md` файли з репозиторію (окрім `.agent/` та `pdf-book/`)
2. Об'єднує їх у правильному порядку:
   - README.md (головна сторінка)
   - Модулі 01-13 (кожен модуль: README → теми → exam-questions)
   - glossary.md (глосарій)
3. Конвертує в PDF використовуючи Pandoc з:
   - Підтримкою українських символів
   - Конвертацією Mermaid діаграм у зображення
   - Автоматичним змістом (table of contents)
   - Нумерацією розділів та сторінок
4. Зберігає результат у `pdf-book/GCP-Associate-CE.pdf`
5. Автоматично комітить PDF назад у репозиторій

## Структура файлів

```
.github/
├── workflows/
│   └── generate-pdf.yml          # GitHub Actions workflow
└── scripts/
    ├── build-pdf.sh              # Скрипт збірки PDF
    └── metadata.yaml             # Метадані та стилі для PDF
```

## Локальна генерація

Якщо потрібно згенерувати PDF локально:

### Встановлення залежностей

**macOS:**

```bash
brew install pandoc
brew install --cask basictex
sudo tlmgr install collection-langcyrillic
npm install -g @mermaid-js/mermaid-cli mermaid-filter
```

**Ubuntu/Debian:**

```bash
sudo apt-get install pandoc texlive-xetex texlive-fonts-recommended texlive-fonts-extra texlive-lang-cyrillic
npm install -g @mermaid-js/mermaid-cli mermaid-filter
```

### Генерація PDF

```bash
chmod +x .github/scripts/build-pdf.sh
.github/scripts/build-pdf.sh
```

Результат: `pdf-book/GCP-Associate-CE.pdf`

## Налаштування

### Виключення папок

Папки, які **не** включаються в PDF:

- `.agent/` - внутрішня документація агента
- `pdf-book/` - папка з результатом
- `.git/`, `.github/` - Git метадані

### Стилізація PDF

Налаштування в `.github/scripts/metadata.yaml`:

- Назва, автор, дата
- Розміри сторінки (A4, margins 2.5cm)
- Шрифти (DejaVu Sans для підтримки кирилиці)
- Кольори посилань
- Стилі код-блоків

### Порядок файлів

Скрипт `build-pdf.sh` автоматично впорядковує файли:

1. Головний README.md
2. Модулі 01-13 (в числовому порядку)
   - Спочатку README.md модуля
   - Потім всі інші .md файли (крім exam-questions.md)
   - В кінці exam-questions.md
3. Глосарій (glossary.md)

## Troubleshooting

### PDF не генерується

Перевірте GitHub Actions:

1. Перейдіть на вкладку "Actions" у репозиторії
2. Знайдіть workflow "Generate PDF Book"
3. Перегляньте логи для деталей помилки

### Українські символи не відображаються

Переконайтеся, що:

- Використовується `xelatex` як PDF engine
- Встановлені `texlive-lang-cyrillic` пакети
- В metadata.yaml вказано `lang: uk-UA`

### Mermaid діаграми не конвертуються

Перевірте:

- Чи встановлений `mermaid-filter`
- Чи використовується `--filter=mermaid-filter` в Pandoc команді
- Чи коректний синтаксис Mermaid діаграм

## Оновлення workflow

Після змін у `.github/workflows/generate-pdf.yml` або `.github/scripts/*`:

- Зміни застосуються автоматично при наступному push
- Workflow **не** запускається при змінах у самому workflow (щоб уникнути циклів)
