"""Build a resumable page-aware index for the recursive PF1 rules library."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

from pypdf import PdfReader


def safe_name(relative: str) -> str:
    readable = re.sub(r"[^A-Za-z0-9._-]+", "_", Path(relative).with_suffix("").as_posix()).strip("_")
    digest = hashlib.sha1(relative.encode("utf-8")).hexdigest()[:10]
    return f"{readable}_{digest}.jsonl"


def extract_one(args: tuple[str, str, str]) -> dict:
    pdf_name, relative, output_dir = args
    pdf = Path(pdf_name)
    out = Path(output_dir) / safe_name(relative)
    result = {
        "file": relative,
        "size_bytes": pdf.stat().st_size,
        "pages": 0,
        "pages_with_text": 0,
        "characters": 0,
        "index_file": out.name,
        "error": None,
    }
    expected_pages = None
    try:
        expected_pages = len(PdfReader(str(pdf), strict=False).pages)
    except Exception:
        pass
    if out.exists() and out.stat().st_size:
        try:
            for line in out.read_text(encoding="utf-8").splitlines():
                row = json.loads(line)
                result["pages"] += 1
                text = row.get("text", "")
                result["pages_with_text"] += bool(text)
                result["characters"] += len(text)
            if result["pages"] and result["pages"] == expected_pages:
                return result
            result.update({"pages": 0, "pages_with_text": 0, "characters": 0})
            out.unlink(missing_ok=True)
        except (OSError, json.JSONDecodeError):
            out.unlink(missing_ok=True)
    try:
        reader = PdfReader(str(pdf), strict=False)
        result["pages"] = len(reader.pages)
        with out.open("w", encoding="utf-8") as handle:
            for number, page in enumerate(reader.pages, start=1):
                error = None
                try:
                    text = (page.extract_text() or "").replace("\x00", "").strip()
                except Exception as exc:
                    text = ""
                    error = f"{type(exc).__name__}: {exc}"
                result["pages_with_text"] += bool(text)
                result["characters"] += len(text)
                handle.write(json.dumps({"page": number, "text": text, "error": error}, ensure_ascii=False) + "\n")
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
    pdfs = sorted(ns.source.rglob("*.pdf"))
    tasks = [(str(pdf), pdf.relative_to(ns.source).as_posix(), str(ns.output)) for pdf in pdfs]
    results = []
    with ProcessPoolExecutor(max_workers=ns.workers) as pool:
        futures = [pool.submit(extract_one, task) for task in tasks]
        for future in as_completed(futures):
            row = future.result()
            results.append(row)
            print(f"{row['file']}: {row['pages_with_text']}/{row['pages']} pages, {row['characters']} chars", flush=True)
    results.sort(key=lambda row: row["file"].casefold())
    manifest = {
        "source": str(ns.source),
        "book_count": len(results),
        "total_pages": sum(row["pages"] for row in results),
        "pages_with_text": sum(row["pages_with_text"] for row in results),
        "characters": sum(row["characters"] for row in results),
        "books": results,
    }
    (ns.output / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({k: v for k, v in manifest.items() if k != "books"}, indent=2), flush=True)


if __name__ == "__main__":
    main()
