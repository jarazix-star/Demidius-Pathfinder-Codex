# The Demidius Pathfinder Research Codex

A private, source-backed Pathfinder 1e knowledge base and campaign operating manual for Demidius Thorne, the Dawnrunner campaign, mythic play, extensive third-party material, and post-20 progression.

## Start here

1. [`codex/01_PILLARS_OF_DEMIDIUS.md`](codex/01_PILLARS_OF_DEMIDIUS.md)
2. [`codex/MASTER_CODEX.md`](codex/MASTER_CODEX.md)
3. [`appendices/campaign-rules.md`](appendices/campaign-rules.md)

## Architecture

- **Pillars** explain why the build exists.
- **Engines** explain how the strategy works.
- **Systems** record artifacts, divine abilities, spells, leadership, and campaign assets.
- **Databases** provide searchable structured data.
- **Campaign** preserves timeline, notable figures, and strategic assets.
- **Research** tracks extraction status and unresolved questions.
- **Exports** are generated deliverables, never the canonical source.

## Five pillars

- Probability — control the die.
- Magical Supremacy — control magic.
- Influence — control people and organizations.
- Infrastructure — control conditions before combat.
- Divinity — grow toward apotheosis.

## Key canonical files

- `database/options.csv` and `database/options.json`
- `database/rules.json`
- `database/artifacts.json`
- `database/divine_abilities.json`
- `database/campaign_assets.json`
- `database/pillars.json`
- `reference/spells/` complete mythic spell sweeps and difference audit

## Validation

```bash
python scripts/validate_options.py
python scripts/validate_rules.py
python scripts/validate_repository.py
```

## Copyright

The repository contains original analysis, ratings, summaries, source names, and page references. It does not redistribute copyrighted Pathfinder PDFs or extensive copied rules text.
