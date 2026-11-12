within EvaluationLibrary.Statistics;
block EnergyEfficiency "按已定义输入和有用输出功率计算能量效率"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  parameter Modelica.Units.SI.Energy minimumInput(min=Modelica.Constants.small) = 1e-3 "最小有效输入能量，J";
  parameter Real requiredEfficiency(min=0,max=1) = 0.8 "通过的最低效率";
  Modelica.Blocks.Interfaces.RealInput inputPower(unit="W") "非负输入功率" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput usefulPower(unit="W") "非负有用输出功率" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput inputEnergy(unit="J",start=0,fixed=true) "输入能量" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput usefulEnergy(unit="J",start=0,fixed=true) "有用输出能量" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.RealOutput efficiency "输出能量除以输入能量" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "效率判定";
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
initial equation
  assert(minimumInput > 0 and requiredEfficiency >= 0 and requiredEfficiency <= 1, "Invalid efficiency limits.");
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid and abs(inputPower) < Modelica.Constants.inf and abs(usefulPower) < Modelica.Constants.inf and inputPower >= 0 and usefulPower >= 0;
  der(inputEnergy) = if inWindow and dataOK then inputPower else 0;
  der(usefulEnergy) = if inWindow and dataOK then usefulPower else 0;
  efficiency = if inputEnergy >= minimumInput then usefulEnergy/inputEnergy else 0;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if inputEnergy < minimumInput then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED elseif efficiency >= requiredEfficiency then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-67,17},{-34,17}}, color={0,0,127}, thickness=1.4, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Rectangle(extent={{-32,-10},{18,44}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{20,17},{64,17}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-7,-10},{-7,-40}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-64,59},{-30,32}}, textString="E", textColor={64,64,64}, fontSize=0),
        Text(extent={{27,58},{66,33}}, textString="Eᵤ", textColor={64,64,64}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="η", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="EnergyEfficiency")}),
    Documentation(info="<html><p><b>Purpose</b> 按已定义输入和有用输出功率计算能量效率</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.RealInput inputPower(unit=\"W\") \"非负输入功率\"; Modelica.Blocks.Interfaces.RealInput usefulPower(unit=\"W\") \"非负有用输出功率\"; Modelica.Blocks.Interfaces.RealOutput inputEnergy(unit=\"J\",start=0,fixed=true) \"输入能量\"; Modelica.Blocks.Interfaces.RealOutput usefulEnergy(unit=\"J\",start=0,fixed=true) \"有用输出能量\"; Modelica.Blocks.Interfaces.RealOutput efficiency \"输出能量除以输入能量\"; output EvaluationLibrary.Utilities.Types.Verdict verdict \"效率判定\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Modelica.Units.SI.Energy minimumInput(min=Modelica.Constants.small) = 1e-3 \"最小有效输入能量，J\"; parameter Real requiredEfficiency(min=0,max=1) = 0.8 \"通过的最低效率\"</p><p><b>Behavior</b> 按已定义输入和有用输出功率计算能量效率</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">EvaluationLibrary.Examples.AnalyticStatistics</a></p>
<p>按已定义输入和有用输出功率计算能量效率</p>
<p>专业分类为 PerformanceMetrics.EffortAndEnergy。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput inputPower(unit=\"W\") \"非负输入功率\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput usefulPower(unit=\"W\") \"非负有用输出功率\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput inputEnergy(unit=\"J\",start=0,fixed=true) \"输入能量\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput usefulEnergy(unit=\"J\",start=0,fixed=true) \"有用输出能量\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput efficiency \"输出能量除以输入能量\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.Verdict verdict \"效率判定\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Modelica.Units.SI.Energy minimumInput(min=Modelica.Constants.small) = 1e-3 \"最小有效输入能量，J\"</code></li>
<li><code>Real requiredEfficiency(min=0,max=1) = 0.8 \"通过的最低效率\"</code></li>
</ul>
<p><b>时序与基准行为</b> 窗口内累计能量。输入不足时数值填零、判定未决。最低效率等号通过。</p>
<p><b>最小用法</b> 把源功率按进入被评系统为正，负载有用功按输出为正分别接入。 <a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">ElectricalPowerQualityEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 负功率标为无效。窗口内若释放储能，比值可大于一，需按能量边界解释。</p>
</html>"));
end EnergyEfficiency;
