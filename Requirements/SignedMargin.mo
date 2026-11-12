within EvaluationLibrary.Requirements;
block SignedMargin "连续累计相对安全裕量的缺口"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,66},{106,78}}), iconTransformation(extent={{94,66},{106,78}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  parameter Real normalization(min=Modelica.Constants.small) = 1 "裕量归一化尺度，输入单位";
  Modelica.Blocks.Interfaces.RealInput available "实际可用量" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput required "任务要求" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput margin "瞬时归一化裕量" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  Modelica.Blocks.Interfaces.RealOutput deficitArea(unit="s",start=0,fixed=true) "负裕量幅值的时间积分" annotation(Placement(transformation(extent={{94,-78},{106,-66}}), iconTransformation(extent={{94,-78},{106,-66}})));
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
initial equation
  assert(normalization > 0 and abs(normalization) < Modelica.Constants.inf, "Normalization must be finite and positive.");
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid and abs(available) < Modelica.Constants.inf and abs(required) < Modelica.Constants.inf;
  margin = if dataOK then (available-required)/normalization else 0;
  der(deficitArea) = if inWindow and dataOK then max(0,-margin) else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-58,10},{62,10}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Polygon(points={{-4,10},{12,-19},{33,-8},{43,10},{-4,10}}, lineColor={128,128,128}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Line(points={{-57,24},{-27,31},{-4,10},{12,-19},{33,-8},{60,34}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{15,10},{15,-19}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="margin", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="SignedMargin")}),
    Documentation(info="<html><p><b>Purpose</b> 连续累计相对安全裕量的缺口</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.RealInput available \"实际可用量\"; Modelica.Blocks.Interfaces.RealInput required \"任务要求\"; Modelica.Blocks.Interfaces.RealOutput margin \"瞬时归一化裕量\"; Modelica.Blocks.Interfaces.RealOutput deficitArea(unit=\"s\",start=0,fixed=true) \"负裕量幅值的时间积分\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Real normalization(min=Modelica.Constants.small) = 1 \"裕量归一化尺度，输入单位\"</p><p><b>Behavior</b> 连续累计相对安全裕量的缺口</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p>
<p>连续累计相对安全裕量的缺口</p>
<p>专业分类为 LimitChecks.Range。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput available \"实际可用量\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput required \"任务要求\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput margin \"瞬时归一化裕量\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput deficitArea(unit=\"s\",start=0,fixed=true) \"负裕量幅值的时间积分\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Real normalization(min=Modelica.Constants.small) = 1 \"裕量归一化尺度，输入单位\"</code></li>
</ul>
<p><b>时序与基准行为</b> 缺口只在可用量严格不足时累计，等于要求时不累计。</p>
<p><b>最小用法</b> 接可用供给能力和任务最小需求，以同单位设置尺度。 <a href=\"modelica://EvaluationLibrary.Examples.FirstOrderResponse\">FluidSystemPerformanceEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 输出是持续时间加权缺口。瞬时 margin 在窗口外仍可观察。</p>
</html>"));
end SignedMargin;
