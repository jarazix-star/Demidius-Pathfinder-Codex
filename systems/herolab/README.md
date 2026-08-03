# Hero Lab Classic Custom Data Backup

This directory is the recoverable Git mirror of the Demidius project's active,
project-authored Hero Lab Classic Pathfinder extensions.

## Contents

- `data/pathfinder/`: 36 active `Codex_*` data files (`.user`, `.1st`, `.aug`,
  `.core`, and `.dat`).
- `customoutput/pathfinder/ArmidaleCodex/`: the side-by-side Armidale Codex
  v3.18 custom output, including the Godling/Mythic page and page-one portrait
  watermark.
- `MANIFEST.sha256`: hashes for all 38 backed-up runtime files.

The snapshot intentionally excludes portfolios (`.por`), extracted character
data, portraits, temporary renders, stock Hero Lab files, community packs,
ShadowChemosh imports, failed experiments, and retired/duplicate files.

## Restore on Windows

1. Install Hero Lab Classic and its licensed Pathfinder game system.
2. Copy the contents of `data/pathfinder/` into
   `C:\ProgramData\Hero Lab\data\pathfinder\`.
3. Copy the `ArmidaleCodex` directory into
   `C:\ProgramData\Hero Lab\customoutput\pathfinder\`.
4. Start Hero Lab and use **Develop -> Quick Reload Data Files**.
5. Test with a disposable portfolio before opening or saving a live campaign
   portfolio.

The Godly Powers feature requires its complete family of structural files and
catalogs; restore the entire `data/pathfinder` directory rather than selecting
only `Codex_Godly_Powers_V1.user`.

## Integrity

`MANIFEST.sha256` records the SHA-256 digest and repository-relative path of
every runtime file. The snapshot was created only after the staged copies were
confirmed byte-identical to the active installed `Codex_*` files.

Hero Lab and Pathfinder are trademarks of their respective owners. This mirror
contains project-authored extensions and does not include the underlying game
system, community data packs, sourcebooks, or a Hero Lab license.
