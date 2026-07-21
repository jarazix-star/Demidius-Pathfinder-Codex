#!/usr/bin/env python3
"""Build a resumable, page-level local index of d20pfsrd.com.

The resulting SQLite database intentionally lives in ignored temporary storage.
Committed repository artifacts should contain metadata, citations, and original
analysis rather than a redistribution of the site's full rules text.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import datetime as dt
import gzip
import hashlib
import json
import re
import sqlite3
import threading
import time
import urllib.error
import urllib.parse
import urllib.request
import urllib.robotparser
import xml.etree.ElementTree as ET
from pathlib import Path

from lxml import html


BASE = "https://www.d20pfsrd.com/"
USER_AGENT = "DemidiusResearchIndexer/1.0 (+private Pathfinder research)"
SITEMAP_NS = {"sm": "http://www.sitemaps.org/schemas/sitemap/0.9"}
CORE_SEEDS = (
    "alternative-rule-systems/", "alignment-description/", "basics-ability-scores/",
    "bestiary/", "classes/", "equipment/", "feats/", "gamemastering/", "magic/",
    "magic/all-spells/", "magic/3rd-party-spells/", "magic-items/", "races/",
    "skills/", "traits/",
)
EXCLUDED_PREFIXES = (
    "/wp-admin/",
    "/wp-json/",
    "/wp-includes/",
    "/wp-login.php",
    "/wp-register.php",
    "/staging/",
    "/staging__trashed/",
)
EXCLUDED_SUFFIXES = (
    ".7z", ".avi", ".css", ".doc", ".docx", ".eot", ".gif", ".gz",
    ".ico", ".jpeg", ".jpg", ".js", ".m4a", ".mov", ".mp3", ".mp4",
    ".ogg", ".pdf", ".png", ".rar", ".svg", ".tar", ".tif", ".tiff",
    ".ttf", ".wav", ".webm", ".webp", ".woff", ".woff2", ".xls",
    ".xlsx", ".xml", ".zip",
)


def utcnow() -> str:
    return dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat()


def normalize_url(value: str, base: str = BASE) -> str | None:
    value = urllib.parse.urljoin(base, value.strip())
    parts = urllib.parse.urlsplit(value)
    if parts.scheme not in {"http", "https"}:
        return None
    host = (parts.hostname or "").lower()
    if host not in {"d20pfsrd.com", "www.d20pfsrd.com"}:
        return None
    path = re.sub(r"/{2,}", "/", urllib.parse.unquote(parts.path or "/"))
    if any(path.lower().startswith(prefix) for prefix in EXCLUDED_PREFIXES):
        return None
    if path.lower().endswith(EXCLUDED_SUFFIXES):
        return None
    if path.lower().endswith(("/feed", "/trackback")):
        return None
    path = urllib.parse.quote(path, safe="/%:@!$&'()*+,;=-._~")
    if not path.endswith("/") and "." not in path.rsplit("/", 1)[-1]:
        path += "/"
    return urllib.parse.urlunsplit(("https", "www.d20pfsrd.com", path, "", ""))


def fetch(url: str, timeout: int = 45) -> tuple[int, str, bytes, str, str | None]:
    request = urllib.request.Request(
        url,
        headers={
            "User-Agent": USER_AGENT,
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.5",
            "Accept-Encoding": "gzip, identity",
        },
    )
    try:
        with urllib.request.urlopen(request, timeout=timeout) as response:
            body = response.read()
            if response.headers.get("Content-Encoding", "").lower() == "gzip":
                body = gzip.decompress(body)
            return (
                response.status,
                response.headers.get("Content-Type", ""),
                body,
                response.geturl(),
                response.headers.get("Last-Modified"),
            )
    except urllib.error.HTTPError as exc:
        body = exc.read()
        if exc.headers.get("Content-Encoding", "").lower() == "gzip":
            body = gzip.decompress(body)
        return (
            exc.code,
            exc.headers.get("Content-Type", ""),
            body,
            exc.geturl(),
            exc.headers.get("Last-Modified"),
        )


def clean_text(value: str) -> str:
    return re.sub(r"\s+", " ", value).strip()


def infer_source(section15: str, path: str) -> tuple[str, str, str]:
    notice = clean_text(section15)
    body = re.sub(r"^Section 15:\s*Copyright Notice\s*", "", notice, flags=re.I).strip()
    lowered = (body + " " + path).lower()
    if "paizo" in lowered or "/paizo-" in lowered:
        authority = "Paizo"
    elif "/community-creations/" in lowered or "/fan-labs/" in lowered:
        authority = "Community"
    elif any(token in lowered for token in ("3rd-party", "third party", "open design", "kobold press", "frog god", "legendary games", "rite publishing", "super genius")):
        authority = "Third-party"
    else:
        authority = "Unclassified"

    publisher = ""
    pub_match = re.search(
        r"(?:copyright|©|\u00a9)\s*(?:19|20)\d{2}\s*,?\s*([^;]+)", body, re.I
    )
    if pub_match:
        publisher = clean_text(pub_match.group(1)).strip(" .,:-")[:160]
    if "paizo" in lowered:
        publisher = "Paizo Inc."

    source_title = ""
    if body:
        first = re.split(r"(?:©|\u00a9|copyright)", body, maxsplit=1, flags=re.I)[0]
        source_title = clean_text(first).strip(" .;:-")[:300]
    if authority == "Unclassified" and body and "copyright" in lowered:
        authority = "Third-party"
    return authority, publisher, source_title


def parse_page(requested_url: str, status: int, content_type: str, body: bytes,
               final_url: str, last_modified: str | None) -> dict:
    result = {
        "url": requested_url,
        "status": status,
        "final_url": final_url,
        "content_type": content_type,
        "last_modified": last_modified,
        "canonical_url": "",
        "title": "",
        "breadcrumbs": [],
        "headings": [],
        "body_text": "",
        "section15": "",
        "authority": "Unclassified",
        "publisher": "",
        "source_title": "",
        "word_count": 0,
        "content_hash": "",
        "links": [],
        "error": "",
    }
    if status != 200:
        result["error"] = f"HTTP {status}"
        return result
    if "html" not in content_type.lower():
        result["error"] = "non-html response"
        return result
    try:
        document = html.fromstring(body, base_url=final_url)
        canonical = document.xpath("string(//link[translate(@rel,'CANONICAL','canonical')='canonical']/@href)")
        result["canonical_url"] = normalize_url(canonical, final_url) or ""
        articles = document.xpath("//*[@id='article-content']")
        content = articles[0] if articles else None
        if content is None:
            result["error"] = "article-content not found"
            return result

        breadcrumb_nodes = content.xpath(".//*[contains(concat(' ',normalize-space(@class),' '),' breadcrumbs ')]")
        if breadcrumb_nodes:
            result["breadcrumbs"] = [clean_text(x.text_content()) for x in breadcrumb_nodes[0].xpath(".//a")]
        section_nodes = content.xpath(".//*[contains(concat(' ',normalize-space(@class),' '),' section15 ')]")
        if section_nodes:
            result["section15"] = clean_text(section_nodes[0].text_content())

        result["links"] = sorted({
            normalized
            for href in content.xpath(".//a[@href]/@href")
            if (normalized := normalize_url(href, final_url))
        })
        result["headings"] = [
            clean_text(node.text_content())
            for node in content.xpath(".//h1|.//h2|.//h3|.//h4|.//h5|.//h6")
            if clean_text(node.text_content())
        ]
        result["title"] = result["headings"][0] if result["headings"] else clean_text(document.xpath("string(//title)"))

        for node in content.xpath(".//script|.//style|.//noscript|.//*[contains(concat(' ',normalize-space(@class),' '),' breadcrumbs ')]|.//*[contains(concat(' ',normalize-space(@class),' '),' section15 ')]"):
            node.drop_tree()
        text = clean_text(content.text_content())
        result["body_text"] = text
        result["word_count"] = len(text.split())
        result["content_hash"] = hashlib.sha256(text.encode("utf-8")).hexdigest()
        result["authority"], result["publisher"], result["source_title"] = infer_source(
            result["section15"], urllib.parse.urlsplit(final_url).path
        )
    except Exception as exc:  # preserve failure details for repair/retry
        result["error"] = f"parse error: {type(exc).__name__}: {exc}"
    return result


def init_db(path: Path) -> sqlite3.Connection:
    path.parent.mkdir(parents=True, exist_ok=True)
    connection = sqlite3.connect(path)
    connection.execute("PRAGMA journal_mode=WAL")
    connection.executescript(
        """
        CREATE TABLE IF NOT EXISTS pages (
          url TEXT PRIMARY KEY, status INTEGER, final_url TEXT, canonical_url TEXT,
          content_type TEXT, title TEXT, breadcrumbs_json TEXT, headings_json TEXT,
          body_text TEXT, section15 TEXT, authority TEXT, publisher TEXT,
          source_title TEXT, word_count INTEGER, content_hash TEXT,
          last_modified TEXT, fetched_at TEXT, error TEXT
        );
        CREATE TABLE IF NOT EXISTS queue (
          url TEXT PRIMARY KEY, source TEXT, state TEXT DEFAULT 'pending'
        );
        CREATE TABLE IF NOT EXISTS links (
          source_url TEXT, target_url TEXT,
          PRIMARY KEY (source_url, target_url)
        );
        CREATE TABLE IF NOT EXISTS sitemaps (
          url TEXT PRIMARY KEY, status INTEGER, content_type TEXT,
          url_count INTEGER, checked_at TEXT, error TEXT
        );
        CREATE INDEX IF NOT EXISTS idx_pages_authority ON pages(authority);
        CREATE INDEX IF NOT EXISTS idx_pages_title ON pages(title);
        CREATE INDEX IF NOT EXISTS idx_queue_state ON queue(state);
        """
    )
    connection.commit()
    return connection


def seed_sitemaps(connection: sqlite3.Connection) -> dict:
    status, content_type, body, final_url, _ = fetch(urllib.parse.urljoin(BASE, "sitemap.xml"))
    root = ET.fromstring(body)
    child_sitemaps = [node.text.strip() for node in root.findall(".//sm:loc", SITEMAP_NS)]
    discovered: set[str] = {BASE}
    records = []
    for sitemap_url in child_sitemaps:
        sm_status, sm_type, sm_body, _, _ = fetch(sitemap_url)
        count = 0
        error = ""
        try:
            if sm_status != 200:
                raise ValueError(f"HTTP {sm_status}")
            sm_root = ET.fromstring(sm_body)
            urls = [node.text.strip() for node in sm_root.findall(".//sm:loc", SITEMAP_NS)]
            for value in urls:
                normalized = normalize_url(value)
                if normalized:
                    discovered.add(normalized)
            count = len(urls)
        except Exception as exc:
            error = f"{type(exc).__name__}: {exc}"
        records.append((sitemap_url, sm_status, sm_type, count, utcnow(), error))
    connection.executemany(
        "INSERT OR REPLACE INTO sitemaps(url,status,content_type,url_count,checked_at,error) VALUES(?,?,?,?,?,?)",
        records,
    )
    connection.executemany(
        "INSERT OR IGNORE INTO queue(url,source,state) VALUES(?,?,'pending')",
        [(url, "sitemap") for url in sorted(discovered)],
    )
    connection.commit()
    return {
        "sitemap_index_status": status,
        "sitemap_index_content_type": content_type,
        "sitemaps_declared": len(child_sitemaps),
        "seed_urls": len(discovered),
    }


def crawl(connection: sqlite3.Connection, workers: int, max_pages: int,
          request_delay: float) -> None:
    lock = threading.Lock()
    last_request = [0.0]

    def worker(url: str) -> dict:
        if request_delay:
            with lock:
                wait = request_delay - (time.monotonic() - last_request[0])
                if wait > 0:
                    time.sleep(wait)
                last_request[0] = time.monotonic()
        try:
            return parse_page(url, *fetch(url))
        except Exception as exc:
            return {
                "url": url, "status": 0, "final_url": "", "canonical_url": "",
                "content_type": "", "title": "", "breadcrumbs": [], "headings": [],
                "body_text": "", "section15": "", "authority": "Unclassified",
                "publisher": "", "source_title": "", "word_count": 0,
                "content_hash": "", "last_modified": None, "links": [],
                "error": f"fetch error: {type(exc).__name__}: {exc}",
            }

    completed = connection.execute("SELECT COUNT(*) FROM pages").fetchone()[0]
    with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as pool:
        while completed < max_pages:
            capacity = min(workers * 8, max_pages - completed)
            rows = connection.execute(
                """SELECT url FROM queue WHERE state='pending'
                   ORDER BY CASE source WHEN 'core-route' THEN 0 WHEN 'sitemap' THEN 1 ELSE 2 END, url
                   LIMIT ?""",
                (capacity,),
            ).fetchall()
            if not rows:
                break
            urls = [row[0] for row in rows]
            connection.executemany("UPDATE queue SET state='fetching' WHERE url=?", [(u,) for u in urls])
            connection.commit()
            for result in pool.map(worker, urls):
                connection.execute(
                    """INSERT OR REPLACE INTO pages(
                    url,status,final_url,canonical_url,content_type,title,breadcrumbs_json,
                    headings_json,body_text,section15,authority,publisher,source_title,
                    word_count,content_hash,last_modified,fetched_at,error
                    ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                    (
                        result["url"], result["status"], result["final_url"],
                        result["canonical_url"], result["content_type"], result["title"],
                        json.dumps(result["breadcrumbs"], ensure_ascii=False),
                        json.dumps(result["headings"], ensure_ascii=False), result["body_text"],
                        result["section15"], result["authority"], result["publisher"],
                        result["source_title"], result["word_count"], result["content_hash"],
                        result["last_modified"], utcnow(), result["error"],
                    ),
                )
                connection.execute("UPDATE queue SET state='done' WHERE url=?", (result["url"],))
                connection.executemany(
                    "INSERT OR IGNORE INTO links(source_url,target_url) VALUES(?,?)",
                    [(result["url"], target) for target in result["links"]],
                )
                connection.executemany(
                    "INSERT OR IGNORE INTO queue(url,source,state) VALUES(?,?,'pending')",
                    [(target, "internal-link") for target in result["links"]],
                )
                completed += 1
            connection.commit()
            pending = connection.execute("SELECT COUNT(*) FROM queue WHERE state='pending'").fetchone()[0]
            print(f"indexed={completed} pending={pending}", flush=True)


def write_summary(connection: sqlite3.Connection, path: Path, seed: dict) -> dict:
    total = connection.execute("SELECT COUNT(*) FROM pages").fetchone()[0]
    successful = connection.execute("SELECT COUNT(*) FROM pages WHERE status=200 AND error='' ").fetchone()[0]
    words = connection.execute("SELECT COALESCE(SUM(word_count),0) FROM pages").fetchone()[0]
    errors = connection.execute("SELECT COUNT(*) FROM pages WHERE status<>200 OR error<>''").fetchone()[0]
    authorities = dict(connection.execute("SELECT authority,COUNT(*) FROM pages GROUP BY authority").fetchall())
    queue_pending = connection.execute("SELECT COUNT(*) FROM queue WHERE state='pending'").fetchone()[0]
    sitemap_failures = connection.execute("SELECT COUNT(*) FROM sitemaps WHERE status<>200 OR error<>''").fetchone()[0]
    summary = {
        "site": BASE,
        "generated_at": utcnow(),
        **seed,
        "pages_indexed": total,
        "pages_successful": successful,
        "pages_with_errors": errors,
        "words_indexed": words,
        "authority_counts": authorities,
        "queue_pending": queue_pending,
        "sitemap_failures": sitemap_failures,
        "coverage_note": "The site's sitemap index currently declares page sitemaps that return HTTP 404. Coverage combines valid sitemap URLs with recursive internal-link discovery.",
    }
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return summary


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--database", type=Path, default=Path("tmp/web/d20pfsrd/pages.sqlite3"))
    parser.add_argument("--summary", type=Path, default=Path("tmp/web/d20pfsrd/summary.json"))
    parser.add_argument("--workers", type=int, default=6)
    parser.add_argument("--max-pages", type=int, default=60000)
    parser.add_argument("--request-delay", type=float, default=0.05)
    parser.add_argument("--no-reseed", action="store_true")
    parser.add_argument(
        "--retry-server-errors",
        action="store_true",
        help="Requeue previously indexed HTTP 5xx responses before crawling.",
    )
    parser.add_argument(
        "--reclassify-only",
        action="store_true",
        help="Refresh authority, publisher, and source-title metadata without fetching pages.",
    )
    args = parser.parse_args()

    robots = urllib.robotparser.RobotFileParser(urllib.parse.urljoin(BASE, "robots.txt"))
    robots.read()
    if not robots.can_fetch(USER_AGENT, BASE):
        raise SystemExit("robots.txt does not permit crawling the site root")

    connection = init_db(args.database)
    # A prior run can be interrupted while a batch is marked as fetching.
    # Return those URLs to the queue before either crawling or metadata-only work.
    connection.execute("UPDATE queue SET state='pending' WHERE state='fetching'")
    connection.commit()
    if args.reclassify_only:
        rows = connection.execute("SELECT url,section15 FROM pages").fetchall()
        connection.executemany(
            "UPDATE pages SET authority=?,publisher=?,source_title=? WHERE url=?",
            [(*infer_source(section15 or "", urllib.parse.urlsplit(url).path), url) for url, section15 in rows],
        )
        connection.commit()
        seed = {
            "sitemaps_declared": connection.execute("SELECT COUNT(*) FROM sitemaps").fetchone()[0],
            "seed_urls": connection.execute("SELECT COUNT(*) FROM queue WHERE source='sitemap'").fetchone()[0],
        }
        print(json.dumps(write_summary(connection, args.summary, seed), indent=2), flush=True)
        connection.close()
        return 0
    seed = seed_sitemaps(connection) if not args.no_reseed else {
        "sitemaps_declared": connection.execute("SELECT COUNT(*) FROM sitemaps").fetchone()[0],
        "seed_urls": connection.execute("SELECT COUNT(*) FROM queue WHERE source='sitemap'").fetchone()[0],
    }
    connection.executemany(
        """INSERT INTO queue(url,source,state) VALUES(?,?,'pending')
           ON CONFLICT(url) DO UPDATE SET source='core-route'
           WHERE queue.state='pending'""",
        [(urllib.parse.urljoin(BASE, route), "core-route") for route in CORE_SEEDS],
    )
    if args.retry_server_errors:
        connection.execute(
            "UPDATE queue SET state='pending' WHERE url IN (SELECT url FROM pages WHERE status BETWEEN 500 AND 599)"
        )
    connection.commit()
    crawl(connection, max(1, args.workers), max(1, args.max_pages), max(0, args.request_delay))
    print(json.dumps(write_summary(connection, args.summary, seed), indent=2), flush=True)
    connection.close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
