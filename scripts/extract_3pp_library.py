"""Create a local, page-aware search index for the third-party PF1e library.

Source PDFs remain outside Git. Extracted JSONL is written under tmp/ and is
intended only for local research. The manifest is safe to summarize into the
repository after mechanics are verified against their source pages.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

from pypdf import PdfReader


DEFAULT_PRIORITY = re.compile(
    r"oracle|wizard|arcane trickster|sorcer|spell|magic|mythic|feat|luck|fate|"
    r"leadership|pirate|sea|water|ocean|ship|craft|item|divine|god|epic|"
    r"prestige|1001 spells|deep magic|cerulean seas",
    re.IGNORECASE,
)


def index_name(root: Path, pdf: Path) -> str:
    relative = pdf.relative_to(root).as_posix()
    digest = hashlib.sha1(relative.encode("utf-8")).hexdigest()[:12]
    stem = re.sub(r"[^A-Za-z0-9._-]+", "_", pdf.stem).strip("_")[:90]
    return f"{stem}-{digest}.jsonl"


def extract_one(task: tuple[str, str, str]) -> dict:
    root_name, pdf_name, output_name = task
    root = Path(root_name)
    pdf = Path(pdf_name)
    output = Path(output_name)
    out = output / index_name(root, pdf)
    row = {
        "relative_path": pdf.relative_to(root).as_posix(),
        "publisher": pdf.relative_to(root).parts[0] if len(pdf.relative_to(root).parts) > 1 else "Unsorted",
        "size_bytes": pdf.stat().st_size,
        "pages": 0,
        "pages_with_text": 0,
        "characters": 0,
        "index_file": out.name,
        "error": None,
    }
    try:
        reader = PdfReader(str(pdf), strict=False)
        row["pages"] = len(reader.pages)
        with out.open("w", encoding="utf-8") as handle:
            for number, page in enumerate(reader.pages, start=1):
                page_error = None
                try:
                    text = (page.extract_text() or "").replace("\x00", "").strip()
                except Exception as exc:
                    text = ""
                    page_error = f"{type(exc).__name__}: {exc}"
                if text:
                    row["pages_with_text"] += 1
                    row["characters"] += len(text)
                handle.write(json.dumps({"page": number, "text": text, "error": page_error}, ensure_ascii=False) + "\n")
    except Exception as exc:
        row["error"] = f"{type(exc).__name__}: {exc}"
    return row


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--workers", type=int, default=4)
    parser.add_argument("--all", action="store_true", help="Extract every PDF instead of the priority subset")
    parser.add_argument("--include", help="Additional case-insensitive filename/path regular expression")
    parser.add_argument("--exclude", default=r"\\(?:Legendary Games|Super Genius Games)\\")
    ns = parser.parse_args()

    source = ns.source.resolve()
    output = ns.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    include = re.compile(ns.include, re.IGNORECASE) if ns.include else DEFAULT_PRIORITY
    exclude = re.compile(ns.exclude, re.IGNORECASE) if ns.exclude else None

    all_pdfs = sorted(source.rglob("*.pdf"))
    selected = []
    for pdf in all_pdfs:
        text = str(pdf)
        if exclude and exclude.search(text):
            continue
        if ns.all or include.search(text):
            selected.append(pdf)

    tasks = [(str(source), str(pdf), str(output)) for pdf in selected]
    rows = []
    with ProcessPoolExecutor(max_workers=max(1, ns.workers)) as pool:
        futures = [pool.submit(extract_one, task) for task in tasks]
        for number, future in enumerate(as_completed(futures), start=1):
            row = future.result()
            rows.append(row)
            if number % 25 == 0 or number == len(futures):
                print(f"indexed {number}/{len(futures)}")

    rows.sort(key=lambda item: item["relative_path"].casefold())
    manifest = {
        "source": str(source),
        "library_pdf_count": len(all_pdfs),
        "selected_pdf_count": len(rows),
        "total_pages": sum(item["pages"] for item in rows),
        "pages_with_text": sum(item["pages_with_text"] for item in rows),
        "characters": sum(item["characters"] for item in rows),
        "failed_books": sum(bool(item["error"]) for item in rows),
        "books": rows,
    }
    (output / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({key: value for key, value in manifest.items() if key != "books"}, indent=2))


if __name__ == "__main__":
    main()
