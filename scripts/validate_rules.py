#!/usr/bin/env python3
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
rules = json.loads((ROOT / "database" / "rules.json").read_text(encoding="utf-8"))
ids = [r["id"] for r in rules]
errors = []
if len(ids) != len(set(ids)):
    errors.append("duplicate rule IDs")
expected = [f"CR-{i:02d}" for i in range(1, 15)]
if ids != expected:
    errors.append(f"rule IDs are not sequential: {ids}")
appendix = (ROOT / "appendices" / "campaign-rules.md").read_text(encoding="utf-8")
for rule_id in ids:
    if rule_id not in appendix:
        errors.append(f"{rule_id} missing from Markdown appendix")
for path in [ROOT / "codex" / "LUCK_ENGINE.md", ROOT / "codex" / "DISPEL_ENGINE.md", ROOT / "codex" / "HOUSE_RULES.md"]:
    text = path.read_text(encoding="utf-8")
    for ref in re.findall(r"CR-\d{2}", text):
        if ref not in ids:
            errors.append(f"unknown rule reference {ref} in {path.relative_to(ROOT)}")
if errors:
    print("Rule validation failed:")
    for e in errors:
        print("-", e)
    raise SystemExit(1)
print(f"Rule validation passed: {len(rules)} rules, sequential CR-01 through CR-14.")
