"""Apply checked, idempotent extraction refinements before rendering."""
from pathlib import Path
p = Path(__file__).with_name('build_guides.py')
s = p.read_text(encoding='utf-8')
old = 'decls=statements(declarations)'
new = 'decls=statements(declarations[head.end():] if head else declarations)'
if old in s:
    assert s.count(old) == 1
    s = s.replace(old, new)
else:
    assert new in s
p.write_text(s, encoding='utf-8')
print('Renderer declaration extraction verified.')
