#!/usr/bin/env python3
"""Export metadata and campaign-discovery candidates from the local site index."""

from __future__ import annotations

import argparse
import csv
import datetime as dt
import json
import re
import sqlite3
import urllib.parse
from collections import Counter, defaultdict
from pathlib import Path


PROFILES = {
    "Demidius": {
        "oracle": 5, "charisma": 3, "luck bonus": 5, "reroll": 5,
        "fortune": 4, "dispel": 6, "counterspell": 6, "caster level check": 5,
        "profession (sailor)": 6, "leadership": 5, "followers": 3,
        "divine boon": 5, "hermes": 4, "aphrodite": 4, "artifact": 3,
    },
    "Aristea": {
        "wizard": 3, "water": 2, "cold": 3, "ice": 3, "polymorph": 5,
        "shapechange": 5, "item creation": 5, "crafting": 4, "construct": 3,
        "ray": 3, "merciful spell": 5, "benthic spell": 5, "nereus": 4,
    },
    "Dawnrunner": {
        "profession (sailor)": 7, "sailing ship": 6, "ship combat": 6,
        "naval combat": 6, "siege engine": 5, "cannon": 5, "crew": 2,
        "navigation": 4, "favorable wind": 6, "control weather": 5,
        "ship speed": 6, "sails": 4, "boarding": 4,
    },
    "Party and crews": {
        "bard": 2, "bluff": 2, "alchemist": 2, "gun chemist": 6,
        "tengu": 3, "grippli": 3, "undine": 4, "oread": 4,
        "dragon disciple": 4, "sorcerer": 2, "paladin": 2, "goblin": 2,
        "weather": 2, "healing": 2, "spy": 2,
    },
}


def now_date() -> str:
    return dt.date.today().isoformat()


def category_for(url: str) -> str:
    parts = [part for part in urllib.parse.urlsplit(url).path.split("/") if part]
    return parts[0].lower() if parts else "home"


def term_count(text: str, term: str) -> int:
    return len(re.findall(re.escape(term.lower()), text.lower()))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--database", type=Path, default=Path("tmp/web/d20pfsrd/pages.sqlite3"))
    parser.add_argument("--catalog", type=Path, default=Path("research/web/d20pfsrd/PAGE_CATALOG.csv"))
    parser.add_argument("--shortlist", type=Path, default=Path("database/d20pfsrd_campaign_shortlist.csv"))
    parser.add_argument("--registry", type=Path, default=Path("database/source_registry_d20pfsrd.json"))
    parser.add_argument("--top-per-profile", type=int, default=100)
    args = parser.parse_args()

    connection = sqlite3.connect(args.database)
    rows = connection.execute(
        """SELECT url,status,final_url,canonical_url,title,breadcrumbs_json,headings_json,
                  authority,publisher,source_title,word_count,content_hash,last_modified,
                  fetched_at,error,body_text
           FROM pages ORDER BY url"""
    ).fetchall()

    args.catalog.parent.mkdir(parents=True, exist_ok=True)
    catalog_fields = [
        "url", "status", "canonical_url", "title", "category", "breadcrumbs",
        "authority", "publisher", "source_title", "word_count", "content_sha256",
        "last_modified", "fetched_at", "error",
    ]
    with args.catalog.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=catalog_fields)
        writer.writeheader()
        for row in rows:
            (url, status, _final_url, canonical, title, breadcrumbs, _headings,
             authority, publisher, source_title, word_count, content_hash,
             last_modified, fetched_at, error, _body) = row
            writer.writerow({
                "url": url,
                "status": status,
                "canonical_url": canonical,
                "title": title,
                "category": category_for(url),
                "breadcrumbs": " > ".join(json.loads(breadcrumbs or "[]")),
                "authority": authority,
                "publisher": publisher,
                "source_title": source_title,
                "word_count": word_count,
                "content_sha256": content_hash,
                "last_modified": last_modified,
                "fetched_at": fetched_at,
                "error": error,
            })

    candidates: dict[str, list[dict]] = defaultdict(list)
    for row in rows:
        (url, status, _final_url, canonical, title, breadcrumbs, headings,
         authority, publisher, source_title, word_count, _content_hash,
         _last_modified, _fetched_at, error, body) = row
        if status != 200 or error or not body or word_count < 20:
            continue
        heading_text = " ".join(json.loads(headings or "[]"))
        haystack = f"{title} {title} {heading_text} {body}"
        for profile, terms in PROFILES.items():
            matched = []
            score = 0
            for term, weight in terms.items():
                count = term_count(haystack, term)
                if count:
                    matched.append(term)
                    score += weight * min(count, 4)
                    if term.lower() in (title or "").lower():
                        score += weight * 3
            if score:
                candidates[profile].append({
                    "profile": profile,
                    "score": score,
                    "title": title,
                    "url": canonical or url,
                    "category": category_for(url),
                    "authority": authority,
                    "publisher": publisher,
                    "source_title": source_title,
                    "word_count": word_count,
                    "matched_terms": "; ".join(sorted(matched)),
                    "review_status": "discovery-indexed; contextual verification required",
                })

    shortlist = []
    for profile, values in candidates.items():
        ranked = sorted(values, key=lambda item: (-item["score"], item["title"].lower()))
        seen_urls = set()
        unique_values = []
        for item in ranked:
            if item["url"] in seen_urls:
                continue
            seen_urls.add(item["url"])
            unique_values.append(item)
            if len(unique_values) >= args.top_per_profile:
                break
        shortlist.extend(unique_values)
    args.shortlist.parent.mkdir(parents=True, exist_ok=True)
    shortlist_fields = [
        "profile", "score", "title", "url", "category", "authority", "publisher",
        "source_title", "word_count", "matched_terms", "review_status",
    ]
    with args.shortlist.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=shortlist_fields)
        writer.writeheader()
        writer.writerows(sorted(shortlist, key=lambda item: (item["profile"], -item["score"], item["title"].lower())))

    status_counts = Counter(str(row[1]) for row in rows)
    authority_counts = Counter(row[7] for row in rows)
    category_counts = Counter(category_for(row[0]) for row in rows)
    words = sum(row[10] or 0 for row in rows)
    canonical_keys = {row[3] or row[0] for row in rows}
    sitemap_rows = connection.execute(
        "SELECT url,status,content_type,url_count,checked_at,error FROM sitemaps ORDER BY url"
    ).fetchall()
    queue_counts = dict(connection.execute("SELECT state,COUNT(*) FROM queue GROUP BY state").fetchall())
    registry = {
        "collection": "d20PFSRD.com page-level discovery index",
        "site": "https://www.d20pfsrd.com/",
        "extraction_date": now_date(),
        "evidence_level": "Page-level local text index with canonical URLs, headings, Section 15 notices, attribution classification, and hashes",
        "role": "Discovery aid; verify mechanics against the attributed primary source before promotion",
        "redistribution_policy": "Full page text remains in ignored local storage. Git contains metadata, citations, and original analysis only.",
        "pages_indexed": len(rows),
        "distinct_canonical_pages": len(canonical_keys),
        "duplicate_or_alias_urls": len(rows) - len(canonical_keys),
        "words_indexed": words,
        "status_counts": dict(status_counts),
        "authority_counts": dict(authority_counts),
        "category_counts": dict(category_counts.most_common()),
        "queue_counts": queue_counts,
        "sitemaps_declared": len(sitemap_rows),
        "sitemap_failures": sum(1 for row in sitemap_rows if row[1] != 200 or row[5]),
        "sitemaps": [
            {"url": row[0], "status": row[1], "content_type": row[2], "url_count": row[3], "checked_at": row[4], "error": row[5]}
            for row in sitemap_rows
        ],
        "artifacts": {
            "local_database": "tmp/web/d20pfsrd/pages.sqlite3",
            "page_catalog": str(args.catalog).replace("\\", "/"),
            "campaign_shortlist": str(args.shortlist).replace("\\", "/"),
        },
    }
    args.registry.write_text(json.dumps(registry, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({
        "pages": len(rows), "words": words, "shortlist_rows": len(shortlist),
        "queue": queue_counts, "authorities": dict(authority_counts),
    }, indent=2))
    connection.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
