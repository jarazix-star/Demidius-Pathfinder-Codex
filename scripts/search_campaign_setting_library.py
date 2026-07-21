"""Rank page-level hits in the temporary Chronicles/Campaign Setting index."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


QUERIES = {
    "divine_progression": {
        "divine boon": 8,
        "deific obedience": 8,
        "obedience": 3,
        "divine gift": 5,
        "divine trial": 7,
        "mythic trial": 7,
        "apotheosis": 6,
        "demigod": 4,
        "champion": 2,
        "herald": 2,
        "exalted": 3,
        "evangelist": 3,
        "sentinel": 3,
    },
    "naval_operations": {
        "profession (sailor)": 9,
        "profession sailor": 9,
        "ship combat": 7,
        "naval combat": 7,
        "siege engine": 5,
        "boarding": 5,
        "crew": 2,
        "captain": 2,
        "fleet": 3,
        "favorable wind": 6,
        "wind speed": 4,
        "ship": 1,
    },
    "probability_and_magic": {
        "luck bonus": 6,
        "reroll": 5,
        "d20 roll": 4,
        "charisma modifier": 4,
        "counterspell": 7,
        "dispel check": 7,
        "spell resistance": 3,
        "swift action": 4,
        "immediate action": 4,
        "free action": 3,
        "oracle": 2,
    },
    "leadership_and_factions": {
        "leadership score": 8,
        "leadership feat": 7,
        "cohort": 5,
        "followers": 3,
        "faction points": 7,
        "prestige points": 7,
        "organization": 2,
        "reputation": 3,
        "influence": 2,
    },
    "artifacts_and_infrastructure": {
        "artifact": 4,
        "major artifact": 8,
        "minor artifact": 6,
        "demiplane": 7,
        "teleportation circle": 7,
        "stronghold": 3,
        "castle": 2,
        "portal": 3,
        "siege": 2,
    },
    "party_synergy": {
        "weather control": 7,
        "control weather": 7,
        "water domain": 5,
        "plant domain": 5,
        "repose domain": 5,
        "healing domain": 5,
        "shapechange": 5,
        "polymorph": 3,
        "cold damage": 3,
        "animal companion": 3,
        "vermin": 2,
    },
}


def snippet(text: str, needles: list[str], width: int = 650) -> str:
    lowered = text.casefold()
    positions = [lowered.find(needle.casefold()) for needle in needles]
    positions = [position for position in positions if position >= 0]
    start = max(0, (min(positions) if positions else 0) - 180)
    clean = re.sub(r"\s+", " ", text[start : start + width]).strip()
    return clean


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("index", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--top", type=int, default=50)
    ns = parser.parse_args()

    manifest = json.loads((ns.index / "manifest.json").read_text(encoding="utf-8"))
    ranked: dict[str, list[dict]] = {name: [] for name in QUERIES}
    for book in manifest["books"]:
        path = ns.index / book["index_file"]
        with path.open(encoding="utf-8") as handle:
            for line in handle:
                row = json.loads(line)
                text = row.get("text", "")
                lowered = text.casefold()
                if not lowered:
                    continue
                for category, weighted in QUERIES.items():
                    matches = {}
                    score = 0
                    for term, weight in weighted.items():
                        count = lowered.count(term.casefold())
                        if count:
                            matches[term] = count
                            score += weight * min(count, 5)
                    if score:
                        ranked[category].append(
                            {
                                "score": score,
                                "book": book["file"],
                                "page": row["page"],
                                "matches": matches,
                                "snippet": snippet(text, list(matches)),
                            }
                        )

    for category in ranked:
        ranked[category].sort(
            key=lambda hit: (-hit["score"], hit["book"].casefold(), hit["page"])
        )
        ranked[category] = ranked[category][: ns.top]
    ns.output.parent.mkdir(parents=True, exist_ok=True)
    ns.output.write_text(json.dumps(ranked, indent=2, ensure_ascii=False), encoding="utf-8")
    for category, hits in ranked.items():
        print(f"\n## {category}")
        for hit in hits[:10]:
            print(f"{hit['score']:>3}  {hit['book']} p.{hit['page']}  {hit['matches']}")


if __name__ == "__main__":
    main()
