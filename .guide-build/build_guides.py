#!/usr/bin/env python3
"""Render one self-contained, bilingual learning guide from a pinned source tree.
Only the requested HTML is written; Modelica source is never modified.
"""
from pathlib import Path
import argparse, csv, html, json, re, hashlib
from lessons import LESSONS, TITLES, FAULT_NAMES

E = lambda value: html.escape(str(value), quote=True)
def bi(zh, en, tag='span'):
    return f'<{tag} class="zh" lang="zh-CN">{E(zh)}</{tag}><{tag} class="en" lang="en-GB">{E(en)}</{tag}>'
def para(pair): return '<p>'+bi(*pair)+'</p>'
def code(text): return '<pre><code>'+E(text)+'</code></pre>'
def strip_annotations(text):
    out=[]; i=0
    while i<len(text):
        if text[i]=='"':
            j=i+1
            while j<len(text):
                if text[j]=='\\': j+=2; continue
                if text[j]=='"': j+=1; break
                j+=1
            out.append(text[i:j]); i=j; continue
        m=re.match(r'annotation\s*\(',text[i:]) if text.startswith('annotation',i) else None
        if m:
            j=i+m.end(); depth=1
            while j<len(text) and depth:
                if text[j]=='"':
                    j+=1
                    while j<len(text):
                        if text[j]=='\\': j+=2; continue
                        if text[j]=='"': j+=1; break
                        j+=1
                    continue
                depth+=(text[j]=='(')-(text[j]==')'); j+=1
            i=j; continue
        out.append(text[i]); i+=1
    return re.sub(r'\n\s*;\s*\n','\n',''.join(out))
def statements(text):
    rows=[]; begin=0; quote=False; escape=False
    for i,c in enumerate(text):
        if quote:
            if escape: escape=False
            elif c=='\\': escape=True
            elif c=='"': quote=False
        elif c=='"': quote=True
        elif c==';':
            rows.append(text[begin:i].strip()); begin=i+1
    return rows

def load_classes(root,repo):
    classes=[]
    for p in sorted(root.rglob('*.mo')):
        rel=p.relative_to(root).as_posix()
        if p.stem=='package' or rel.startswith('UsersGuide/'): continue
        raw=p.read_text(encoding='utf-8-sig')
        m=re.search(r'(?:^|\n)\s*((?:partial\s+|impure\s+)?)(block|model|function|record|connector|type)\s+(\w+)',raw)
        if not m: continue
        clean=strip_annotations(raw)
        head=re.search(r'(?:^|\n)\s*(?:partial\s+|impure\s+)?(?:block|model|function|record|connector|type)\s+\w+(?:\s+"((?:[^"\\]|\\.)*)")?',clean)
        description=head.group(1) if head and head.group(1) else ''
        declarations=re.split(r'^\s*(?:initial\s+)?(?:equation|algorithm)\s*$',clean,flags=re.M)[0]
        decls=statements(declarations)
        params=[]; ports=[]; instances=[]
        for s in decls:
            s=re.sub(r'^\s*(public|protected)\s*\n','',s).strip()
            if re.match(r'(?:final\s+)?parameter\s+',s): params.append(s+';')
            elif re.match(r'(?:input|output)\s+',s) or re.match(r'[\w.]*Interfaces\.[\w.]+\s+',s): ports.append(s+';')
            elif re.match(r'(?:replaceable\s+)?(?:Modelica|'+re.escape(repo)+r')\.[\w.]+\s+\w+',s): instances.append(s+';')
        modes=[]
        fm=re.search(r'type\s+FaultMode\s*=\s*enumeration\((.*?)\);',clean,re.S)
        if fm: modes=re.findall(r'(\w+)\s*"([^"]*)"',fm.group(1))
        ex=re.search(r'experiment\(([^)]*)\)',raw,re.S)
        exp=dict(re.findall(r'(StartTime|StopTime|Interval|Tolerance)\s*=\s*([^,\s]+)',ex.group(1))) if ex else {}
        references=set(re.findall(r'\b'+re.escape(repo)+r'\.([A-Za-z0-9_.]+)',clean))
        classes.append(dict(path=rel,key=rel[:-3].replace('/','.'),name=m.group(3),kind=m.group(2),partial='partial' in m.group(1),raw=raw,clean=clean,params=params,ports=ports,instances=instances,modes=modes,experiment=exp,description=description,refs=references))
    return classes

def title(c):
    key=c['key']; name=c['name']
    if key in TITLES: return TITLES[key]
    if name in TITLES: return TITLES[name]
    if name.startswith('Faultable'):
        native=name[len('Faultable'):]
        zh,en=FAULT_NAMES.get(native,(native,re.sub(r'(?<=[a-z])(?=[A-Z])',' ',native)))
        return ('可故障化'+zh, 'Fault-capable '+en)
    human=re.sub(r'(?<=[a-z])(?=[A-Z])',' ',name)
    return (name+'（源码辅助定义）',human+' — source support definition')

def group_for(c,lesson):
    matches=[g for g in lesson['groups'] if c['key'].startswith(g[0]+'.')]
    return max(matches,key=lambda g:len(g[0])) if matches else None

def render(root,repo,sha,out):
    lesson=LESSONS[repo]
    if sha!=lesson['sha']: raise ValueError('Source revision differs from the reviewed baseline: '+repo)
    classes=load_classes(root,repo); by_key={c['key']:c for c in classes}
    public=[c for c in classes if not c['path'].startswith(('Utilities/','Examples/'))]
    support=[c for c in classes if c['path'].startswith('Utilities/')]
    examples=[c for c in classes if c['path'].startswith('Examples/')]
    missing=[c['key'] for c in public if c['name'] not in TITLES and c['key'] not in TITLES and not c['name'].startswith('Faultable')]
    if missing: raise ValueError('Missing bilingual public titles: '+str(missing))
    authored=lesson['examples']
    if set(c['name'] for c in examples)!=set(authored): raise ValueError('Example coverage mismatch')
    version=re.findall(r'version="([^"]+)"',(root/'package.mo').read_text(encoding='utf-8-sig'))[-1]
    base=f'https://github.com/Ruizhe-Yang/{repo}/blob/{sha}/'
    source=lambda path: '<a href="'+base+path+'" target="_blank" rel="noopener">'+E(path)+'</a>'
    catalog={}
    with (root/'model-catalog.csv').open(encoding='utf-8-sig') as f:
        catalog={r['classPath']:r for r in csv.DictReader(f)}
    sections=[]
    nav=[('start','阅读路线','Reading route'),('concepts','核心概念','Core concepts'),('packages','如何选型','Choosing components'),('first','首次运行','First run'),('catalog','全部元件','Component reference'),('examples','逐例学习','Worked examples'),('study','建立自己的实验','Your own study'),('trouble','排错与边界','Troubleshooting'),('support','辅助定义','Supporting definitions'),('sources','来源与维护','Sources and maintenance')]
    def section(id,number,zh,en,body):
        sections.append(f'<section id="{id}"><div class="eyebrow">{number}</div><h2>'+bi(zh,en)+'</h2>'+body+'</section>')
    def table(heads,rows):
        return '<div class="table-wrap"><table><thead><tr>'+''.join('<th>'+bi(*h)+'</th>' for h in heads)+'</tr></thead><tbody>'+''.join('<tr>'+''.join('<td>'+x+'</td>' for x in row)+'</tr>' for row in rows)+'</tbody></table></div>'
    def callout(zh,en,kind='note'): return '<aside class="'+kind+'">'+bi(zh,en)+'</aside>'
    body=''.join(para(x) for x in lesson['intro'])
    body+=callout('本指南依据固定提交的源码编写。示例中的数值与曲线描述为源码推导的复现参考，未在本次文档工作中重新运行 Modelica 仿真。','This guide documents a fixed source revision. Numerical and curve descriptions are source-derived reproduction references; Modelica simulations were not re-run during this documentation work.')
    body+=table([('阶段','Stage'),('操作与学习目标','Action and learning objective')],[[f'{i+1:02d}',bi(*x)] for i,x in enumerate(lesson['route'])])
    body+=para(('建议先掌握一个完整示例，再按问题查找元件。每张元件卡列出实际参数和接口，并提供去除图形注解的源码；辅助类与可直接实例化的元件分别列出。','Begin with one complete example, then select components by the question being studied. Each component card contains actual parameters, interfaces and source with graphical annotations omitted. Supporting classes are distinguished from directly instantiable components.'))
    section('start','01','学习目标与阅读路线','Learning objectives and reading route',body)
    body=''
    for heading,zh,en in lesson['concepts']:
        body+='<article class="concept"><h3>'+bi(*heading)+'</h3>'+para((zh,en))+'</article>'
    body+=callout('因果信号端口用于传递数值或逻辑；电气、机械、热和流体物理端口参与网络方程。不能把物理端口当作普通输入输出，也不能用一个布尔保护请求代替实际的能量或物质通路。','Causal signal connectors convey values or logic. Electrical, mechanical, thermal and fluid connectors participate in network equations. A physical connector is not an ordinary signal input, and a Boolean request does not replace an energy or material path.')
    section('concepts','02','理解元件之前，先理解这些概念','Concepts to understand before using the components',body)
    rows=[]
    for prefix,heading,zh,en in lesson['groups']:
        members=[c for c in public if c['key'].startswith(prefix+'.')]
        if members: rows.append([f'<code>{E(prefix)}</code><br>'+bi(*heading),str(len(members)),bi(zh,en)])
    body=table([('功能分区','Functional area'),('定义数','Definitions'),('什么时候用、怎样接入','When and how to use it')],rows)
    body+=para(('下表与后文目录只使用本次源码中实际存在的定义。模型目录 CSV 的验证标签是仓库已有元数据，不代表本指南重新完成了运行验证。','The package map and reference include definitions actually present in the reviewed source. Validation labels in the repository CSV are existing metadata, not new execution evidence supplied by this guide.'))
    section('packages','03','按研究问题选择元件','Select components by the research question',body)
    first=by_key['Examples.'+lesson['first']]; exp=first['experiment']; stop=exp.get('StopTime','5');tol=exp.get('Tolerance','1e-6');start=exp.get('StartTime','0')
    body=para(('准备 Modelica Standard Library 4.0.0 和能够加载该版本的 Modelica 工具。保留源码目录结构；打开根目录 package.mo，而不是逐个加载底层 .mo 文件。克隆目录名称宜与根包名称一致。','Prepare Modelica Standard Library 4.0.0 and a Modelica tool that can load that version. Preserve the source directory structure and open the root package.mo rather than loading leaf files separately. Prefer a checkout directory named after the root package.'))
    body+=code(f'git clone https://github.com/Ruizhe-Yang/{repo}.git {repo}\ncd {repo}\ngit checkout {sha}')
    body+=table([('顺序','Step'),('图形工具中的操作','Action in a graphical tool')],[['1',bi('加载 MSL 4.0.0，再加载本库根 package.mo；检查消息窗口。','Load MSL 4.0.0, then the root package.mo; inspect loading diagnostics.')],['2',bi('打开 '+repo+'.Examples.'+lesson['first']+'，先查看 Diagram 和参数，再进入仿真设置。','Open '+repo+'.Examples.'+lesson['first']+'; inspect the Diagram and parameters before simulation settings.')],['3',bi('采用下方源码声明的实验设置。运行后先检查求解器是否正常终止，不要仅凭出现结果文件判断成功。','Use the experiment settings declared below. Check successful solver termination before interpreting any result file.')],['4',bi('绘制示例卡指定的输入、输出及资格状态；在事件前、事件中、事件后分别读值。','Plot the input, output and qualification variables listed in the example card; inspect values before, during and after each event.')]])
    body+=code(f'// Run from the repository root after MSL 4.0.0 is installed.\nloadModel(Modelica, {{"4.0.0"}});\nloadFile("package.mo");\ngetErrorString();\ncheckModel({repo}.Examples.{lesson["first"]});\nsimulate({repo}.Examples.{lesson["first"]},\n  startTime={start}, stopTime={stop}, numberOfIntervals=1000, tolerance={tol});\ngetErrorString();')
    body+=callout('脚本将输出网格统一设为 1000 个区间，仅便于第一次观察。元件内部 samplePeriod、通信服务网格或离散事件逻辑不会因此自动改变；后文同时列出各示例原有的 Interval。','The script uses 1,000 output intervals for initial inspection. This does not change an internal samplePeriod, communication service grid or discrete-event policy. The original Interval annotation is also shown for each example.')
    section('first','04','从加载到看懂第一组结果','From loading the library to interpreting the first result',body)
    body='<div class="filters"><label for="search">'+bi('搜索名称、功能或参数','Search names, functions or parameters')+'</label><input id="search" type="search" placeholder="Name / 功能 / parameter" autocomplete="off"><label for="group">'+bi('功能包','Package')+'</label><select id="group"><option value="">'+E('全部 / All')+'</option>'+''.join('<option>'+E(g)+'</option>' for g in sorted(set(c['path'].split('/')[0] for c in public)))+'</select><output id="count"></output></div>'
    def component(c,is_support=False):
        zh,en=title(c); group=group_for(c,lesson); meta=catalog.get(repo+'.'+c['key'],{})
        s='<details class="component" id="c-'+c['key']+'" data-group="'+E(c['path'].split('/')[0])+'" data-search="'+E(' '.join([c['key'],zh,en,c['description']]+c['params']))+'"><summary><code>'+E(c['key'])+'</code><span>'+bi(zh,en)+'</span><small>'+E(('partial ' if c['partial'] else '')+c['kind'])+'</small></summary><div class="inside">'
        if c['partial']: s+=callout('这是 partial 基类，不能单独仿真；通过具体派生类使用。','This is a partial base class, not a stand-alone simulation target. Use a concrete derived class.','warning')
        if c['kind']=='function': use=('通过函数调用传入下列 input 参数，并接收 output 返回值；函数不等同于具有图形接线端口的 block。纯函数适合在参数计算或方程中使用，impure 函数须按事件化调用约定使用。','Call the function with the input arguments below and receive its output values; it is not a block with graphical connectors. Pure functions can be used in parameter expressions or equations; impure functions require an appropriate event-based calling context.')
        elif c['kind']=='record': use=('声明 record 实例并逐字段赋值；再把字段绑定到本体参数或结果接口。放置记录本身不会自动修改任何本体状态。','Declare a record instance, populate its fields and bind those fields to host parameters or result interfaces. Merely declaring a record does not modify host states.')
        elif c['kind']=='type': use=('在参数或变量声明中引用该类型。枚举值必须使用此类型中实际声明的成员，不能用其他库的同名枚举互换。','Use this type in parameter or variable declarations. Enumerated values must come from this exact type; similarly named enumerations from other libraries are not interchangeable.')
        elif c['kind']=='connector': use=('用于匹配类型的连接。先确认输入输出方向及各字段语义，再连接两个组件；字符串元数据不一定包含在连接器内。','Use for type-compatible connections. Check direction and field semantics before connecting components; string metadata may reside outside the connector.')
        else: use=('在自己的实验模型中实例化此类，设置参数，连接所有启用的输入和所需物理参考，再对照示例运行。下列声明是实际源码接口；条件端口只在对应参数打开时存在。','Instantiate this class in an experiment, set its parameters, connect every enabled input and required physical reference, then compare with an example. The declarations below are actual source interfaces; conditional connectors exist only when enabled.')
        s+=para(use)
        if group: s+=para((group[2],group[3]))
        s+='<p class="source-line">'+bi('对应源码：','Source: ')+source(c['path'])+'</p>'
        if c['description']:s+='<details class="raw-note"><summary>'+bi('原始源码描述（保留原语言）','Original source description (original language retained)')+'</summary><p>'+E(c['description'])+'</p></details>'
        counterpart=meta.get('nominalCounterpart','')
        if counterpart: s+=para(('名义对照元件：'+counterpart+'。先在 Normal/零效果配置下比较名义响应，再选择故障模式。','Nominal counterpart: '+counterpart+'. First compare nominal responses in Normal/zero-effect configuration, then select a fault mode.'))
        if c['modes']:
            rows=[]
            for name,desc in c['modes']:
                label=TITLES.get('mode:'+name,(name,re.sub(r'(?<=[a-z])(?=[A-Z])',' ',name)))
                rows.append(['<code>'+E(name)+'</code>',bi(*label)])
            s+='<h4>'+bi('本元件实际提供的故障模式','Fault modes actually declared by this component')+'</h4>'+table([('枚举值','Enumeration'),('含义','Meaning')],rows)
            s+=callout('模式名称只说明选择项，不代表在任意电路或系统中都已经验证。严重度、有限开短路参数、储能状态和恢复规律必须结合下方源码与本体边界条件解释。','A mode name identifies an option, not validation in every circuit or system. Interpret severity, finite open/short parameters, stored states and recovery laws together with the implementation and host boundary conditions.')
        effective=list(c['params']); eports=list(c['ports']); inherited=[]
        for parent in re.findall(r'extends\s+'+re.escape(repo)+r'\.([A-Za-z0-9_.]+)',c['clean']):
            if parent in by_key:
                inherited.append(parent);effective=by_key[parent]['params']+effective;eports=by_key[parent]['ports']+eports
        if inherited:s+=para(('以下同时列出本库父类的声明：'+', '.join(inherited)+'。派生类的 final 修饰优先于父类默认值。','Declarations inherited from local parent classes are included: '+', '.join(inherited)+'. Final modifiers in the derived class override base defaults.'))
        if effective:s+='<details><summary>'+bi(f'参数与默认声明（{len(effective)} 项）',f'Parameters and declared defaults ({len(effective)})')+'</summary>'+code('\n'.join(effective))+'</details>'
        if eports:s+='<details><summary>'+bi(f'输入、输出和物理端口（{len(eports)} 项）',f'Inputs, outputs and physical connectors ({len(eports)})')+'</summary>'+code('\n'.join(eports))+'</details>'
        if 'Modelica.Electrical.Analog.Interfaces.OnePort' in c['clean']:
            s+=para(('物理接口还继承 OnePort 的 p、n；若有 ConditionalHeatPort，useHeatPort 决定热端口是否存在。上述本地声明并非全部继承接口的展开。','The physical interface also inherits p and n from OnePort. Where ConditionalHeatPort is used, useHeatPort controls the heat connector. The local declarations are not a flattened list of every inherited interface.'))
        directly=[]
        for ex in examples:
            if re.search(r'\b'+re.escape(repo+'.'+c['key'])+r'\b',ex['clean']):directly.append(ex['name'])
        if directly:s+='<p>'+bi('直接引用此类的示例：','Examples directly referencing this class: ')+' · '.join('<a href="#example-'+x+'">'+E(x)+'</a>' for x in directly)+'</p>'
        else:s+=para(('没有顶层示例直接引用此类；它可能通过内部辅助模型被使用。请先在最小独立模型中检查接口、翻译诊断与结果，勿把同组示例当成此类的完整验证。','No top-level example directly references this class; it may be used through a helper. Check its interfaces, translation diagnostics and results in a minimal model. An example in the same group is not complete validation of this class.'))
        s+='<details><summary>'+bi('实现与使用契约：阅读本元件源码','Implementation and usage contract: inspect the source')+'</summary>'+code(c['clean'])+'</details>'
        s+='</div></details>'
        return s
    body+=''.join(component(c) for c in public)
    body+='<p id="empty" hidden>'+bi('没有匹配的元件，请缩短关键词或清除功能包筛选。','No matching component. Shorten the query or clear the package filter.')+'</p>'
    section('catalog','05','完整元件参考：功能、参数、接入和实现','Complete component reference: purpose, parameters, connection and implementation',body)
    body=para(('每个案例都按“问题—模型装配—参数—运行—观察—解释—改动练习”阅读。以下效果是源码可支持的预期，不是新的仿真测量；请保留实际工具的日志与曲线作为自己的复现证据。','Read every example as question, assembly, parameters, execution, observation, interpretation and a controlled variation. The effects below are source-supported expectations, not new simulation measurements. Preserve your own tool logs and traces as reproduction evidence.'))
    for i,c in enumerate(examples):
        d=authored[c['name']];exp=c['experiment']
        body+='<article class="example" id="example-'+c['name']+'"><div class="eyebrow">EXAMPLE '+f'{i+1:02d}'+'</div><h3><code>'+E(c['name'])+'</code><br>'+bi(*d['title'])+'</h3>'
        for key,zh,en in [('aim','研究问题','Question'),('mechanism','如何实现','How it is assembled'),('expected','应当观察到什么','What to look for'),('change','自己动手修改','Controlled variation'),('limit','能够得出的结论与边界','Interpretation and limits')]:
            body+='<h4>'+bi(zh,en)+'</h4>'+para(d[key])
        body+='<h4>'+bi('重点观察变量','Variables to inspect')+'</h4><p class="chips">'+''.join('<code>'+E(v)+'</code>' for v in d['watch'])+'</p>'
        body+='<p>'+bi('源码声明的实验设置：','Declared experiment settings: ')+' · '.join('<code>'+E(k)+'='+E(v)+'</code>' for k,v in exp.items())+'</p>'
        body+='<details><summary>'+bi('装配组件及明确设置的参数','Instantiated components and explicit parameter settings')+'</summary>'+code('\n'.join(c['instances']+c['params']))+'</details>'
        connects=re.findall(r'connect\((.*?)\)\s*;',c['clean'],re.S)
        if connects:body+='<details><summary>'+bi('实际 connect 连线','Actual connect statements')+'</summary>'+code('\n'.join('connect('+x.strip()+');' for x in connects))+'</details>'
        body+='<details><summary>'+bi('本案例复现脚本','Reproduction script for this example')+'</summary>'+code(f'loadModel(Modelica, {{"4.0.0"}});\nloadFile("package.mo");\ncheckModel({repo}.Examples.{c["name"]});\nsimulate({repo}.Examples.{c["name"]},\n  startTime={exp.get("StartTime","0")}, stopTime={exp.get("StopTime","5")},\n  numberOfIntervals=1000, tolerance={exp.get("Tolerance","1e-6")});\ngetErrorString();')+'</details>'
        body+='<p>'+source(c['path'])+'</p></article>'
    section('examples','06','全部案例逐个学习','Learn every example step by step',body)
    body=''.join(para(p) for p in lesson['study'])
    body+=code(lesson['snippet'])
    body+=callout('上述片段是教学实验模板，不替代目标工具的翻译检查。保存为单独文件并在已加载本库后打开；不要直接覆盖库内的正式模型。','The snippet is a teaching experiment template, not a substitute for translation checks in the intended tool. Save it separately and load it after this library; do not overwrite distributed models.')
    body+=table([('必须记录','Record'),('记录方法','How to record it')],[ [bi('源码与环境','Source and environment'),bi('本库提交号、本体提交号、MSL 版本、工具版本和运行平台。','Library and host commits, MSL version, tool version and execution platform.')],[bi('干预与场景','Intervention and scenario'),bi('参数值、初始状态、接线拓扑、输入时序、各个可选端口是否启用。','Parameter values, initial states, topology, input timing and every enabled optional connector.')],[bi('数值设置','Numerical settings'),bi('仿真起止时刻、求解器、容差、最大步长（如设置）、结果输出网格、内部采样网格。','Start/stop times, solver, tolerance, maximum step where set, output grid and internal sampling grid.')],[bi('结论与证据','Conclusion and evidence'),bi('实际曲线、关键事件时刻、无效与不完整状态、与预期不符的内容。','Actual traces, event times, invalid/incomplete states and discrepancies from the expected behaviour.')]])
    section('study','07','从案例迁移到自己的科研实验','Move from examples to your own research experiment',body)
    body=''
    for heading,zh,en in lesson['trouble']:
        body+='<article class="qa"><h3>'+bi(*heading)+'</h3>'+para((zh,en))+'</article>'
    body+=para(('报错时先定位最小问题：加载失败、模型不平衡、初始化冲突、积分失败、输出不符合预期，是不同层次的问题。提交 issue 时给出最小模型、参数、工具版本、完整诊断和预期结果。不要用放宽容差掩盖接线或物理定义错误。','Separate loading failures, structural imbalance, initialisation conflicts, integration failures and unexpected outputs. An issue should include a minimal model, parameters, tool version, complete diagnostics and expected behaviour. Do not use looser tolerances to conceal topology or physical-definition errors.'))
    section('trouble','08','排错、适用边界与常见误读','Troubleshooting, scope and common misinterpretations',body)
    body=para(('这些定义用于类型、连接器、数值函数、内部实现或示例支撑。它们也全部收录，但不应把 Internal 或 Views 中的演示辅助类当作稳定的公共应用接口。','These definitions support types, connectors, numerical functions, internal implementation or demonstrations. They are included for completeness; Internal and Views helpers should not be assumed to be stable public application interfaces.'))
    body+=''.join(component(c,True) for c in support)
    section('support','09','完整辅助定义附录','Complete supporting-definition appendix',body)
    body=para(('文档版本 1.0；审阅日期 2026-11-12。库版本 '+version+'；源码基线 '+sha+'。本次仅生成学习指南，不修改 Modelica 机理方程、连接器或实验模型。','Guide version 1.0; review date 12 November 2026. Library version '+version+'; source baseline '+sha+'. This documentation work does not modify Modelica equations, connectors or experiment models.'))
    body+='<p>'+source('package.mo')+' · '+source('package.order')+' · '+source('model-catalog.csv')+' · '+source('CHANGELOG.md')+' · '+source('LICENSE')+'</p>'
    body+='<p><a href="https://doc.modelica.org/Modelica%204.0.0/Resources/helpDymola/index.html">Modelica Standard Library 4.0.0 documentation</a></p>'
    body+=para(('维护指南时先更新源码基线，再核对元件名称、参数、条件端口、FaultMode、示例实验设置和观察变量；中文和英文必须同步修改。示例数量、模型目录标签和 README 文案都不能替代真实源码与实际运行记录。','When maintaining this guide, update the source baseline and recheck class names, parameters, conditional connectors, FaultMode members, experiment settings and observable variables. Update Chinese and English together. Example counts, catalogue labels and README prose do not replace source inspection or execution records.'))
    body+=para(('GitHub 通常以源码方式显示 HTML。下载这个单文件后用浏览器打开；语言切换、目录、元件搜索、展开与打印均不依赖联网。点击源码链接时才需要访问 GitHub。','GitHub normally displays HTML as source. Download this single file and open it in a browser. Language switching, navigation, component search, expansion and printing work without a network connection; only source links require GitHub access.'))
    section('sources','10','来源、版本与维护约定','Sources, versions and maintenance',body)
    hero=''
    asset=root/'docs/assets/overview.svg'
    if asset.exists():
        svg=asset.read_text();svg=re.sub(r'<\?xml[^>]*\?>','',svg);hero='<div class="hero-figure" aria-hidden="true">'+svg+'</div>'
    head='<header><div class="eyebrow">MODELICA RESEARCH LIBRARY · LEARNING GUIDE 1.0</div><h1>'+E(repo)+'</h1><p class="subtitle">'+bi(*lesson['subtitle'])+'</p><div class="metrics"><span>v'+E(version)+'</span><span>'+bi(f'{len(public)} 个功能定义',f'{len(public)} functional definitions')+'</span><span>'+bi(f'{len(examples)} 个案例',f'{len(examples)} examples')+'</span><span>'+bi(f'{len(support)} 个辅助定义',f'{len(support)} supporting definitions')+'</span></div><p class="baseline">'+bi('固定源码：','Pinned source: ')+f'<a href="https://github.com/Ruizhe-Yang/{repo}/commit/{sha}">{sha[:12]}</a></p></header>'
    sidebar='<aside class="sidebar"><a class="brand" href="#top">'+E(repo)+'</a><div class="lang-controls"><button type="button" id="zhBtn" aria-pressed="true">中文</button><button type="button" id="enBtn" aria-pressed="false">English</button></div><nav aria-label="Guide chapters">'+''.join('<a href="#'+id+'"><b>'+f'{i+1:02d}'+'</b>'+bi(zh,en)+'</a>' for i,(id,zh,en) in enumerate(nav))+'</nav><div class="actions"><button type="button" id="expand">'+bi('展开全部','Expand all')+'</button><button type="button" id="collapse">'+bi('收起全部','Collapse all')+'</button><button type="button" id="print">'+bi('打印当前语言','Print this language')+'</button></div><p>MSL 4.0.0<br>12 November 2026</p></aside>'
    document='<!doctype html><html lang="zh-CN" data-language="zh"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="'+E(repo)+' bilingual Chinese and British English learning and usage guide"><title>'+E(repo)+' · 学习与使用指南 / Learning and usage guide</title><style>'+CSS.replace('ACCENT',lesson['colour'])+'</style></head><body id="top"><a class="skip" href="#start">跳转正文 / Skip to content</a>'+sidebar+'<main>'+head+hero+''.join(sections)+'<footer>'+E(repo)+' · '+bi('中文版与英式英语版共用一份可离线阅读的文件。','Chinese and British English editions in one offline-readable file.')+'</footer></main><script>'+JS+'</script></body></html>'
    ids=re.findall(r'\bid="([^"]+)"',document)
    if len(ids)!=len(set(ids)): raise ValueError('Duplicate HTML id')
    for anchor in re.findall(r'href="#([^"]+)"',document):
        if anchor not in ids: raise ValueError('Missing anchor '+anchor)
    out.parent.mkdir(parents=True,exist_ok=True);out.write_text(document,encoding='utf-8')
    return dict(repo=repo,source_sha=sha,version=version,public=len(public),support=len(support),examples=len(examples),bytes=out.stat().st_size,sha256=hashlib.sha256(out.read_bytes()).hexdigest())

CSS='''*{box-sizing:border-box}html{scroll-behavior:smooth;scroll-padding-top:24px}body{margin:0;background:#f4f6fa;color:#243247;font:16px/1.85 system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI","Microsoft YaHei",sans-serif}a{color:ACCENT;text-underline-offset:3px}button,input,select{font:inherit}button{cursor:pointer}html[data-language="zh"] .en,html[data-language="en"] .zh{display:none!important}.sidebar{position:fixed;inset:0 auto 0 0;width:270px;background:#15243a;color:#dce6f3;padding:32px 24px;overflow:auto}.brand{display:block;font-size:20px;font-weight:750;letter-spacing:-.5px;color:white;text-decoration:none;overflow-wrap:anywhere}.lang-controls{display:flex;gap:6px;margin:25px 0}.lang-controls button{flex:1;border:1px solid #60748f;border-radius:6px;background:transparent;color:#eef5ff;padding:6px;font-size:14px}.lang-controls button[aria-pressed=true]{background:#edf3fb;color:#16263d;border-color:#edf3fb}nav{display:flex;flex-direction:column;gap:7px}nav a{color:#d5dfed;display:flex;gap:10px;padding:6px 0;font-size:14px;text-decoration:none}nav a:hover{color:white}nav b{color:#879bb7;font-weight:500}.actions{display:grid;gap:6px;margin-top:24px}.actions button{border:1px solid #536780;background:transparent;color:#dce6f3;text-align:left;border-radius:5px;font-size:13px;padding:5px 10px}.sidebar p{color:#8fa5c1;font-size:12px;margin-top:22px}main{margin-left:270px;max-width:1420px;padding:58px 62px 30px}header{padding-bottom:28px}h1{font-size:clamp(32px,4.4vw,60px);line-height:1.15;letter-spacing:-1.8px;margin:15px 0 20px;overflow-wrap:anywhere}.subtitle{font-size:21px;max-width:780px;color:#52647a}.eyebrow{font-size:12px;letter-spacing:1.8px;color:ACCENT;font-weight:750}.metrics{display:flex;flex-wrap:wrap;gap:9px;margin-top:25px}.metrics>span{padding:4px 13px;border:1px solid #d5deea;background:white;border-radius:20px;font-size:13px}.baseline{font-size:12px;color:#63768d}.hero-figure{margin:0 0 28px;border-radius:10px;overflow:hidden;background:white}.hero-figure svg{display:block;width:100%;height:auto}section{background:white;border:1px solid #e1e7ef;border-radius:10px;padding:32px 36px;margin:24px 0}h2{font-size:27px;line-height:1.5;margin:5px 0 22px;letter-spacing:-.5px}h3{font-size:20px;line-height:1.6;margin:15px 0 10px}h4{font-size:15px;line-height:1.7;margin:20px 0 5px;color:ACCENT}p{margin:12px 0}code{font-family:ui-monospace,SFMono-Regular,Consolas,monospace;font-size:.88em;overflow-wrap:anywhere}p code,td code{background:#f0f4f8;padding:2px 5px;border-radius:3px}pre{background:#15243a;color:#e5edf6;padding:20px;border-radius:7px;overflow:auto;line-height:1.65;tab-size:2;font-size:13px}pre code{font-size:inherit;overflow-wrap:normal}.table-wrap{overflow-x:auto;margin:18px 0}table{border-collapse:collapse;width:100%;font-size:14px}th{background:#eff4f9;font-weight:650;text-align:left;color:#22364e}th,td{padding:12px 14px;vertical-align:top;border-bottom:1px solid #dce4ef}td:first-child{min-width:120px}td:nth-child(2){min-width:90px}.note,.warning{padding:16px 20px;border-left:4px solid ACCENT;background:#f0f5fa;border-radius:0 6px 6px 0;font-size:14px;margin:20px 0}.warning{background:#fff8ec;border-color:#c48b2a}.filters{display:grid;grid-template-columns:1fr 180px;gap:8px 14px;position:sticky;top:0;background:#fff;padding:16px 0;z-index:5;border-bottom:1px solid #e1e7ef}.filters label{font-size:12px;color:#596e85}.filters label[for=group]{grid-column:2;grid-row:1}.filters input{grid-row:2;min-width:0}.filters select{grid-row:2}.filters input,.filters select{padding:10px;border:1px solid #cdd7e4;border-radius:5px;background:white}.filters output{grid-column:1/-1;font-size:12px;color:#62758c}details{border:1px solid #dce4ee;border-radius:6px;margin:12px 0;background:#fff}summary{cursor:pointer;padding:13px 16px;font-size:14px;font-weight:600;color:#253a55}summary:focus-visible,button:focus-visible{outline:3px solid #c58a29;outline-offset:3px}.component>summary{display:grid;grid-template-columns:1fr auto;gap:2px 16px;border-left:3px solid ACCENT}.component>summary>code{grid-column:1;overflow-wrap:anywhere;font-size:14px;line-height:1.5}.component>summary>span{grid-column:1;font-weight:400;font-size:13px;color:#62738a}.component>summary>small{grid-column:2;grid-row:1/3;align-self:center;border:1px solid #d9e1ea;padding:2px 8px;border-radius:4px;font-size:11px;font-weight:500;color:#62738a}.inside{padding:2px 20px 20px}.inside details>pre{margin:0;border-radius:0 0 5px 5px}.inside details>p{padding:0 16px}.source-line{font-size:12px}.raw-note summary{font-size:12px;color:#697b91}.raw-note p{font-size:13px}.example{margin:30px 0;padding:26px;border:1px solid #dce4ee;border-top:4px solid ACCENT;border-radius:6px}.example h3 code{font-size:17px;color:#57708c}.chips{display:flex;flex-wrap:wrap;gap:6px}.chips code{padding:4px 8px;background:#edf3f8;font-size:12px}.qa,.concept{padding:8px 0 16px;border-bottom:1px solid #e7ecf3}.qa:last-child,.concept:last-child{border:0}footer{font-size:12px;color:#78899c;padding:26px 0}.skip{position:absolute;left:-10000px}.skip:focus{left:285px;top:10px;z-index:99;background:white;padding:10px}[hidden]{display:none!important}@media(max-width:1050px){.sidebar{width:230px;padding:25px 18px}main{margin-left:230px;padding:38px 25px}section{padding:28px 24px}}@media(max-width:750px){.sidebar{position:relative;width:auto;padding:20px}.brand{font-size:22px}.lang-controls{max-width:250px;margin:12px 0}nav{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:2px}.actions{display:flex;flex-wrap:wrap;margin-top:12px}.sidebar p{display:none}main{margin-left:0;padding:28px 14px}section{padding:24px 18px}h1{font-size:34px}.filters{grid-template-columns:1fr 130px}.example{padding:18px}.component>summary{grid-template-columns:1fr}.component>summary>small{display:none}.inside{padding:2px 12px 12px}}@media print{body{background:white;font-size:10pt;line-height:1.6}.sidebar,.filters,.skip,.actions{display:none!important}main{margin:0;max-width:none;padding:0}section{border:0;padding:14px 0;margin:16px 0;break-before:page}header{padding:0}h1{font-size:30pt}h2{font-size:20pt}h3{font-size:14pt}.hero-figure{max-height:220px;overflow:hidden}pre{white-space:pre-wrap;background:#f4f6f8;color:#172b43;font-size:8pt;overflow-wrap:anywhere}.component,.example{break-inside:auto}summary{break-after:avoid}a{color:#24364f;text-decoration:none}thead{display:table-header-group}td,th{padding:6px}footer{border-top:1px solid #ccc}details{border-color:#ddd}.note,.warning{background:#f4f6f8}}
'''
JS='''(()=>{const root=document.documentElement;const z=document.getElementById('zhBtn'),e=document.getElementById('enBtn');const cards=[...document.querySelectorAll('#catalog .component')];const q=document.getElementById('search'),g=document.getElementById('group');function filter(){const text=q.value.trim().toLowerCase();let n=0;cards.forEach(c=>{c.hidden=!(c.dataset.search.toLowerCase().includes(text)&&(!g.value||c.dataset.group===g.value));if(!c.hidden)n++});document.getElementById('count').textContent=root.dataset.language==='zh'?`显示 ${n} / ${cards.length} 个定义`:`Showing ${n} of ${cards.length} definitions`;document.getElementById('empty').hidden=n>0}function lang(v){root.dataset.language=v;root.lang=v==='zh'?'zh-CN':'en-GB';z.setAttribute('aria-pressed',String(v==='zh'));e.setAttribute('aria-pressed',String(v==='en'));try{localStorage.setItem('modelica-guide-language',v)}catch(_){}filter()}z.addEventListener('click',()=>lang('zh'));e.addEventListener('click',()=>lang('en'));q.addEventListener('input',filter);g.addEventListener('change',filter);document.getElementById('expand').addEventListener('click',()=>document.querySelectorAll('details').forEach(d=>{if(!d.closest('[hidden]'))d.open=true}));document.getElementById('collapse').addEventListener('click',()=>document.querySelectorAll('details').forEach(d=>d.open=false));document.getElementById('print').addEventListener('click',()=>window.print());let state=[];window.addEventListener('beforeprint',()=>{state=[...document.querySelectorAll('details')].map(d=>[d,d.open]);state.forEach(([d])=>d.open=true)});window.addEventListener('afterprint',()=>state.forEach(([d,o])=>d.open=o));function reveal(){const target=document.getElementById(decodeURIComponent(location.hash.slice(1)));if(target&&target.tagName==='DETAILS'){target.hidden=false;target.open=true;target.scrollIntoView()}}window.addEventListener('hashchange',reveal);lang('zh');reveal()})();'''

if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('--source',type=Path,required=True);ap.add_argument('--repo',required=True);ap.add_argument('--sha',required=True);ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
    result=render(args.source,args.repo,args.sha,args.output)
    print(json.dumps(result,ensure_ascii=False,sort_keys=True))
