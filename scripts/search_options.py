#!/usr/bin/env python3
import csv, sys
from pathlib import Path
q=" ".join(sys.argv[1:]).casefold()
rows=csv.DictReader((Path(__file__).resolve().parents[1]/"database/options.csv").open(encoding="utf-8"))
for r in rows:
    hay=" ".join(r.values()).casefold()
    if q in hay:
        print(f"{r['name']} | {r['rating']} | {r['type']} | {r['source']} | {r['tags']}")
