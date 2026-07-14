import csv, pathlib
p=pathlib.Path(__file__).parents[1]/'database'/'super_genius_advanced_options_batch2.csv'
rows=list(csv.DictReader(p.open(encoding='utf-8')))
assert len(rows)==126
assert all(r['name'] and r['book'] and r['pdf_page'] and r['summary'] for r in rows)
print('Validated',len(rows),'batch-2 options')
