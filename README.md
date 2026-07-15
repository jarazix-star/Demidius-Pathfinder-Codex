# The Demidius Pathfinder Research Codex

A private, source-backed Pathfinder 1e optimization knowledge base for **Demidius Thorne**, the Dawnrunner campaign, mythic play, extensive third-party material, and progression beyond level 20.

**New to the campaign?** Start with the illustrated [wiki home](docs/index.md), then read the [Demidius overview](docs/demidius-thorne.md), [campaign guide](docs/campaign-guide.md), or [campaign setting](docs/campaign-setting.md).

## Canonical sources

- `codex/MASTER_CODEX.md` - primary human-readable reference
- `database/options.csv` - searchable option index
- `database/options.json` - machine-readable option data
- `codex/SYNERGY_MATRIX.md` - cross-book mechanical relationships
- `research/SOURCE_PROCESSING_LOG.md` - evidence and extraction status
- `CHANGELOG.md` - repository history


## Spell research datasets

- `reference/spells/mythic_spell_compendium_demidius_sweep.csv` - full 2,100-entry spell-by-spell Demidius relevance sweep.
- `reference/spells/mythic_spell_compendium_demidius_sweep.json` - machine-readable spell dataset.
- `reference/spells/mythic_magic_core_spells_demidius_sweep.csv` - full 393-entry Core Spells sweep.
- `reference/spells/mythic_magic_core_vs_compendium_difference_audit.csv` - version-difference audit.
- `reference/spells/MYTHIC_SPELL_COMPENDIUM_SWEEP.md` - findings and top recommendations.
- `reference/spells/CORE_SPELLS_DIFFERENCE_AUDIT.md` - comparison methodology and flagged changes.

Search them with:

```bash
python scripts/search_spells.py dispel
python scripts/search_spells.py --rating S
python scripts/search_spells.py enchantment --tag enchantment
```

## Verification statuses

- **Verified - complete:** entire short source or relevant mechanical section read and evaluated.
- **Verified - focused extraction:** source was available, but only Demidius-relevant options were promoted.
- **Verified - official source index:** official source fully indexed; promoted option still needs final character-sheet cross-check.
- **Partial comparison:** selected entries compared, not a complete source audit.
- **Archive-level index:** filenames and product lines identified only.
- **GM Review:** mechanically verified, but interpretation or selection depends on campaign rulings.

## Copyright

This repository contains original analysis, ratings, summaries, source names, and page references. It does **not** include copyrighted Pathfinder PDFs or extensive copied rules text. The archived DOCX files are the user's own research documents and should remain private.


## Super Genius Games extraction

Four Advanced Options books have received complete content-level extraction. See `research/parsed_books/super_genius_games/advanced_options/` and `database/super_genius_advanced_options.csv`.


## v3.3 extraction

Six additional Super Genius/Rogue Genius Advanced Options books were parsed, adding 126 options.

## v3.4 Integrated Codex Update

The extracted Super Genius/Rogue Genius material is now integrated into active Demidius and Dawnrunner recommendations.

Start here:

- `codex/super_genius_integration_update.md`
- `codex/super_genius_synergy_matrix.md`
- `codex/engines/magical_supremacy_super_genius_addendum.md`
- `codex/engines/infrastructure_super_genius_addendum.md`
- `codex/dawnrunner/officer_and_follower_recommendations.md`
- `codex/recommendations/`
