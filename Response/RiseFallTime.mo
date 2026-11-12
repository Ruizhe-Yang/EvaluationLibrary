within EvaluationLibrary.Response;
block RiseFallTime "测量同向到达两个有序门限的时间差"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,49},{106,61}}), iconTransformation(extent={{94,49},{106,61}})));
  parameter Real firstLevel = 0.1 "第一门限，输入单位";
  parameter Real secondLevel = 0.9 "第二门限，输入单位";
  parameter Boolean falling = false "取 true 时按下降方向解释";
  Modelica.Blocks.Interfaces.RealInput u "连续响应轨迹" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.BooleanOutput started(start=false,fixed=true) "已达第一门限" annotation(Placement(transformation(extent={{94,21},{106,33}}), iconTransformation(extent={{94,21},{106,33}})));
  Modelica.Blocks.Interfaces.BooleanOutput finished(start=false,fixed=true) "已达第二门限" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput firstTime(unit="s",start=0,fixed=true) "第一门限时刻" annotation(Placement(transformation(extent={{94,-33},{106,-21}}), iconTransformation(extent={{94,-33},{106,-21}})));
  Modelica.Blocks.Interfaces.RealOutput secondTime(unit="s",start=0,fixed=true) "第二门限时刻" annotation(Placement(transformation(extent={{94,-61},{106,-49}}), iconTransformation(extent={{94,-61},{106,-49}})));
  Modelica.Blocks.Interfaces.RealOutput duration(unit="s") "时间差，未完成时填零" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
  Boolean firstHit;
  Boolean secondHit;
initial equation
  assert(if falling then firstLevel > secondLevel else firstLevel < secondLevel, "Levels must match the measurement direction.");
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid and abs(u) < Modelica.Constants.inf;
  firstHit = inWindow and dataOK and (if falling then u <= firstLevel else u >= firstLevel);
  secondHit = inWindow and dataOK and started and (if falling then u <= secondLevel else u >= secondLevel);
  when {initial(), firstHit} then
    started = if initial() then firstHit else true;
    firstTime = if firstHit and not pre(started) then time else pre(firstTime);
  end when;
  when {initial(), secondHit} then
    finished = if initial() then secondHit else true;
    secondTime = if secondHit and not pre(finished) then time else pre(secondTime);
  end when;
  duration = if finished then secondTime-firstTime else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-58,-10},{62,-10}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{-58,35},{62,35}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{-58,-29},{-39,-24},{-28,-10},{3,35},{25,44},{59,46}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-28,-10},{-28,-36}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{3,35},{3,-36}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{-28,-28},{3,-28}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="t_r / t_f", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="RiseFallTime")}),
    Documentation(info="<html><p><b>Purpose</b> 测量同向到达两个有序门限的时间差</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.RealInput u \"连续响应轨迹\"; Modelica.Blocks.Interfaces.BooleanOutput started(start=false,fixed=true) \"已达第一门限\"; Modelica.Blocks.Interfaces.BooleanOutput finished(start=false,fixed=true) \"已达第二门限\"; Modelica.Blocks.Interfaces.RealOutput firstTime(unit=\"s\",start=0,fixed=true) \"第一门限时刻\"; Modelica.Blocks.Interfaces.RealOutput secondTime(unit=\"s\",start=0,fixed=true) \"第二门限时刻\"; Modelica.Blocks.Interfaces.RealOutput duration(unit=\"s\") \"时间差，未完成时填零\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Real firstLevel = 0.1 \"第一门限，输入单位\"; parameter Real secondLevel = 0.9 \"第二门限，输入单位\"; parameter Boolean falling = false \"取 true 时按下降方向解释\"</p><p><b>Behavior</b> 测量同向到达两个有序门限的时间差</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.FirstOrderResponse\">EvaluationLibrary.Examples.FirstOrderResponse</a></p>
<p>测量同向到达两个有序门限的时间差</p>
<p>专业分类为 ResponseAnalysis.TransientResponse。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput u \"连续响应轨迹\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput started(start=false,fixed=true) \"已达第一门限\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput finished(start=false,fixed=true) \"已达第二门限\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput firstTime(unit=\"s\",start=0,fixed=true) \"第一门限时刻\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput secondTime(unit=\"s\",start=0,fixed=true) \"第二门限时刻\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput duration(unit=\"s\") \"时间差，未完成时填零\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Real firstLevel = 0.1 \"第一门限，输入单位\"</code></li>
<li><code>Real secondLevel = 0.9 \"第二门限，输入单位\"</code></li>
<li><code>Boolean falling = false \"取 true 时按下降方向解释\"</code></li>
</ul>
<p><b>时序与基准行为</b> 按首次到达计时。跃变同时越过两门限得到零时差，等号计入。</p>
<p><b>最小用法</b> 用目标量程的 10% 和 90% 参数定义常用上升时间。 <a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">MechanicalResponseEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 第一门限后允许回撤。finished=false 表示第二门限尚无证据。</p>
</html>"));
end RiseFallTime;
