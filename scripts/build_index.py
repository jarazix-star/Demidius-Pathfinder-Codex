#!/usr/bin/env python3
import csv
from pathlib import Path
root=Path(__file__).resolve().parents[1]
rows=sorted(csv.DictReader((root/"database/options.csv").open(encoding="utf-8")),key=lambda r:r["name"].casefold())
out=["# Alphabetical Option Index","","Generated from `database/options.csv`.",""]
for r in rows:
    out.append(f"- **{r['name']}** - {r['type']} - **{r['rating']}** - {r['source']} - `{r['verification_status']}`")
(root/"codex/OPTION_INDEX.md").write_text("
".join(out)+"
",encoding="utf-8")
print(f"Wrote {len(rows)} entries")
