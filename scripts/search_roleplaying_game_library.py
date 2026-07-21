"""Rank campaign-relevant page hits in the PF1 Roleplaying Game corpus."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


QUERIES = {
    "demidius_core": {"oracle": 3, "revelation": 4, "charisma modifier": 6, "luck bonus": 6, "reroll": 6, "dispel check": 8, "counterspell": 8, "spell resistance": 4, "leadership": 4},
    "mythic": {"mythic power": 5, "mythic feat": 5, "path ability": 4, "divine source": 7, "legendary item": 7, "mythic spell": 5, "tier": 2},
    "fleet": {"profession (sailor)": 10, "ship combat": 9, "naval combat": 9, "siege engine": 7, "boarding": 5, "crew": 2, "favorable wind": 7, "control weather": 6, "stronghold": 3},
    "leadership_kingdom": {"leadership score": 10, "cohort": 6, "followers": 4, "kingdom": 5, "downtime": 6, "organization": 3, "reputation": 4, "rooms and teams": 8},
    "party": {"water domain": 6, "weather domain": 6, "plant domain": 6, "animal companion": 4, "polymorph": 4, "cold damage": 3, "healing": 2, "bardic performance": 4, "alchemy": 3, "cannon": 5},
    "planar_artifact": {"artifact": 4, "major artifact": 8, "demiplane": 8, "plane shift": 5, "teleportation circle": 8, "dimensional lock": 7, "soul": 2, "resurrection": 4},
    "optional_systems": {"background skills": 8, "stamina pool": 8, "automatic bonus progression": 8, "variant multiclassing": 8, "retraining": 5, "hero points": 5, "contacts": 4},
}


def make_snippet(text: str, terms: list[str], width: int = 700) -> str:
    low = text.casefold()
    positions = [low.find(term.casefold()) for term in terms if low.find(term.casefold()) >= 0]
    start = max(0, (min(positions) if positions else 0) - 180)
    return re.sub(r"\s+", " ", text[start:start + width]).strip()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("index", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--top", type=int, default=80)
    ns = parser.parse_args()
    manifest = json.loads((ns.index / "manifest.json").read_text(encoding="utf-8"))
    ranked = {key: [] for key in QUERIES}
    for book in manifest["books"]:
        with (ns.index / book["index_file"]).open(encoding="utf-8") as handle:
            for line in handle:
                row = json.loads(line)
                text = row.get("text", "")
                low = text.casefold()
                if not low:
                    continue
                for category, weights in QUERIES.items():
                    matches = {term: low.count(term) for term in weights if low.count(term)}
                    if matches:
                        score = sum(weights[term] * min(count, 5) for term, count in matches.items())
                        ranked[category].append({"score": score, "book": book["file"], "page": row["page"], "matches": matches, "snippet": make_snippet(text, list(matches))})
    for category, hits in ranked.items():
        hits.sort(key=lambda hit: (-hit["score"], hit["book"].casefold(), hit["page"]))
        ranked[category] = hits[:ns.top]
        print(f"\n## {category}")
        for hit in ranked[category][:12]:
            print(f"{hit['score']:>3} {hit['book']} p.{hit['page']} {hit['matches']}")
    ns.output.parent.mkdir(parents=True, exist_ok=True)
    ns.output.write_text(json.dumps(ranked, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
