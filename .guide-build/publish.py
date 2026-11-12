#!/usr/bin/env python3
"""Publish an audited guide and navigation in existing README files only."""
from pathlib import Path
import argparse, json, subprocess
from lessons import LESSONS
from build_guides import render

def git(*args):
    return subprocess.check_output(['git',*args],text=True).strip()

ap=argparse.ArgumentParser()
ap.add_argument('--repo',required=True)
ap.add_argument('--expected-hash',required=True)
ap.add_argument('--report',type=Path,required=True)
a=ap.parse_args()
base=git('rev-parse','HEAD')
expected=LESSONS[a.repo]['sha']
if base != expected:
    raise SystemExit('Publication stopped: main changed since source review. Expected '+expected+', found '+base)
if git('status','--porcelain'):
    raise SystemExit('Publication requires a clean checkout.')
target=Path('docs/LearningGuide.html')
if target.exists():
    raise SystemExit('Publication stopped: a guide already exists; review it before replacement.')
manifest=render(Path('.'),a.repo,base,target)
if manifest['sha256'] != a.expected_hash:
    raise SystemExit('Rendered guide differs from the reviewed preview.')
links={
'README.md':'> **[Detailed bilingual learning and usage guide](docs/LearningGuide.html)** — Chinese and British English in one offline-readable HTML file, with a complete component reference and every example explained. Download the HTML and open it in a browser to use language switching and search.\n',
'README_zh.md':'> **[详细学习与使用指南（中英双语 HTML）](docs/LearningGuide.html)** — 包含全部元件参考、接口与参数、逐例讲解和排错说明。下载单文件后用浏览器打开，可切换中文/英文并搜索元件。\n'
}
allowed={'docs/LearningGuide.html'}
for name,text in links.items():
    p=Path(name)
    if not p.exists():
        if name != 'README_zh.md':
            raise SystemExit('Required README is missing: '+name)
        # Preserve the maintainer's deletion; the bilingual guide supplies Chinese.
        continue
    current=p.read_text(encoding='utf-8')
    if '<!-- learning-guide:start -->' in current:
        raise SystemExit('Guide navigation already exists; review before editing.')
    lines=current.splitlines(keepends=True)
    index=next((i+1 for i,line in enumerate(lines) if ('简体中文' in line or '**English**' in line) and 'README' in line),None)
    if index is None:
        raise SystemExit('Could not locate the language navigation in '+name)
    block='\n<!-- learning-guide:start -->\n'+text+'<!-- learning-guide:end -->\n'
    lines.insert(index,block)
    updated=''.join(lines)
    if name=='README.md' and not Path('README_zh.md').exists():
        updated=updated.replace('[简体中文](README_zh.md)', '[简体中文](docs/LearningGuide.html)')
    p.write_text(updated,encoding='utf-8')
    allowed.add(name)
subprocess.run(['git','add',*sorted(allowed)],check=True)
changed=set(git('diff','--cached','--name-only').splitlines())
if changed != allowed:
    raise SystemExit('Unexpected staged paths: '+str(changed))
# HTML preformatted excerpts deliberately retain the original source whitespace.
subprocess.run(['git','diff','--cached','--check','--',*sorted(allowed-{'docs/LearningGuide.html'})],check=True)
subprocess.run(['git','config','user.name','github-actions[bot]'],check=True)
subprocess.run(['git','config','user.email','41898282+github-actions[bot]@users.noreply.github.com'],check=True)
subprocess.run(['git','commit','-m','docs: add comprehensive Chinese and British English learning guide'],check=True)
commit=git('rev-parse','HEAD')
subprocess.run(['git','push','origin','HEAD:main'],check=True)
manifest.update(published_commit=commit,changed_paths=sorted(changed))
a.report.parent.mkdir(parents=True,exist_ok=True)
a.report.write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(manifest,ensure_ascii=False,indent=2))
