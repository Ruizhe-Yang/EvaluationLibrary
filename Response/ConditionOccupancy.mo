within EvaluationLibrary.Response;
block ConditionOccupancy "量化危险状态占用比例并按用户预算判定"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,66},{106,78}}), iconTransformation(extent={{94,66},{106,78}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  parameter Real budget(min=0,max=1) = 0.05 "允许占用比例";
  Modelica.Blocks.Interfaces.BooleanInput unsafe "真实危险状态" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput duration(unit="s",start=0,fixed=true) "危险状态累计时长" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  Modelica.Blocks.Interfaces.RealOutput fraction "危险时长占有效时长之比" annotation(Placement(transformation(extent={{94,-78},{106,-66}}), iconTransformation(extent={{94,-78},{106,-66}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "占用预算判定";
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
initial equation
  assert(budget >= 0 and budget <= 1, "Occupancy budget must be in [0,1].");
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid;
  der(duration) = if inWindow and dataOK and unsafe then 1 else 0;
  fraction = if noEvent(observedDuration > 0) then min(1,max(0,duration/observedDuration)) else 0;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if fraction <= budget then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-48,-19},{-25,26}}, lineColor={235,235,235}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-7,-19},{43,26}}, lineColor={235,235,235}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-61,-19},{-48,-19},{-48,26},{-25,26},{-25,-19},{-7,-19},{-7,26},{43,26},{43,-19},{63,-19}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-59,-37},{61,-37}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="Ttrue / T", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="ConditionOccupancy")}),
    Documentation(info="<html><p><b>Purpose</b> 量化危险状态占用比例并按用户预算判定</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.BooleanInput unsafe \"真实危险状态\"; Modelica.Blocks.Interfaces.RealOutput duration(unit=\"s\",start=0,fixed=true) \"危险状态累计时长\"; Modelica.Blocks.Interfaces.RealOutput fraction \"危险时长占有效时长之比\"; output EvaluationLibrary.Utilities.Types.Verdict verdict \"占用预算判定\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Real budget(min=0,max=1) = 0.05 \"允许占用比例\"</p><p><b>Behavior</b> 量化危险状态占用比例并按用户预算判定</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.FirstOrderResponse\">EvaluationLibrary.Examples.FirstOrderResponse</a></p>
<p>量化危险状态占用比例并按用户预算判定</p>
<p>专业分类为 TimeDomainAnalysis.Duration。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput unsafe \"真实危险状态\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput duration(unit=\"s\",start=0,fixed=true) \"危险状态累计时长\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput fraction \"危险时长占有效时长之比\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.Verdict verdict \"占用预算判定\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Real budget(min=0,max=1) = 0.05 \"允许占用比例\"</code></li>
</ul>
<p><b>时序与基准行为</b> 分子和分母均按有效时间累计。等于预算通过。</p>
<p><b>最小用法</b> 接角度、温度、压力等生成的危险条件。 <a href=\"modelica://EvaluationLibrary.Examples.ResultAggregationAndFiles\">ThermalSafetyEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 占用比例是轨迹的时间描述。瞬时危险可能具有零时长，应另用包络判据。</p>
</html>"));
end ConditionOccupancy;
