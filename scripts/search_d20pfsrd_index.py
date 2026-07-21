#!/usr/bin/env python3
"""Search the ignored local d20PFSRD page index without re-crawling the site."""

from __future__ import annotations

import argparse
import re
import sqlite3
from pathlib import Path


def snippet(text: str, terms: list[str], width: int = 360) -> str:
    lowered = text.lower()
    positions = [lowered.find(term.lower()) for term in terms]
    positions = [position for position in positions if position >= 0]
    center = min(positions) if positions else 0
    start = max(0, center - width // 3)
    end = min(len(text), start + width)
    value = re.sub(r"\s+", " ", text[start:end]).strip()
    return ("..." if start else "") + value + ("..." if end < len(text) else "")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("terms", nargs="+")
    parser.add_argument("--database", type=Path, default=Path("tmp/web/d20pfsrd/pages.sqlite3"))
    parser.add_argument("--limit", type=int, default=25)
    parser.add_argument("--authority", choices=["Paizo", "Third-party", "Community", "Unclassified"])
    args = parser.parse_args()

    connection = sqlite3.connect(args.database)
    clauses = ["status=200", "error=''", "word_count>0"]
    params: list[object] = []
    if args.authority:
        clauses.append("authority=?")
        params.append(args.authority)
    for term in args.terms:
        clauses.append("(lower(title) LIKE ? OR lower(body_text) LIKE ? OR lower(headings_json) LIKE ?)")
        pattern = f"%{term.lower()}%"
        params.extend([pattern, pattern, pattern])
    query = f"""
      SELECT title,url,authority,publisher,source_title,word_count,body_text
      FROM pages WHERE {' AND '.join(clauses)}
      ORDER BY (length(body_text)-length(replace(lower(body_text),lower(?),''))) DESC,
               word_count ASC LIMIT ?
    """
    params.extend([args.terms[0], args.limit])
    rows = connection.execute(query, params).fetchall()
    for index, row in enumerate(rows, 1):
        title, url, authority, publisher, source_title, word_count, body = row
        print(f"{index}. {title} [{authority}] ({word_count} words)")
        print(f"   {url}")
        if source_title or publisher:
            print(f"   Source: {source_title or 'not identified'} | Publisher: {publisher or 'not identified'}")
        print(f"   {snippet(body, args.terms)}")
    connection.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
