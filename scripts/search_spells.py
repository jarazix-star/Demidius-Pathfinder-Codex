#!/usr/bin/env python3
import argparse, csv
from pathlib import Path
p=argparse.ArgumentParser(description="Search the Demidius mythic spell sweep.")
p.add_argument("query", nargs="?", default="")
p.add_argument("--rating")
p.add_argument("--tag")
p.add_argument("--limit",type=int,default=50)
args=p.parse_args()
path=Path(__file__).resolve().parents[1]/"reference"/"spells"/"mythic_spell_compendium_demidius_sweep.csv"
with path.open(encoding="utf-8") as f:
    rows=list(csv.DictReader(f))
q=args.query.lower()
rows=[r for r in rows if (not q or q in (r["name"]+" "+r["rules_summary"]+" "+r["demidius_recommendation"]+" "+r["tags"]).lower())]
if args.rating: rows=[r for r in rows if r["rating"].upper()==args.rating.upper()]
if args.tag: rows=[r for r in rows if args.tag.lower() in r["tags"].lower()]
rows.sort(key=lambda r:(-int(r["relevance_score"]),r["name"]))
for r in rows[:args.limit]:
    print(f'{r["rating"]:>2} {r["relevance_score"]:>3}  {r["name"]}  [p. {r["pdf_page"]}]')
    print(f'    {r["demidius_recommendation"]}')
