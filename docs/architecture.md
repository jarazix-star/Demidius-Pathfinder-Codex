# Repository Architecture

## Single source of truth

Markdown and structured database files are canonical. DOCX and PDF files are exports only.

```text
Source PDFs and campaign rulings
            ↓
Content extraction and verification
            ↓
Structured data (CSV / JSON)
            ↓
Canonical Markdown chapters
            ↓
Generated DOCX / PDF / website exports
```

## Canonical areas

- `codex/` — problem-oriented build chapters.
- `appendices/` — campaign rules and reference appendices.
- `database/` — machine-readable options, sources, and rules.
- `reference/` — comprehensive extraction datasets.
- `research/` — processing state, open questions, and methodology.
- `exports/` — generated artifacts; never the authoritative source.

## Change workflow

1. Verify source text or confirm a campaign ruling.
2. Update the structured data.
3. Update the relevant Markdown chapter.
4. Update dependency links and processing status.
5. Run validation scripts.
6. Add a changelog entry.
7. Commit with a focused message.

## Campaign rule dependency workflow

Rules use stable identifiers such as `CR-05`. Chapters list dependencies in YAML front matter and inline links. When a rule changes, repository-wide search identifies every affected recommendation.
