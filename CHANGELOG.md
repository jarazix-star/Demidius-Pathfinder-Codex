# Change Log

## 2.0.0 - 2026-07-13

### Added

- Canonical Markdown Campaign Rules Appendix with stable CR-01 through CR-14 identifiers.
- Machine-readable `database/rules.json`.
- Full top-level Luck Engine chapter documenting the Seven-Pipped Gem, Luckstone, Eyebrow Piercing of Confidence, Invoke Deity (Luck), and Make Your Own Luck interactions.
- Repository architecture and Markdown-first workflow documentation.
- YAML dependency metadata for campaign-rule-sensitive chapters.

### Changed

- Promoted the Git repository to the sole canonical source; DOCX/PDF files are exports only.
- Updated Dispel Engine with the verified +10 Seven-Pipped Gem dispel burst and immediate-action conflicts.
- Updated Synergy Matrix to replace pending luck questions with verified campaign rulings.
- Replaced duplicated house-rule prose with links to stable CR identifiers.
- Updated master codex and README for the 2.0 architecture.

## 1.1.0 - 2026-07-13

### Added

- Full spell-by-spell Demidius relevance sweep for all 2,100 unique entries extracted from *Mythic Spell Compendium*.
- Full 393-entry relevance sweep for *Mythic Magic: Core Spells*.
- Structured CSV and JSON datasets with rating, relevance score, tags, summaries, verification status, and exact book/PDF-page citations.
- Complete exact-name and normalized-text difference audit between the two books.
- Search utility: `scripts/search_spells.py`.
- Manual-review queue for substantive differences, low-overlap comparisons, and the Core-only *Charm Persona* entry.

### Changed

- *Mythic Spell Compendium* source status upgraded from focused extraction to complete full-text spell extraction.
- *Mythic Magic: Core Spells* status upgraded from partial comparison to complete spell extraction and difference audit.
- Source preference standardized: use the later *Mythic Spell Compendium* wording when both books contain the same spell, absent a campaign-specific ruling.


## 1.0.0 - 2026-07-13

### Added

- Canonical `MASTER_CODEX.md`.
- Searchable option index in CSV, JSON, and Markdown.
- Verification status and GM-review field for every indexed recommendation.
- Problem-oriented chapters for dispel, luck, enchantment, Leadership, and planar operations.
- Cross-book synergy matrix.
- Source processing log and open-question ledger.
- House-rule appendix.
- Archived copies of the supplied DOCX research files.
- Validation and index-generation scripts.

### Consolidated

- Optimization Codex versions 1.0-1.5.
- Citation framework.
- Research ledger and source-processing logs.
- Mythic Adventures extraction references.
- PF1e Mythic Optimization Encyclopedia.
- Demidius field/reference guide.
