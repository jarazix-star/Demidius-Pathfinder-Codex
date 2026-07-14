import csv, pathlib
p=pathlib.Path(__file__).parents[1]/'database'/'super_genius_advanced_options.csv'
rows=list(csv.DictReader(p.open(encoding='utf-8')))
required=['name','type','book','pdf_page','summary','rating','verification_status']
bad=[r['name'] for r in rows if any(not r[k] for k in required)]
assert not bad, bad
assert len(rows)==97, len(rows)
print(f'Validated {len(rows)} Super Genius options.')
