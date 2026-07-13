from pathlib import Path
import json
import sys

root = Path(__file__).resolve().parents[1]
required = [
    'codex/01_PILLARS_OF_DEMIDIUS.md',
    'engines/01_PROBABILITY_ENGINE.md',
    'engines/02_MAGICAL_SUPREMACY_ENGINE.md',
    'appendices/campaign-rules.md',
    'database/rules.json',
    'database/artifacts.json',
    'database/divine_abilities.json',
    'database/campaign_assets.json',
    'database/pillars.json',
]
missing = [p for p in required if not (root / p).exists()]
if missing:
    print('Missing required files:')
    for item in missing:
        print(f'- {item}')
    sys.exit(1)

rules = json.loads((root / 'database/rules.json').read_text(encoding='utf-8'))
ids = [r['id'] for r in rules]
for expected in [f'CR-{i:02d}' for i in range(1, 25)]:
    if expected not in ids:
        print('Missing rule', expected)
        sys.exit(1)

artifacts = json.loads((root / 'database/artifacts.json').read_text(encoding='utf-8'))
if any(a['name'] == 'Seven-Pipped Gem' for a in artifacts):
    print('Seven-Pipped Gem incorrectly classified as artifact')
    sys.exit(1)

divine = json.loads((root / 'database/divine_abilities.json').read_text(encoding='utf-8'))
if not any(a['name'] == 'Seven-Pipped Gem' for a in divine):
    print('Seven-Pipped Gem missing from divine abilities')
    sys.exit(1)

print(
    f'Validated repository: {len(rules)} rules, '
    f'{len(artifacts)} artifacts, {len(divine)} divine abilities.'
)
