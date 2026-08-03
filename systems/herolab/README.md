# Hero Lab Classic Custom Data Backup

This directory is the recoverable Git mirror of the Demidius project's active,
project-authored Hero Lab Classic Pathfinder extensions.

## Contents

- `data/pathfinder/`: 36 active `Codex_*` data files (`.user`, `.1st`, `.aug`,
  `.core`, and `.dat`).
- `customoutput/pathfinder/ArmidaleCodex/`: the side-by-side Armidale Codex
  v3.18 custom output, including the Godling/Mythic page and page-one portrait
  watermark.
- `customoutput/pathfinder/AncientOneCodex/`: the intended side-by-side
  AncientOne Codex v4.15 output, preserving AncientOne's dense layout while
  adding the Godling/Mythic page, lower full-color portrait watermark, Race
  truncation, and product-logo removal.
- `MANIFEST.sha256`: hashes for all 40 backed-up runtime files.
- `scripts/generate_fatal_flaw_catalog.ps1`: path-neutral, recoverable generator
  for the 100 workbook choices plus campaign-specific Paranoia and Misjudging
  Intentions.

The snapshot intentionally excludes portfolios (`.por`), extracted character
data, portraits, temporary renders, stock Hero Lab files, community packs,
ShadowChemosh imports, failed experiments, and retired/duplicate files.

## Restore on Windows

1. Install Hero Lab Classic and its licensed Pathfinder game system.
2. Copy the contents of `data/pathfinder/` into
   `C:\ProgramData\Hero Lab\data\pathfinder\`.
3. Copy the `ArmidaleCodex` and/or `AncientOneCodex` directories into
   `C:\ProgramData\Hero Lab\customoutput\pathfinder\`.
4. Start Hero Lab and use **Develop -> Quick Reload Data Files**.
5. Test with a disposable portfolio before opening or saving a live campaign
   portfolio.

The Godly Powers feature requires its complete family of structural files and
catalogs; restore the entire `data/pathfinder` directory rather than selecting
only `Codex_Godly_Powers_V1.user`.

## Fatal Flaw catalog workflow

1. Update the authoritative 100-row workbook table through the Wiki page
   `Fatal-Flaw-Catalog.md`; keep campaign-specific additions in the generator.
2. From the main repository, run:
   `& .\systems\herolab\scripts\generate_fatal_flaw_catalog.ps1`.
3. Confirm 102 `xCFF` choices, six `xCdxFlw` helpers, unique Thing IDs, and
   valid XML.
4. Synchronize the generated file to the Project staging folder and
   `C:\ProgramData\Hero Lab\data\pathfinder`.
5. Use **Develop -> Quick Reload Data Files**, test without saving a live
   portfolio, and update `MANIFEST.sha256` with the final digest.

The supplemental choices are `xCFF101` Paranoia and `xCFF102` Misjudging
Intentions. Misjudging Intentions applies -20 to Sense Motive checks when the
subject is a woman.

## Integrity

`MANIFEST.sha256` records the SHA-256 digest and repository-relative path of
every runtime file. The snapshot was created only after the staged copies were
confirmed byte-identical to the active installed `Codex_*` files.

Hero Lab and Pathfinder are trademarks of their respective owners. This mirror
contains project-authored extensions and does not include the underlying game
system, community data packs, sourcebooks, or a Hero Lab license.

AncientOne's v4.14 sheet explicitly permits modification and reuse in its
stylesheet header. The repository stores the project-specific v4.15 derivative,
not a separate untouched copy of the third-party v4.14 package.
