from pathlib import Path

def apply(lessons, titles):
    # A concurrent maintainer commit adjusts result icons and placements; retain it.
    lessons['EvaluationLibrary']['sha']='18fb8c3ca0bf177ad0ba41ce978059170e0f4938'
    extra='''
mode:ForwardResistanceIncrease|正向导通电阻增加|Increased forward resistance
Activation|故障或异常激活与效果过渡|Activation and effect transition
EventActivation|事件激活资格与时间窗口|Event activation and timing qualification
FrameQueue|有限容量报文队列与交付策略|Bounded frame queue and delivery policies
FrameSource|生成带身份与时间戳的示例报文|Generate identified and timestamped example frames
FrameMode|选择内部报文处理策略|Select an internal frame-processing policy
Analog3Source|为三通道融合生成示例输入与资格|Supply three-channel example values and qualification
Analog5Source|为五通道融合生成示例输入与资格|Supply five-channel example values and qualification
VotePattern|生成多通道表决演示模式|Generate a multi-channel voting pattern
ValidValues|收集并排列有效通道数值|Collect and order qualified channel values
FusionFallback|定义模拟量资格不足时的后备策略|Define fallback under insufficient analogue qualification
FusionMethod|定义模拟量融合方法|Define the analogue fusion method
PhaseLoad|把阶段编号和局部时间映射为演示负荷|Map phase index and local time to an example load
Interpolate|执行计划表的数值插值|Interpolate numerical schedule values
TableIndex|寻找当前时间对应的计划表区间|Locate the active schedule-table interval
MissionState|任务生命周期状态枚举|Mission lifecycle state enumeration
OperatingMode|声明运行模式枚举|Declared operating-mode enumeration
ProfileInterpolation|剖面插值方法枚举|Profile interpolation method enumeration
TaskState|任务状态枚举|Task-state enumeration
GridSize|检查并计算网格规模|Validate and calculate grid size
Valid|检查区间端点有效性|Validate interval endpoints
validInterval|内部区间有效性检查|Internal interval validation
EvidenceState|不确定性分析证据状态|Evidence state for uncertainty analysis
MarginStatus|有符号裕量的资格状态|Qualification of a signed margin
SampleOrder|样本排序约定|Sample-order convention
Sense|明确更大或更小是否更优|Declare whether larger or smaller is preferable
ArithmeticView|区间算术示例的数值适配|Numerical view for interval-arithmetic examples
CandidateView|候选网格示例的数值适配|Numerical view for candidate-grid examples
ConstraintView|约束筛选示例的数值适配|Numerical view for constrained-candidate examples
EnvelopeView|对示例轨迹进行公共网格采样和包络|Sample example trajectories on a common grid and form an envelope
ExtremaView|比较两个有限候选集合的观测极值|Compare observed extrema of two finite candidate sets
IntervalView|公差区间与代表点的示例适配|Example view of tolerance intervals and representative points
SensitivityView|局部灵敏度示例的计算适配|Calculation view for a local-sensitivity example
Aggregate|按明确优先级合并必需判定|Aggregate required verdicts with explicit priority
FormatRow|格式化一个带资格的结果记录|Format one qualified result record
QuoteCSV|转义 CSV 文本中的引号与换行|Escape CSV text containing quotes and line breaks
SafeIdentifier|检查输出文件标识符字符集|Validate the character set of output identifiers
SampleCount|计算窗口内预期采样数量|Calculate expected samples in a window
StatusFromCode|解码数据状态整数编码|Decode the integer data-status code
StatusText|将数据状态转换为稳定文字标签|Convert data status to a stable text label
ToVerdict|由证据状态和违规记录生成判定|Derive a verdict from evidence status and witnesses
Tone|构造指定频率的分析基函数|Construct a selected-frequency analysis basis
VerdictFromCode|解码需求判定整数编码|Decode the integer verdict code
VerdictText|将判定转换为稳定文字标签|Convert a verdict to a stable text label
MetricInput|接收带资格的数值结果连接器|Receive a qualified numerical result
MetricOutput|输出带资格的数值结果连接器|Publish a qualified numerical result
ContinuousAccumulator|累积连续时间统计所需的量|Accumulate continuous-time statistics
ContinuousEvidence|维护连续观测的覆盖与有效性|Maintain continuous observation coverage and validity
SampleAccumulator|累积显式样本统计所需的量|Accumulate explicit sample statistics
SampledEvidence|维护采样证据的数量与资格|Maintain sample counts and evidence qualification
SpectrumBuffer|保存有限容量频谱分析样本|Store finite spectral-analysis samples
ToneSpectrum|在固定样本上计算单频特性|Evaluate tone characteristics on fixed samples
WindowEvidence|限定首个观测窗口并维护证据覆盖|Qualify the first observation window and track coverage
csvQuote|旧式 CSV 字符串转义辅助|Legacy CSV string escaping helper
formatResults|将旧式结果记录格式化为文本|Format legacy result records as text
oneSidedDFT|计算有限样本的单边离散傅里叶变换|Compute a one-sided finite discrete Fourier transform
DataStatus|数据覆盖与有效性状态|Data-coverage and validity status
EvidenceKind|连续、采样、事件或派生证据类型|Continuous, sampled, event or derived evidence kind
Grade|等级枚举，不等于认证等级|Grade enumeration, not a certification grade
LegacyMetricResult|保留旧式结果结构|Retain the legacy result structure
MetricResult|保存值、资格、窗口和违规证据|Store value, qualification, window and witness evidence
NumericComparison|选择数值判据比较关系|Select a numerical comparison relation
ReportFormat|选择 CSV 或文本表示|Select CSV or text representation
SpectralWindow|选择频域样本窗|Select a spectral sample window
Taper|选择离散谱的加窗方式|Select a taper for spectral analysis
Verdict|独立于数据覆盖的需求判定|Requirement verdict independent of data coverage
WindowMode|选择固定时间或单一外部窗口|Select a fixed-time or single external window
WritePolicy|明确已有文件的拒绝或覆盖策略|Declare rejection or overwrite of existing files
CapacitorCircuit|电容替换实验的 RC 本体夹具|RC fixture for capacitor replacement
ConductiveCircuit|热导与热容对照的本体夹具|Thermal fixture for conductance and capacity comparisons
ConductorCircuit|电导替换实验的电路夹具|Circuit fixture for conductor replacement
ConvectiveCircuit|对流退化实验的热网络夹具|Thermal fixture for convection degradation
ElectromagneticCircuit|电磁转换器对照的独立磁路|Independent magnetic fixture for converter comparisons
ElectromechanicalCircuit|电流、转速与温度对照的电机夹具|Motor fixture for current, speed and temperature comparisons
InductorCircuit|电感替换实验的 RL 夹具|RL fixture for inductor replacement
ReluctanceCircuit|固定磁势下的磁阻对照夹具|Reluctance fixture under prescribed magnetomotive force
ResistorCircuit|电阻替换实验的电路夹具|Circuit fixture for resistor replacement
RotationalDrive|恒转矩、惯量与阻尼对照夹具|Constant-torque, inertia and damping fixture
RotationalSpringPath|规定转角下的弹簧转矩对照|Spring-torque comparison under prescribed angle
SensorCircuit|电压与电流测量对照夹具|Voltage and current sensing fixture
SignalCircuit|公共输入下的信号环节对照夹具|Signal-block fixture with a common input
TranslationalDrive|质量、弹簧与阻尼对照夹具|Mass, spring and damping fixture
ValveCircuit|阀能力与压力测量对照夹具|Valve and pressure-sensing fixture
'''
    for line in extra.strip().splitlines():
        key,zh,en=line.split('|',2);titles[key]=(zh,en)
    p=Path(__file__).with_name('build_guides.py')
    text=p.read_text(encoding='utf-8')
    old='decls=statements(declarations[head.end():] if head else declarations)'
    new='public_declarations=re.split(r"^\\s*protected\\s*$", declarations[head.end():] if head else declarations, maxsplit=1, flags=re.M)[0]\n        decls=statements(public_declarations)'
    if old in text:
        text=text.replace(old,new)
    else:
        assert 'public_declarations=' in text
    text=text.replace('body{margin:0;background:', 'body{margin:0;overflow-wrap:anywhere;background:')
    p.write_text(text,encoding='utf-8')
