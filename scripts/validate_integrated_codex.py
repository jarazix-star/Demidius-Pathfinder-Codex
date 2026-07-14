from pathlib import Path
root=Path(__file__).parents[1]
required=[
'codex/super_genius_integration_update.md',
'codex/super_genius_synergy_matrix.md',
'codex/engines/magical_supremacy_super_genius_addendum.md',
'codex/engines/infrastructure_super_genius_addendum.md',
'codex/dawnrunner/officer_and_follower_recommendations.md'
]
for r in required:
    p=root/r
    assert p.exists() and p.stat().st_size>300, r
pages=list((root/'codex'/'recommendations').glob('*.md'))
assert len(pages)>=14, len(pages)
for p in pages:
    t=p.read_text(encoding='utf-8')
    assert '**Source:**' in t and '**Verification:**' in t
print('Integrated Codex validation passed:',len(pages),'recommendation pages')
