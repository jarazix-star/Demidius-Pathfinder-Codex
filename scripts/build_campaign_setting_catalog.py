"""Build portable catalogs for the page-indexed Paizo setting library."""

from __future__ import annotations

import argparse
import csv
import json
import re
from pathlib import Path


def split_name(filename: str) -> tuple[str, str]:
    stem = Path(filename).stem
    match = re.match(r"^(PZO\d+)\s+(.+)$", stem)
    return (match.group(1), match.group(2)) if match else ("", stem)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("manifest", type=Path)
    parser.add_argument("registry", type=Path)
    parser.add_argument("catalog", type=Path)
    args = parser.parse_args()

    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    books = []
    for entry in manifest["books"]:
        product_code, title = split_name(entry["file"])
        books.append(
            {
                "product_code": product_code,
                "title": title,
                "filename": entry["file"],
                "pdf_pages": entry["pages"],
                "pages_with_text": entry["pages_with_text"],
                "characters_extracted": entry["characters"],
                "status": "content-indexed" if not entry["error"] else "index-error",
                "error": entry["error"],
            }
        )

    registry = {
        "collection": "Pathfinder Chronicles & Campaign Setting",
        "publisher": "Paizo",
        "extraction_date": "2026-07-21",
        "evidence_level": "Complete page-aware text index; focused contextual review of high-value passages",
        "book_count": manifest["book_count"],
        "total_pdf_pages": manifest["total_pages"],
        "pages_with_text": manifest["pages_with_text"],
        "characters_extracted": manifest["characters"],
        "scope_note": "Extracted page text remains in local tmp research storage and is not redistributed.",
        "books": books,
    }
    args.registry.parent.mkdir(parents=True, exist_ok=True)
    args.registry.write_text(json.dumps(registry, indent=2) + "\n", encoding="utf-8")

    args.catalog.parent.mkdir(parents=True, exist_ok=True)
    with args.catalog.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(books[0]))
        writer.writeheader()
        writer.writerows(books)


if __name__ == "__main__":
    main()
