"""Chinese-first terminology with British English equivalents. Code identifiers are unchanged."""
def pairs(text):
    result={}
    for line in text.strip().splitlines():
        if line.strip():
            key,zh,en=line.split('|',2);result[key]=(zh,en)
    return result
TITLES=pairs('''
FrameDelay|按声明延迟缓存并交付报文|Buffer and deliver frames after a declared delay
FrameDropout|按序号规则丢弃报文|Drop frames by a deterministic ordinal policy
FrameDuplicate|复制报文并保留源身份|Duplicate frames while preserving source identity
FrameReorder|交换相邻报文并处理不完整配对|Swap adjacent frames and time out incomplete pairs
FrameReplay|重放激活前的有效报文|Replay the valid frame retained before activation
LinkOutage|阻断链路并明确不可用状态|Block the link and expose unavailability
PayloadCorruption|修改指定载荷通道的偏置与比例|Corrupt a selected payload channel by offset and scale
RateThrottle|按到达报文分组降低通过率|Throttle the admitted fraction of arriving frames
SampleClockOffset|切换采样时钟并输出实际采样时间|Shift the sampling grid and publish sample times
TimestampOffset|只改变报文报告的源时间戳|Change the reported source timestamp only
ElectricalHeating|将电气耗散传递至热端口|Transfer electrical dissipation to a thermal port
ImpactMeasurementBias|把冲击信号滤波为测量偏置|Filter a shock input into measurement bias
PressureForce|将给定压差换算为外部作用力|Convert prescribed pressure difference to external force
AddedLoad|并联带低压正则化的功率负载|Add a power load with low-voltage regularisation
ChassisLeakage|建立对独立机壳节点的泄漏通路|Create a leakage path to a separate chassis node
ParallelCurrent|增加规定电流支路|Add a prescribed-current branch
SeriesResistance|串入有限电阻并可输出发热|Insert finite series resistance with optional heat output
SeriesVoltage|串入规定电压扰动|Insert a prescribed series-voltage disturbance
ShuntConductance|增加有限并联电导|Add a finite shunt conductance
SupplyRipple|串入正弦电源纹波|Insert sinusoidal supply ripple
SwitchedCapacitiveLoad|经限流电阻接入附加电容|Connect an additional capacitor through current-limiting resistance
VoltageSag|根据独立参考值施加串联压降|Apply a series sag from an independent voltage reference
AddedResistance|增加串联线性流阻|Add a linear resistance in the flow path
Bypass|建立有限并联流体旁路|Open a finite parallel fluid bypass
MassInjection|注入指定状态的介质或抽取本体流体|Inject a prescribed fluid state or withdraw the host stream
PressureIngress|经有限阻力接通外部压力源|Connect an environmental pressure source through finite resistance
Vent|向显式环境端口开启排放通路|Open a vent to an explicit environment connection
BacklashContact|模拟有限刚度的对称间隙接触|Represent finite symmetric backlash contact
CompliantRelease|降低柔性转动连接的刚度与阻尼|Reduce stiffness and damping of a compliant rotational connection
ForceImpulse|施加有限宽度的矩形力冲量|Apply a finite rectangular force impulse
InertialLoad|由给定参考系加速度施加等效惯性力|Apply an equivalent force from prescribed frame acceleration
RotationalTorque|施加有限的外部转矩|Apply a finite external torque
RotationalViscousCoupling|增加两轴间被动黏性耦合|Add passive viscous coupling between rotational ports
TorqueImpulse|施加有限宽度的角冲量|Apply a finite rectangular angular impulse
TranslationalForce|施加有限的外部平动力|Apply a finite external translational force
TranslationalViscousCoupling|增加两端间被动黏性平动耦合|Add passive translational viscous coupling
UnilateralStop|用有限压缩接触模拟单侧限位|Represent a unilateral stop by finite compressive contact
VibrationForce|施加规定频率的振动力|Apply a prescribed-frequency vibration force
Bias|向信号叠加有符号偏置|Add a signed signal bias
BooleanFlip|在事件窗口内反转布尔量|Invert a Boolean signal during the event window
BooleanStuck|在事件窗口内强制固定布尔值|Force a fixed Boolean value while active
CommandDuration|把接受的命令替换为指定时长脉冲|Replace accepted commands by pulses of declared duration
CommandOmission|遗漏激活期间到达的完整命令|Omit a complete command accepted during activation
CommandSpurious|按时间表插入非预期完整脉冲|Insert complete spurious pulses on a declared timetable
CommandTiming|延迟在线命令或平移已知时间表|Delay an online command or shift a known timetable
Deadband|在指定中心周围施加连续死区|Apply a continuous deadband about a declared centre
Delay|在实时输入和历史延迟之间切换|Switch between live input and delayed history
Drift|每次激活后重新积累有界漂移|Accumulate a fresh bounded drift on each activation
Dropout|用后备值表示信号丢失并标注可用性|Represent signal loss with explicit fallback and availability
Freeze|保持本次激活沿捕获的输入值|Hold the input captured at the current activation edge
GainError|按一加相对误差缩放输入|Scale input by one plus a relative gain error
IntermittentLoss|对信号施加周期性中断区段|Apply periodic interruption intervals to a signal
NoiseInjection|叠加外部提供的可复现噪声|Inject externally supplied reproducible noise
PolarityReversal|在事件窗内反转信号极性|Reverse signal polarity during the event window
Quantization|按指定步长进行最近点量化|Quantise to the nearest declared grid point
RateLimit|同步后限制输出的变化速率|Synchronise then limit the output rate of change
Saturation|把输入向限幅目标过渡|Blend the input towards a saturated target
SinusoidalInterference|叠加指定频率与相位的窄带干扰|Add narrow-band sinusoidal interference
Spike|注入一次有限宽度三角尖峰|Inject one finite triangular spike
AddedConductance|增加守恒的有限热导通路|Add a conservative finite thermal-conductance path
AmbientShift|经有限热导施加环境温度变化|Apply an ambient temperature shift through finite conductance
HeatFlow|施加规定热流并记录累计热量|Apply prescribed heat flow and accumulate energy
HeatPulse|施加有限时长的矩形热量脉冲|Apply a finite rectangular thermal-energy pulse
RadiativeExchange|与明确绝对温度环境交换辐射热|Exchange radiation with an explicit absolute-temperature environment
ActionMonitor|用独立动作反馈判断确认、超时和迟到|Distinguish acknowledgement, timeout and late action from independent feedback
BooleanOverride|保护请求期间覆盖布尔命令|Override a Boolean command during protection
DegradedMode|根据可用能力请求降级或安全状态|Select degraded or safe operation from available capability
ExclusiveEnable|抑制互斥设备的同时使能冲突|Suppress conflicting enables for mutually exclusive devices
LossOfLinkFallback|分别确认失联与恢复后选择后备命令|Qualify link loss and recovery before selecting fallback
MinimumHold|维持最短驻留并立即允许紧急动作|Enforce minimum dwell while admitting emergency action immediately
MinimumOffTime|保护切断后强制最短停机时间|Enforce a minimum off-time after a protective trip
ModeFallback|按停车和降级优先级仲裁任务模式|Arbitrate stop and degraded requests over the nominal mode
OnOffDelay|分别设置接通和断开的连续确认时间|Apply independent continuous on- and off-delays
PriorityLoadAllocation|按优先顺序分配有限功率预算|Allocate a finite power budget in priority order
PrioritySelector|按紧急、保护、降级、正常顺序选择命令|Select emergency, protection, degraded or normal authority
ProtectiveRamp|以有限斜率进入和退出保护命令|Ramp into and out of a protective command
RealOverride|覆盖实数命令并约束恢复速率|Override a real command and constrain recovery
RedundantChannelSelect|按资格切换主备通道|Select primary or backup according to qualification
ResetPermission|连续安全驻留后才允许复位|Permit reset only after a continuous safe dwell
SafeStateSelector|把保护请求映射为整数安全状态命令|Map protective requests to declared integer safe-state commands
StartInterlock|联合启动条件并保留独立跳闸优先级|Combine start permissives with independent trip priority
TripLatch|锁存跳闸并只接受获准的复位沿|Latch a trip and accept only a permitted reset edge
HighLimit|带独立复位迟滞的上限保护判据|Evaluate a high limit with independent reset hysteresis
LowLimit|带独立复位迟滞的下限保护判据|Evaluate a low limit with independent reset hysteresis
OperatingWindow|按工况限定局部请求而保留紧急路径|Qualify local requests by operating mode without blocking emergencies
OutsideBand|分别输出低侧和高侧迟滞越界原因|Expose low- and high-side hysteretic out-of-band causes
Persistence|要求条件连续成立达到规定驻留时间|Require one uninterrupted qualified dwell
RateOfChange|根据显式采样有限差分判断变化率|Evaluate a rate criterion on an explicit sample grid
SensorDisagreement|在足够有效的通道中检测离散程度|Detect disagreement among sufficiently qualified channels
SequenceGuard|检查命令是否及时获得持续动作反馈|Check timely sustained feedback for a requested action
SequencePermissive|按先决条件、确认沿和截止时间接受启动证明|Accept sequence proof against prerequisites, edges and a deadline
SignalValidity|联合范围、新鲜度和外部资格判断信号|Check range, freshness and external signal qualification
Watchdog|监控真正的新计数或心跳沿|Watch for a genuinely new count or heartbeat edge
WindowEnergyTrip|依据滑动窗口内正向累计能量请求保护|Trip on accumulated positive energy in a moving window
CurrentLimiter|限制有符号电流请求|Limit a signed current request
Disconnect|以有限通断参数断开电路|Disconnect an electrical path with finite on/off parameters
DumpLoad|接入有限耗散支路释放电能|Connect a finite dump load to dissipate electrical energy
PowerDerating|降低功率需求并遵守额定边界|Derate power demand within its rated bound
SourceTransfer|先断后合地切换双电源|Transfer between supplies with break-before-make action
VoltageClamp|在对称电压阈值以上耗散母线能量|Dissipate bus energy above a symmetric voltage threshold
VoltageGuard|分别检测欠压和过压迟滞条件|Detect under- and overvoltage with separate hysteresis
BypassValve|根据保护请求开启有限旁通阀|Open a finite bypass valve on a protection request
FlowLimiter|限制有符号质量流量指令|Limit a signed mass-flow request
IsolationValve|根据保护请求关闭具有泄漏的隔离阀|Close a finite isolation valve with residual leakage
ReliefValve|按压差迟滞自动开启有限泄压通路|Open a finite relief path with differential-pressure hysteresis
ControlledStop|按规定角减速度产生停车速度指令|Generate a stop-speed command with declared angular deceleration
ForceLimiter|限制有符号平动力请求|Limit a signed force request
OverspeedGuard|持续超速后发出保护请求|Request protection after sustained overspeed
RotationalBrake|施加有限的被动黏性转动制动|Apply finite passive viscous rotational braking
TorqueLimiter|限制有符号转矩请求|Limit a signed torque request
TranslationalBrake|施加有限的被动黏性平动制动|Apply finite passive viscous translational braking
TravelGuard|按剩余行程限制朝边界运动的指令|Limit motion commands approaching a travel boundary
TravelStop|通过有限压缩接触限制相对行程|Limit relative travel through finite compressive contact
CoolingConductance|按请求增大实际热导通路|Increase a physical thermal-conductance path on demand
CoolingEnable|在实际热端抽取有限冷却功率|Extract a finite cooling power at a physical thermal port
HeatInputLimiter|限制热流指令的允许范围|Limit the permitted heat-flow command range
OverTemperatureGuard|联合过温和布防后的升温率判据|Combine overtemperature and armed temperature-rise criteria
TemperatureDerating|在两个绝对温度之间线性降额|Derate linearly between two absolute temperatures
ThermalIsolation|把传热能力降低至指定残余值|Reduce thermal conductance to a declared residual value
AnalogSelector|对有效模拟量执行可配置融合|Perform configurable fusion of qualified analogue channels
Mean3|融合三个通道的有效均值|Fuse the qualified mean of three channels
Mean5|融合五个通道的有效均值|Fuse the qualified mean of five channels
Median3|融合三个通道的有效中位数|Fuse the qualified median of three channels
Median5|融合五个通道的有效中位数|Fuse the qualified median of five channels
TrimmedMean|剔除两侧极值后计算有效均值|Compute a qualified trimmed mean
WeightedMean|按明确权重融合有效通道|Fuse qualified channels with declared weights
MOutOfN|配置任意支持规模的 m 取 n 布尔表决|Configure an m-out-of-n Boolean vote
OneOutOfThree|三通道中至少一票请求即表决|Vote one out of three channels
OneOutOfTwo|两通道中至少一票请求即表决|Vote one out of two channels
ThreeOutOfFive|五通道中至少三票请求即表决|Vote three out of five channels
ThreeOutOfThree|三通道全部请求才表决|Vote three out of three channels
TwoOutOfFive|五通道中至少两票请求即表决|Vote two out of five channels
TwoOutOfFour|四通道中至少两票请求即表决|Vote two out of four channels
TwoOutOfThree|三通道中至少两票请求即表决|Vote two out of three channels
TwoOutOfTwo|两通道全部请求才表决|Vote two out of two channels
AmbientPressureProfile|由任务海拔轨迹计算等温大气压力|Compute isothermal atmospheric pressure from mission altitude
AmbientTemperatureCycle|按指定峰时生成周期环境温度|Generate an ambient temperature cycle with a declared peak time
Atmosphere|计算干空气对流层压力、温度和密度|Evaluate dry-air tropospheric pressure, temperature and density
FluidBoundary|输出计划压力、温度和组分信号|Provide planned pressure, temperature and composition signals
FluidReservoir|用物理端口表达随计划变化的介质储库|Represent a scheduled fluid reservoir through physical ports
Gravity|在指定世界坐标系输出恒定重力向量|Provide a constant gravity vector in the declared world frame
GravitySetting|按任务坡度施加切向重力作用|Apply tangential gravity according to the planned grade
Inclination|将重力分解到上坡为正的坡道坐标|Resolve gravity in an uphill-positive slope coordinate
PositionGradeProfile|根据已知路径位置插值坡度|Interpolate grade along a known position-dependent route
Pressure|生成计划压力剖面|Generate a planned pressure profile
ScheduledIrradiance|按明暗计划及过渡时间输出辐照度|Generate scheduled irradiance with declared transitions
Temperature|生成计划温度剖面|Generate a planned temperature profile
Wind|输出三分量计划风速|Provide three planned wind-velocity components
WindProfile|组合平均与周期分量生成正常风速|Combine mean and periodic components into planned wind
ElectricalState|封装电压、电流初值和固定标志|Store electrical initial values and fixed flags
FluidState|封装流体压力、温度、组分初始化意图|Store fluid pressure, temperature and composition initialisation choices
RotationalState|封装独立角位移与角速度初值|Store independent angular-position and velocity initial values
SignalState|封装信号起始值与初始化类型|Store a signal start value and initialisation type
ThermalState|封装初温与固定初值标志|Store initial temperature and its fixed flag
TranslationalState|封装独立位置与速度初值|Store independent position and velocity initial values
CommandSchedule|生成右连续的布尔命令时间表|Generate a right-continuous Boolean timetable
DutyCycle|按计划重复运行与休息时段|Repeat planned running and rest intervals
HystereticStandby|按需求迟滞切换运行与待机|Select running or standby from hysteretic demand
LoadDemand|生成有边界的任务负荷需求|Generate bounded planned load demand
ModeSchedule|生成右连续的整数模式时间表|Generate a right-continuous integer-mode timetable
MultiModeSchedule|由阶段统一选择工况和外生负载比例|Select operating mode and external load fraction by phase
OperatingPoint|输出具有通道元数据的固定向量|Provide a fixed operating-point vector with channel metadata
PositionMove|生成两端速度和加速度平滑的位置移动|Generate a position move with smooth endpoint velocity and acceleration
PowerDemand|组合基础功率与独立任务负载|Combine base power with independent task demands
ReversibleFlowDemand|生成连续起止的正反向流量周期|Generate reversible flow cycles with continuous start and stop
SpeedSweep|生成按对数分布的正向角速度扫描|Generate a logarithmically spaced positive speed sweep
ThermalSoakSchedule|定义停机热浸泡参考与再启动标记|Define post-shutdown thermal soak and restart markers
TorqueSpeedMap|按转速表给出正常负载转矩需求|Generate planned load torque from a speed table
ValveOpeningProfile|按时段平滑开阀、运行和关阀|Schedule smooth valve opening, operation and closure
PeriodicLoadCycle|有限次重复完整负载周期|Repeat a complete load cycle a finite number of times
PeriodicProfile|有限次重复线性计划剖面|Repeat a piecewise-linear planned profile finitely
PiecewiseConstant|以右连续规则保持分段常量|Generate a right-continuous piecewise-constant profile
PiecewiseLinear|线性插值并保持两端值|Interpolate linearly with endpoint holds
Pulse|生成有限个左闭右开脉冲|Generate a finite sequence of half-open pulses
Ramp|完成有限斜坡后保持目标值|Generate a finite ramp and hold its target
RepeatingStartupCycle|重复启动、保载、停机和休息任务|Repeat startup, hold, shutdown and rest phases
ScheduledLoadEnvelope|施加计划扫频负载与平滑包络|Generate a planned swept-frequency load envelope
Sine|生成带时间窗口的计划正弦|Generate a windowed planned sinusoid
StartupHoldShutdown|用三个阶段表达任务负荷需求|Generate startup, operating and shutdown demand
Step|生成支持局部时间原点的阶跃|Generate a planned step with an optional local origin
AccessWindowSchedule|生成接入窗口及提前准备标志|Generate access windows and advance preparation markers
BranchingPhaseSchedule|在指定阶段边界接受计划跳转|Accept a planned branch at a declared phase boundary
DwellTrigger|每次连续满足驻留条件后计数一次|Count one event per continuous qualified dwell
EventSequence|计数独立计划事件并报告最近事件标识|Count distinct scheduled events and report the last identity
LocalClock|生成可重复启动的局部经过时间|Generate local elapsed time with optional retriggering
MissionClock|生成可暂停的任务局部时间|Generate pausable mission-local time
MissionLifecycle|按外部事件管理启动、暂停、恢复和结束|Manage start, pause, resume and termination from external events
PhaseSchedule|按绝对边界安排阶段并明确结束状态|Schedule absolute phases with an explicit completed state
PhaseScheduler|按阶段时长组织一次任务时间轴|Schedule one mission from phase durations
PhaseWindow|根据外部阶段编号输出资格窗口|Qualify an external phase index
TaskStatus|按中止优先级处理声明的任务事件|Process declared task events with abort priority
TimeWindow|生成绝对时间的左闭右开窗口|Generate an absolute half-open time window
AffineDiscrepancy|传播输出比例与偏置差异的区间|Propagate bounded scale and bias discrepancy
CandidateExtrema|查找有限候选观测极值及首个索引|Find observed candidate extrema and their first indices
CandidateWorstCase|汇总可行候选中的最差观测响应|Summarise the worst observed feasible candidate response
CentralSensitivity|用三点响应估计局部斜率与曲率|Estimate local slope and curvature from three responses
EnvelopeAtSamples|在相同采样网格上计算响应包络|Compute response envelopes on identical sample grids
FiniteDifference|根据输入数据计算有限差分|Compute a finite difference from supplied data
Analysis.FiniteDifference|由正负对称扰动响应计算中心差分|Compute a central difference from symmetric response values
Signals.FiniteDifference|按采样周期计算信号有限差分|Compute a sampled signal finite difference
FiniteDifferenceJacobian|由对称扰动构建局部多输出雅可比|Build a local multi-output Jacobian from symmetric perturbations
HydrostaticPressureBounds|传播密度、深度和基准压力的静压范围|Bound hydrostatic pressure from density, depth and reference pressure
InterpolationErrorBounds|用二阶导数界估计线性插值误差|Bound linear interpolation error using a second-derivative bound
LipschitzEnvelope|按给定变化率上界包围参数盒响应|Enclose a parameter-box response using supplied Lipschitz bounds
MarginRange|将响应区间转换成有符号裕量范围|Convert a response interval into a signed margin range
MonotonicityCheck|只对已观测序列判断单调关系|Classify monotonicity of the observed sequence only
NormalizedSensitivity|在参考响应足够大时归一化局部灵敏度|Normalise local sensitivity when the reference magnitude is sufficient
QuadraticRange|包括内部顶点的二次函数区间极值|Bound a quadratic including an interior stationary point
RadiativeExchangeBounds|传播面积、系数和温度的辐射交换范围|Bound radiative exchange from area, coefficient and temperature intervals
SafetyMargin|计算最差观测值到限值的有符号距离|Compute signed distance from an observed worst value to a limit
SineRange|包括内部峰谷的正弦区间传播|Bound a sine over an interval including interior extrema
TemperatureBand|在名义温度轨迹周围生成确定性带|Generate a deterministic band around nominal temperature
WindPressureBounds|传播风速和密度得到动压界|Bound dynamic pressure from speed and density intervals
AffineCoordinateMap|通过共享坐标生成相关联参数取值|Generate dependent parameter values from shared coordinates
BoxCorners|按固定顺序列举参数盒角点|Enumerate box corners in deterministic order
CartesianGrid|构建有规模上限的笛卡尔候选网格|Construct a bounded-size Cartesian candidate grid
FilterCombinations|按盒与耦合约束筛选候选并保留行号|Filter candidates by box and coupled constraints while preserving row indices
Grid1D|生成闭区间均匀网格，单点取中点|Generate a uniform closed grid with a midpoint singleton
SelectCandidate|按一基索引选择已有候选行|Select an existing candidate row by a one-based index
SharedCoordinate|用公共坐标表达选定的共同变化|Represent selected common variation using a shared coordinate
BoxFeasibility|逐坐标检查闭盒可行性|Check coordinate-wise closed-box feasibility
FilterCandidates|保持固定数组并返回可行行掩码和索引|Filter fixed-size arrays using feasibility masks and indices
LinearFeasibility|逐行检查确定性线性不等式约束|Check deterministic linear constraints row by row
AccuracyEnvelope|组合绝对与相对读数误差范围|Combine absolute and reading-relative accuracy bounds
AdditiveBound|向信号施加选定的有界加性误差|Apply a selected bounded additive error
BoundedParameterTrace|用确定性坐标驱动有界模型输入|Drive a bounded model input with deterministic coordinates
CalibrationBound|组合独立或共用的增益与偏置坐标|Combine independent or shared gain and bias coordinates
GainBound|施加相对增益误差并保留有符号输出界|Apply bounded gain error with signed output bounds
InvertCalibration|传播未知增益和零点的标定反解范围|Bound inverse calibration with uncertain gain and offset
ModelDiscrepancy|向显式基函数施加有界差异系数|Apply a bounded discrepancy coefficient to an explicit basis
QuantizationInterval|从舍入量化步长恢复相容真值区间|Recover a compatible true-value interval from rounding resolution
AbsoluteTolerance|由中心值与绝对公差构造闭区间|Construct a closed interval from centre and absolute tolerance
RelativeTolerance|按中心值幅值构造相对公差区间|Construct relative tolerance using the centre magnitude
Sets.Asymmetric.AbsoluteTolerance|由非对称绝对公差构造闭区间|Construct an interval from asymmetric absolute tolerances
Sets.Asymmetric.RelativeTolerance|由非对称比例公差构造闭区间|Construct an interval from asymmetric relative tolerances
Add|执行区间加法|Add two intervals
AffineMap|传播仿射映射并处理负比例|Map an interval affinely, including negative scale
Contains|判断包含端点的区间成员关系|Check interval membership including endpoints
Divide|在分母区间不含零时执行区间除法|Divide intervals when the denominator excludes zero
GasInventoryBounds|按理想气体关系计算初始质量范围|Bound initial gas mass using the ideal-gas relation
Hull|计算包含两个区间的最小闭区间|Compute the smallest enclosing interval hull
Intersection|计算交集并显式报告空集|Intersect intervals and expose emptiness
Interval|保存有序闭区间且由调用方维护单位|Store an ordered closed interval with caller-owned units
MechanicalStateBox|从位置与速度范围产生平动初态|Construct translational initial states from a position–velocity box
Midpoint|计算区间中点|Compute an interval midpoint
Multiply|根据四个端点乘积计算乘积范围|Bound a product using all four endpoint products
SelectPoint|用负一至一的坐标选择区间内点|Select an interval point using a coordinate in minus one to one
StoredElectricalEnergy|传播电容电感联合初始储能范围|Bound combined initial capacitor and inductor energy
Subtract|执行区间减法|Subtract two intervals
ThermalInitialEnergy|传播热容量与初温的不确定储热|Bound initial relative thermal energy
Width|计算上端点减下端点|Compute upper minus lower endpoint
ChannelConsistency|比较同一时刻有效通道的数值范围|Compare the range of qualified simultaneous channels
Improvement|按优选方向计算绝对与相对改进量|Compute absolute and relative improvement in a declared direction
LabelPerformance|统计二分类样本及分母可用性|Accumulate binary classification counts and denominator availability
MultiRunSummary|汇总显式连接且完整可比的多个运行|Summarise explicitly connected, complete and comparable runs
PairedArrivalSkew|比较两事件的首次到达时差|Compare first-arrival timing of two events
PairedDifference|比较语义明确匹配的两组结果|Compare two results with explicitly matched interpretation
SampleCorrelation|计算去均值后的样本相关系数|Compute centred sample correlation
DecayRatio|从合格正峰值测量振荡衰减|Measure decay from qualified positive sampled peaks
DiscreteSpectrum|窗口填满后计算单边有限离散傅里叶谱|Compute a one-sided finite DFT after the sample window fills
HarmonicDistortion|相对于指定基频计算谐波畸变|Compute harmonic distortion relative to a selected fundamental
SingleFrequency|计算一个指定频率的幅值和相位|Evaluate amplitude and phase at one selected frequency
ToneResponse|在共同采样窗内估计单频增益相位差|Estimate single-tone gain and phase difference on a common sample window
BooleanRequirement|要求布尔条件在有效窗口内持续满足|Require a qualified Boolean condition throughout a window
CircularErrorBound|按最短圆弧判断角误差边界|Assess angular error using the shortest circular arc
Conjunction|按有效性优先级合并必需子判定|Combine required verdicts with explicit qualification priority
LabelEpisodeDelay|测量首个真值事件内的检出时差|Measure detection delay within the first truth episode
LowerBound|评价有符号下界要求|Evaluate a signed lower-bound requirement
NumericRequirement|对完整数值证据执行声明的比较判据|Evaluate a declared numeric criterion on complete evidence
ObjectiveCompletion|按目标证据与否决条件判定完成|Assess completion from objective evidence and veto conditions
PersistenceLimit|检测连续违规超过允许时长|Detect an uninterrupted violation beyond a duration limit
ResponseDeadline|按先进先出配对评价请求响应时限|Evaluate request–response deadlines with FIFO pairing
ResponseTime|测量首次请求至实际响应的时差并判限|Measure the first request–response delay against a deadline
SignedMargin|累计有符号安全裕量的缺口|Accumulate deficits in a signed safety margin
UpperBound|评价有符号上界要求|Evaluate a signed upper-bound requirement
VectorBounds|同时评价向量各通道的边界|Evaluate bounds across vector channels
WithinBand|评价上下界之间的带内要求|Evaluate a requirement to remain within a band
ConditionOccupancy|计算条件成立的时间占比|Measure time occupancy of a condition
EventIntervals|计算事件间隔并保留有效性|Measure qualified intervals between events
FallTime|测量声明阈值间的下降时间|Measure fall time between declared levels
FirstOccurrence|记录窗口内首次合格事件|Record the first qualified event in a window
MovingAverage|按有限历史计算移动平均|Compute a moving average from finite history
OccurrenceCount|对有效事件沿计数|Count qualified event edges
OvershootUndershoot|计算相对目标的超调与欠调|Measure overshoot and undershoot relative to a target
RecoveryTime|测量扰动后满足恢复条件的时间|Measure qualified recovery after a disturbance
RepeatedResponse|区分匹配、超时、未匹配响应和删失请求|Distinguish matched, timed-out, unmatched and censored events
ResponseDelay|测量请求与响应之间的时延|Measure a request–response delay
RiseFallTime|按声明方向测量上升或下降时间|Measure rise or fall time in a declared direction
RiseTime|测量声明阈值间的上升时间|Measure rise time between declared levels
SampleHistory|保存有限容量的显式采样历史|Store an explicitly sampled finite history
SettlingTime|在完整观测终点确认最终稳定入带|Confirm final settling at the end of a complete window
SteadyStateError|计算声明稳态窗口内的误差|Measure error over a declared steady-state window
TrackingError|计算参考与实际轨迹间的跟踪误差|Measure error between reference and actual trajectories
ViolationDuration|累计合格违规条件的持续时间|Accumulate the duration of qualified violations
CSVWriter|一次性写出 CSV 并记录完成位置|Export one finalised CSV set and log its location
ConsoleWriter|向命令台输出结果并记录完成摘要|Print finalised results and a completion summary to the terminal
PartialWriter|提供写出器共用契约的抽象基类|Provide the partial shared contract for output writers
ResultTable|组织类型化结果与静态标识信息|Organise typed result rows with static metadata
TextWriter|一次性写出可读文本并记录位置|Export readable text once and log its destination
VerdictAggregator|合并必需判定并保留违规证据|Aggregate required verdicts while retaining witnesses
AbsoluteError|计算成对信号的绝对误差|Compute absolute error between paired signals
Difference|计算两个信号的有符号差值|Compute a signed difference between signals
RelativeError|在有效分母条件下计算相对误差|Compute relative error with denominator qualification
ValidityGate|显式传递和限定信号有效性|Expose and qualify signal validity
WrappedAngleError|把角度差映射为最短环绕误差|Map angular difference to a wrapped shortest-arc error
ControlEffort|统计控制作用量的投入|Measure control effort over a window
EnergyEfficiency|按合格输入输出能量评价效率|Evaluate efficiency from qualified input and output energies
GatedPeak|在指定资格条件下保留峰值|Retain a peak under explicit gating
Integral|计算有效窗口中的连续积分|Integrate over a qualified continuous window
LinearTrend|估计采样序列的线性趋势|Estimate the linear trend of a sample sequence
SampleExtrema|从有效采样点提取极值范围|Extract extrema from qualified sample points
SampleMean|计算显式有效样本的均值|Compute the mean of explicit qualified samples
SampleRMS|计算显式有效样本的均方根|Compute the RMS of explicit qualified samples
SampleVariance|计算显式采样的方差|Compute variance on an explicit sample grid
SampledMoments|累计采样矩及相关统计量|Accumulate sampled moments and related statistics
TimeMean|计算按时间加权的连续均值|Compute a continuous time-weighted mean
TimeRMS|计算按时间加权的连续均方根|Compute a continuous time-weighted RMS
TimeVariance|计算按时间加权的连续方差|Compute a continuous time-weighted variance
TotalVariation|累计采样值之间的总变差|Accumulate total variation between samples
ZeroCrossingOscillation|从过零事件描述振荡|Characterise oscillation from zero crossings
NPNFaultStage|承载 NPN 晶体管局部故障机理|Implement the local fault mechanism for an NPN transistor
LogCompletion|在产物完成后打印带时间与位置的日志|Log time and location after an output is finalised
WriteRows|按文件策略写出完整结果集|Write a complete result set under an explicit file policy
''')
FAULT_NAMES=pairs('''
Resistor|电阻|resistor
Conductor|电导|conductor
Capacitor|电容|capacitor
Inductor|电感|inductor
VariableResistor|可变电阻|variable resistor
VariableConductor|可变电导|variable conductor
VariableCapacitor|可变电容|variable capacitor
VariableInductor|可变电感|variable inductor
Potentiometer|电位器|potentiometer
Transformer|变压器|transformer
IdealTransformer|理想变压器|ideal transformer
Gyrator|回转器|gyrator
CCC|电流控制电流源|current-controlled current source
CCV|电流控制电压源|current-controlled voltage source
VCC|电压控制电流源|voltage-controlled current source
VCV|电压控制电压源|voltage-controlled voltage source
Diode|二极管|diode
ZDiode|稳压二极管|Zener diode
NPN|NPN 晶体管|NPN transistor
NMOS|NMOS 晶体管|NMOS transistor
PMOS|PMOS 晶体管|PMOS transistor
IdealDiode|理想二极管|ideal diode
IdealOpAmp|理想运算放大器|ideal operational amplifier
IdealOpAmp3Pin|三引脚运算放大器|three-pin operational amplifier
IdealOpAmpLimited|限幅运算放大器|limited operational amplifier
IdealClosingSwitch|理想闭合开关|ideal closing switch
IdealOpeningSwitch|理想断开开关|ideal opening switch
IdealTwoWaySwitch|双向切换开关|ideal two-way switch
IdealIntermediateSwitch|中间切换开关|ideal intermediate switch
ControlledIdealClosingSwitch|受控闭合开关|controlled closing switch
ControlledIdealOpeningSwitch|受控断开开关|controlled opening switch
ControlledIdealTwoWaySwitch|受控双向开关|controlled two-way switch
ControlledIdealIntermediateSwitch|受控中间开关|controlled intermediate switch
CurrentSensor|电流传感器|current sensor
VoltageSensor|电压传感器|voltage sensor
PotentialSensor|电势传感器|potential sensor
PowerSensor|功率传感器|power sensor
MultiSensor|多量传感器|multi-quantity sensor
ConstantCurrent|恒流源|constant-current source
ConstantVoltage|恒压源|constant-voltage source
CosineCurrent|余弦电流源|cosine-current source
CosineVoltage|余弦电压源|cosine-voltage source
PulseCurrent|脉冲电流源|pulse-current source
PulseVoltage|脉冲电压源|pulse-voltage source
RampCurrent|斜坡电流源|ramp-current source
RampVoltage|斜坡电压源|ramp-voltage source
SignalCurrent|信号控制电流源|signal-controlled current source
SignalVoltage|信号控制电压源|signal-controlled voltage source
SineCurrent|正弦电流源|sine-current source
SineVoltage|正弦电压源|sine-voltage source
StepCurrent|阶跃电流源|step-current source
StepVoltage|阶跃电压源|step-voltage source
SupplyVoltage|供电电压源|supply-voltage source
FirstOrder|一阶动态环节|first-order block
FixedDelay|固定延迟环节|fixed-delay block
Gain|增益环节|gain block
Limiter|限幅环节|limiter
Mass|质量块|mass
Inertia|转动惯量|inertia
Spring|弹簧|spring
Damper|阻尼器|damper
SpringDamper|弹簧阻尼器|spring–damper
Brake|制动器|brake
Clutch|离合器|clutch
OneWayClutch|单向离合器|one-way clutch
BearingFriction|轴承摩擦元件|bearing-friction component
SupportFriction|支撑摩擦元件|support-friction component
ElastoBacklash|弹性齿隙元件|elastic-backlash component
ElastoBacklash2|第二种弹性齿隙元件|alternative elastic-backlash component
ElastoGap|弹性间隙元件|elastic-gap component
Gearbox|齿轮箱|gearbox
IdealGear|理想齿轮|ideal gear
LossyGear|有损齿轮|lossy gear
IdealPlanetary|理想行星齿轮|ideal planetary gear
IdealRollingWheel|理想滚动轮|ideal rolling wheel
IdealGearR2T|转动平动变换齿轮|rotation-to-translation gear
Rod|刚性杆|rod
MassWithStopAndFriction|带限位摩擦质量块|mass with stops and friction
RollingResistance|滚动阻力元件|rolling-resistance component
Vehicle|车辆纵向模型|vehicle model
AccSensor|加速度传感器|acceleration sensor
AngleSensor|角度传感器|angle sensor
SpeedSensor|速度传感器|speed sensor
TorqueSensor|转矩传感器|torque sensor
ForceSensor|力传感器|force sensor
PositionSensor|位置传感器|position sensor
RelAccSensor|相对加速度传感器|relative acceleration sensor
RelPositionSensor|相对位置传感器|relative position sensor
RelSpeedSensor|相对速度传感器|relative speed sensor
ConstantPermeance|恒定磁导|constant permeance
ConstantReluctance|恒定磁阻|constant reluctance
VariablePermeance|可变磁导|variable permeance
VariableReluctance|可变磁阻|variable reluctance
EddyCurrent|涡流元件|eddy-current component
ElectroMagneticConverter|电磁转换器|electromagnetic converter
ElectroMagneticConverterWithLeakageInductance|带漏感电磁转换器|electromagnetic converter with leakage inductance
LeakageWithCoefficient|系数型漏磁元件|coefficient-based magnetic leakage
MagneticFluxSensor|磁通传感器|magnetic-flux sensor
MagneticPotentialDifferenceSensor|磁势差传感器|magnetic-potential-difference sensor
BodyRadiation|物体辐射元件|body-radiation component
Convection|对流换热元件|convection component
HeatCapacitor|热容|heat capacitor
ThermalConductor|热导|thermal conductor
ThermalResistor|热阻|thermal resistor
GeneralHeatFlowToTemperatureAdaptor|热流温度适配器|heat-flow-to-temperature adaptor
HeatFlowSensor|热流传感器|heat-flow sensor
TemperatureSensor|温度传感器|temperature sensor
RelTemperatureSensor|相对温度传感器|relative temperature sensor
Pipe|流体管路|pipe
OneWayValve|单向阀|one-way valve
Valve|阀门|valve
EnthalpyFlowSensor|焓流传感器|enthalpy-flow sensor
MassFlowSensor|质量流量传感器|mass-flow sensor
VolumeFlowSensor|体积流量传感器|volume-flow sensor
PressureSensor|压力传感器|pressure sensor
RelPressureSensor|压差传感器|relative-pressure sensor
ControlledPump|受控泵|controlled pump
PrescribedPump|规定转速泵|prescribed-speed pump
Pump|泵|pump
DynamicPipe|动态管道|dynamic pipe
StaticPipe|静态管道|static pipe
Density|密度传感器|density sensor
MassFlowRate|质量流量传感器|mass-flow-rate sensor
Pressure|压力传感器|pressure sensor
Temperature|温度传感器|temperature sensor
VolumeFlowRate|体积流量传感器|volume-flow-rate sensor
ValveCompressible|可压缩流体阀|compressible-fluid valve
ValveDiscrete|离散开关阀|discrete valve
ValveDiscreteRamp|渐变离散阀|ramped discrete valve
ValveLinear|线性阀|linear valve
ValveVaporizing|汽化流体阀|vaporising-fluid valve
''')
# Fault-mode wording is deliberately descriptive, not a claim of physical validation.
MODE_ZH='''Normal:名义模式;ResistanceDrift:电阻渐进漂移;ResistanceStep:电阻阶跃;OpenCircuit:有限阻抗开路;ShortCircuit:有限阻抗短路;TemperatureCoefficientDrift:温度系数漂移;Freeze:捕获并冻结输入;FreezeOpening:捕获并冻结开度;Bias:加性偏置;GainError:比例误差;Dropout:输出丢失;Stuck:固定值卡死;Saturation:输出饱和;Drift:随激活经过时间漂移;CapacitanceLoss:容量下降;CapacitanceDrift:容量漂移;ESRIncrease:等效串联电阻增加;LeakageIncrease:泄漏增加;InductanceLoss:电感下降;InductanceDrift:电感漂移;StiffnessLoss:刚度下降;StiffnessDegradation:刚度退化;StiffnessIncrease:刚度增加;DampingLoss:阻尼下降;DampingIncrease:阻尼增加;ConductanceLoss:热导下降;ThermalOpen:热开路;ThermalShort:热短路;TurnLoss:有效匝数下降;TurnShort:匝间短路等效变化;TurnsRatioDrift:变比漂移;ActuatorGainLoss:执行器增益下降;OpeningBias:开度偏置;PartialBlockage:局部堵塞;CompleteBlockage:完全堵塞;Blockage:堵塞;StuckOpen:卡在打开状态;StuckClosed:卡在闭合状态;GainDrift:增益漂移;GainLoss:增益下降;OutputLoss:输出丢失;OutputStuck:输出固定;StuckOutput:输出固定;StuckInput:输入固定;StuckCommand:命令固定;FrequencyDrift:频率漂移;AmplitudeDrift:幅值漂移;AmplitudeDrop:幅值下降;OffsetDrift:偏置漂移;FrictionIncrease:摩擦增加;FrictionLoss:摩擦下降;Wear:磨损;Seizure:卡死;InertiaDrift:转动惯量漂移;InertiaLoss:转动惯量下降;MassDrift:质量漂移;MassLoss:质量下降;MassLoadIncrease:附加质量负载;HeatTransferLoss:换热能力下降;CapacityLoss:热容下降;CapacityDrift:热容漂移;SensorLag:传感动态滞后;Fouling:结垢;EmissivityDrift:辐射系数漂移;RadiationLoss:辐射能力下降;RadiationShort:辐射耦合增强;PressureLossIncrease:压降增加;RoughnessIncrease:粗糙度增加;PumpTrip:泵跳闸;CavitationIncrease:汽蚀增强;ImpellerDamage:叶轮损伤;ShaftSeizure:轴抱死;EfficiencyLoss:效率下降;SpeedDrift:转速漂移;SpeedLoss:转速下降;StuckSpeed:转速卡死;SetpointBias:设定值偏置;TemperatureBias:温度偏置;TemperatureGainError:温度增益误差;TemperatureDropout:温度读数丢失;TemperatureStuck:温度读数固定;NoiseIncrease:噪声增加;CommandInvert:命令反相;ContactOpen:接触开路;ContactResistanceIncrease:接触电阻增加;WiperBias:滑片偏置;WiperStuck:滑片固定;TotalResistanceDrift:总电阻漂移;GroundShift:参考电势漂移;PositiveRailLoss:正电源轨丢失;NegativeRailLoss:负电源轨丢失;RailAmplitudeDrift:电源轨幅值漂移;InputOffset:输入失调;InputOffsetDrift:输入失调漂移;InputLeakage:输入泄漏;InputShort:输入短路;OutputLimitLoss:输出摆幅下降;ThresholdVoltageDrift:阈值电压漂移;TransconductanceLoss:跨导下降;OnResistanceIncrease:导通电阻增加;DrainSourceLeakage:漏源泄漏增加;StuckOff:卡在关断状态;StuckOn:卡在导通状态;ForwardGainLoss:正向电流增益下降;ReverseGainLoss:反向电流增益下降;CurrentGainLoss:电流增益下降;SaturationCurrentDrift:饱和电流漂移;JunctionLeakageIncrease:结泄漏增加;JunctionDegradation:结电容退化;CollectorEmitterOpen:集电极发射极开路;CollectorEmitterShort:集电极发射极短路;ForwardVoltageDrift:正向伏安关系漂移;ReverseLeakageIncrease:反向泄漏增加;BreakdownVoltageDrift:击穿电压漂移;ThermalRunaway:热失控等效变化;TransconductanceDrift:跨导漂移;TransresistanceDrift:跨阻漂移;StuckGain:增益固定;PrimaryGainDrift:原边增益漂移;SecondaryGainDrift:副边增益漂移;PrimaryInductanceDrift:原边电感漂移;SecondaryInductanceDrift:副边电感漂移;PrimaryOpen:原边开路;SecondaryOpen:副边开路;CouplingLoss:耦合下降;MagnetizationLoss:励磁能力下降;WindingResistanceIncrease:绕组电阻增加;ResistanceBias:电阻输入偏置;ResistanceScaleError:电阻输入比例误差;ConductanceBias:电导输入偏置;ConductanceScaleError:电导输入比例误差;ConductanceDrift:电导漂移;ConductanceStep:电导阶跃;CapacitanceBias:容量输入偏置;CapacitanceScaleError:容量输入比例误差;InductanceBias:电感输入偏置;InductanceScaleError:电感输入比例误差;Broken:断裂;PreloadShift:预紧位置漂移;BacklashIncrease:齿隙增加;GapShift:间隙漂移;ContactLoss:接触丢失;JammedContact:接触卡死;GearRatioError:齿轮比误差;LockedGear:齿轮锁死;ToothBroken:断齿;ToothDamage:齿损伤扰动;BearingFrictionIncrease:轴承摩擦增加;RotorLock:转子锁死;DrivetrainLock:传动系锁死;Sticking:黏滞卡死;Slip:滑移;Slipping:打滑;RadiusError:半径误差;LockedWheel:车轮锁死;LockedMass:质量块锁死;StopShift:限位偏移;RodDamage:杆损伤等效扰动;RodLock:杆锁死;RollingResistanceIncrease:滚阻增加;ResistanceIncrease:阻力增加;ResistanceLoss:阻力下降;TireDamage:轮胎损伤扰动;DragIncrease:气动阻力增加;AxialForceDisturbance:轴向力扰动;SurfaceContamination:表面污染;FlowLoss:流动丢失;Leakage:泄漏;StuckPosition1:卡在位置一;StuckPosition2:卡在位置二'''
import re
for item in MODE_ZH.split(';'):
    key,value=item.split(':',1)
    TITLES['mode:'+key]=(value,re.sub(r'(?<=[a-z])(?=[A-Z])',' ',key))
