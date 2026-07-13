#!/usr/bin/env python3
import csv, sys
from pathlib import Path
p=Path(__file__).resolve().parents[1]/"database/options.csv"
required=["name","type","rating","recommendation","verification_status","source","publisher","pdf_page","citation","tags","summary","gm_review"]
rows=list(csv.DictReader(p.open(encoding="utf-8")))
errors=[]
seen=set()
for i,r in enumerate(rows,2):
    for k in required:
        if not r.get(k," ").strip(): errors.append(f"row {i}: missing {k}")
    key=r["name"].strip().casefold()
    if key in seen: errors.append(f"row {i}: duplicate name {r['name']}")
    seen.add(key)
if errors:
    print("
".join(errors)); sys.exit(1)
print(f"OK: {len(rows)} options validated")
