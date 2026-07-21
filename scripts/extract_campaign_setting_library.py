"""Build a temporary, page-aware text index for the Paizo setting library.

The extracted page text is intended for local research only and is not added to
the repository. The manifest contains bibliographic and extraction metadata.
"""

from __future__ import annotations

import argparse
import json
import re
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

from pypdf import PdfReader


def safe_stem(name: str) -> str:
    return re.sub(r"[^A-Za-z0-9._-]+", "_", name).strip("_")


def extract_one(args: tuple[str, str]) -> dict:
    pdf_name, output_dir = args
    pdf = Path(pdf_name)
    out = Path(output_dir) / f"{safe_stem(pdf.stem)}.jsonl"
    result = {
        "file": pdf.name,
        "size_bytes": pdf.stat().st_size,
        "pages": 0,
        "pages_with_text": 0,
        "characters": 0,
        "index_file": out.name,
        "error": None,
    }
    if out.exists() and out.stat().st_size:
        try:
            with out.open(encoding="utf-8") as handle:
                for line in handle:
                    row = json.loads(line)
                    result["pages"] += 1
                    text = row.get("text", "")
                    if text:
                        result["pages_with_text"] += 1
                        result["characters"] += len(text)
            if result["pages"]:
                return result
        except (OSError, json.JSONDecodeError):
            out.unlink(missing_ok=True)
    try:
        reader = PdfReader(str(pdf), strict=False)
        result["pages"] = len(reader.pages)
        with out.open("w", encoding="utf-8") as handle:
            for number, page in enumerate(reader.pages, start=1):
                error = None
                try:
                    text = page.extract_text() or ""
                except Exception as exc:  # keep the rest of a damaged book usable
                    text = ""
                    error = f"{type(exc).__name__}: {exc}"
                text = text.replace("\x00", "").strip()
                if text:
                    result["pages_with_text"] += 1
                    result["characters"] += len(text)
                handle.write(
                    json.dumps(
                        {"page": number, "text": text, "error": error},
                        ensure_ascii=False,
                    )
                    + "\n"
                )
    except Exception as exc:
        result["error"] = f"{type(exc).__name__}: {exc}"
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--workers", type=int, default=4)
    ns = parser.parse_args()

    ns.output.mkdir(parents=True, exist_ok=True)
    pdfs = sorted(ns.source.glob("*.pdf"))
    tasks = [(str(pdf), str(ns.output)) for pdf in pdfs]
    results = []
    with ProcessPoolExecutor(max_workers=ns.workers) as pool:
        futures = {pool.submit(extract_one, task): task[0] for task in tasks}
        for future in as_completed(futures):
            result = future.result()
            results.append(result)
            print(
                f"{result['file']}: {result['pages_with_text']}/{result['pages']} "
                f"pages, {result['characters']} chars"
            )

    results.sort(key=lambda row: row["file"].casefold())
    manifest = {
        "source": str(ns.source),
        "book_count": len(results),
        "total_pages": sum(row["pages"] for row in results),
        "pages_with_text": sum(row["pages_with_text"] for row in results),
        "characters": sum(row["characters"] for row in results),
        "books": results,
    }
    (ns.output / "manifest.json").write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    print(json.dumps({key: manifest[key] for key in manifest if key != "books"}, indent=2))


if __name__ == "__main__":
    main()
