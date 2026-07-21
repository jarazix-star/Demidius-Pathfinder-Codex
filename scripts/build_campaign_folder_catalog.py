"""Build a catalog for the overlapping Pathfinder Campaign folder."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from datetime import date
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("manifest", type=Path)
    parser.add_argument("source", type=Path)
    parser.add_argument("prior_source", type=Path)
    parser.add_argument("registry", type=Path)
    parser.add_argument("catalog", type=Path)
    args = parser.parse_args()

    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    prior_hashes = {
        sha256(path): path.name
        for path in sorted(args.prior_source.rglob("*.pdf"))
    }
    rows = []
    for entry in manifest["books"]:
        source_file = args.source / entry["file"]
        digest = sha256(source_file)
        duplicate_of = prior_hashes.get(digest, "")
        rows.append(
            {
                "title": source_file.stem,
                "filename": entry["file"],
                "pdf_pages": entry["pages"],
                "pages_with_text": entry["pages_with_text"],
                "characters_extracted": entry["characters"],
                "sha256": digest,
                "overlap_status": "exact-duplicate" if duplicate_of else "distinct-file",
                "duplicate_of": duplicate_of,
                "status": "content-indexed" if not entry["error"] else "index-error",
                "error": entry["error"],
            }
        )

    duplicate_count = sum(row["overlap_status"] == "exact-duplicate" for row in rows)
    registry = {
        "collection": "Pathfinder Campaign folder",
        "source_path": str(args.source),
        "publisher": "Paizo",
        "extraction_date": date.today().isoformat(),
        "evidence_level": "Complete page-aware index with exact-duplicate audit and focused contextual review",
        "book_count": manifest["book_count"],
        "total_pdf_pages": manifest["total_pages"],
        "pages_with_text": manifest["pages_with_text"],
        "characters_extracted": manifest["characters"],
        "exact_duplicate_count": duplicate_count,
        "distinct_file_count": len(rows) - duplicate_count,
        "scope_note": "Extracted page text remains in ignored local temporary storage.",
        "books": rows,
    }
    args.registry.parent.mkdir(parents=True, exist_ok=True)
    args.registry.write_text(json.dumps(registry, indent=2) + "\n", encoding="utf-8")

    args.catalog.parent.mkdir(parents=True, exist_ok=True)
    with args.catalog.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


if __name__ == "__main__":
    main()
