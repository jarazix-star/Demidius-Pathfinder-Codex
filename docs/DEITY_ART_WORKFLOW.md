# Deity Art Workflow

This workflow governs canonical deity portraits published in the Demidius
Pathfinder Codex Wiki. It preserves the supplied or approved illustration and
adds a consistent identity treatment without repainting the art.

## Canonical treatment

A finished deity portrait uses the lower-center treatment established by
Aetherion:

1. The depicted deity's own name in large ivory-and-gold serif type.
2. That deity's lineage, or an explicit `LINEAGE UNRECORDED` statement when
   canon does not identify it.
3. `GOD OF` or `GODDESS OF` followed by the recorded divine portfolio.
4. A deity-specific gold line sigil derived from the deity's mythology,
   portfolio, domains, or established symbol.

Never copy Aetherion's name, parentage, titles, or sigil onto another god.
Aetherion is the layout reference, not shared identity content.

## Art-preservation rules

- Preserve the approved character, face, anatomy, costume, lighting, setting,
  color, crop, dimensions, and all other scene content.
- Keep a clean, text-free master outside Git in the authorized character-art
  library. Preserve the previous master as a versioned backup when replacing
  canonical art.
- Add the identity treatment by deterministic raster compositing. Do not use a
  generative edit merely to add typography or the line sigil.
- Position the treatment near the center bottom. It must remain readable while
  avoiding faces, hands, signature equipment, and essential narrative action.
- Use the deity's own canon. If lineage or portfolio is uncertain, record that
  uncertainty rather than inventing a relationship or title.

## Reproducible compositor

The repository script is `scripts/add_deity_title_cards.py`. It contains the
active deity list, lineage, portfolio, grammatical title, and sigil motif for
each treated portrait. Aetherion is intentionally absent because the original
art already supplies the reference treatment.

Create previews without changing the Wiki:

```powershell
python scripts/add_deity_title_cards.py --out-dir tmp/deity-title-previews
```

Preview one deity:

```powershell
python scripts/add_deity_title_cards.py --only Ena --out-dir tmp/deity-title-previews
```

After visual approval, apply one deity and synchronize any matching main-site
mirror:

```powershell
python scripts/add_deity_title_cards.py --only Ena --apply
```

Omit `--only` only when deliberately rebuilding the complete series. A partial
apply merges its updated QA record into the existing manifest instead of
discarding the other deity records.

## Quality gates

Before publishing:

1. Inspect the full-resolution finished image and confirm that the identity,
   scene, crop, and dimensions are unchanged outside the lower title region.
2. Confirm the clean-master hash before and after compositing.
3. Confirm the Wiki image and any main-repository mirror have identical hashes.
4. Confirm the apply manifest still contains all 78 compositor-managed gods;
   with unchanged Aetherion, this covers 79 active deity portraits.
5. Run `git diff --check` in both repositories.
6. From the main repository, run:

```powershell
./scripts/test_audit_wiki_links.ps1
./scripts/audit_wiki_links.ps1 -WikiRoot ./Demidius-Pathfinder-Codex.wiki -FailOnIssues
```

7. Update `CHANGELOG.md` in the main repository and `Changelog.md` in the Wiki.

## Publishing boundary

The main repository and GitHub Wiki are separate Git repositories. Inspect,
commit, and push each independently. Before every Wiki commit, confirm there is
no nested `.git` directory beneath the canonical Wiki checkout. Never commit
the clean local art library, temporary previews, or private absolute paths.
