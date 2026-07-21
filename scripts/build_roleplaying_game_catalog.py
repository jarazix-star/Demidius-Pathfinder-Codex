"""Build portable source catalogs from the PF1 rules-library manifest."""

from __future__ import annotations

import argparse
import csv
import json
import re
from pathlib import Path


def identity(relative: str) -> tuple[str, str]:
    stem = Path(relative).stem
    match = re.match(r"^(PZO\d+(?:-\d+)?)\s+(.+)$", stem)
    if match:
        return match.group(1), match.group(2)
    parent = Path(relative).parts[0] if len(Path(relative).parts) > 1 else ""
    parent_match = re.match(r"^(PZO\d+(?:-\d+)?)", parent)
    return (parent_match.group(1) if parent_match else "", stem)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("manifest", type=Path)
    parser.add_argument("registry", type=Path)
    parser.add_argument("catalog", type=Path)
    ns = parser.parse_args()
    manifest = json.loads(ns.manifest.read_text(encoding="utf-8"))
    records = []
    for row in manifest["books"]:
        code, title = identity(row["file"])
        records.append({
            "product_code": code,
            "title": title,
            "relative_file": row["file"],
            "pdf_pages": row["pages"],
            "pages_with_text": row["pages_with_text"],
            "characters_extracted": row["characters"],
            "status": "content-indexed" if not row["error"] else "index-error",
            "notes": "image-heavy or blank pages present" if row["pages_with_text"] < row["pages"] else "",
            "error": row["error"],
        })
    registry = {
        "collection": "Pathfinder Roleplaying Game",
        "publisher": "Paizo",
        "extraction_date": "2026-07-21",
        "evidence_level": "Complete recursive page-aware text index; focused contextual review of high-value rules",
        "pdf_count": manifest["book_count"],
        "total_pdf_pages": manifest["total_pages"],
        "pages_with_text": manifest["pages_with_text"],
        "characters_extracted": manifest["characters"],
        "scope_note": "Temporary page text is retained locally for research and is not redistributed.",
        "sources": records,
    }
    ns.registry.parent.mkdir(parents=True, exist_ok=True)
    ns.registry.write_text(json.dumps(registry, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    ns.catalog.parent.mkdir(parents=True, exist_ok=True)
    with ns.catalog.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(records[0]))
        writer.writeheader()
        writer.writerows(records)


if __name__ == "__main__":
    main()
