within EvaluationLibrary.Requirements;
block LabelEpisodeDelay "评价首个真值事件内的检出时差"
  parameter Modelica.Units.SI.Time windowStart = 0 "窗口开始，s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "窗口结束，s";
  parameter Modelica.Units.SI.Time deadline(min=0) = 0.5 "最大检出时间，s";
  parameter Boolean applicable = true "本次评价适用";
  Modelica.Blocks.Interfaces.BooleanInput valid "真值和检测标签同时有效" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));
  Modelica.Blocks.Interfaces.BooleanInput truth "独立真值事件" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.BooleanInput detected "系统报告检测" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput latency(unit="s") "首个事件的检测时差" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.BooleanOutput detectedInEpisode "首个事件已检出" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "证据状态";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "按截止时间和事件结束证据判定";
protected
  EvaluationLibrary.Requirements.ResponseTime timer(windowStart=windowStart,windowEnd=windowEnd,deadline=deadline,applicable=applicable);
  discrete Boolean ended(start=false,fixed=true);
  Boolean firstEpisodeEnded;
equation
  timer.valid = valid;
  timer.request = truth;
  timer.response = truth and detected and not ended;
  firstEpisodeEnded = timer.triggered and not truth and timer.inWindow and valid;
  when {initial(),firstEpisodeEnded} then
    ended = if initial() then false else true;
  end when;
  latency = timer.latency;
  detectedInEpisode = timer.responded;
  dataState = timer.dataState;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and ended and not timer.responded then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED else timer.verdict;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-35,23},{37,56}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,23},{-35,23},{-35,56},{37,56},{37,23},{61,23}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-62,-15},{5,-15},{5,11},{61,11}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-35,-31},{5,-31}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="detect", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="LabelEpisodeDelay")}),
    Documentation(info="<html><p><b>Purpose</b> 评价首个真值事件内的检出时差</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"真值和检测标签同时有效\"; Modelica.Blocks.Interfaces.BooleanInput truth \"独立真值事件\"; Modelica.Blocks.Interfaces.BooleanInput detected \"系统报告检测\"; Modelica.Blocks.Interfaces.RealOutput latency(unit=\"s\") \"首个事件的检测时差\"; Modelica.Blocks.Interfaces.BooleanOutput detectedInEpisode \"首个事件已检出\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"证据状态\"; output EvaluationLibrary.Utilities.Types.Verdict verdict \"按截止时间和事件结束证据判定\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"窗口开始，s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"窗口结束，s\"; parameter Modelica.Units.SI.Time deadline(min=0) = 0.5 \"最大检出时间，s\"; parameter Boolean applicable = true \"本次评价适用\"</p><p><b>Behavior</b> 评价首个真值事件内的检出时差</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p>
<p>评价首个真值事件内的检出时差</p>
<p>专业分类为 RequirementChecks.TemporalRequirement。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"真值和检测标签同时有效\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput truth \"独立真值事件\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput detected \"系统报告检测\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput latency(unit=\"s\") \"首个事件的检测时差\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput detectedInEpisode \"首个事件已检出\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"证据状态\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.Verdict verdict \"按截止时间和事件结束证据判定\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"窗口开始，s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"窗口结束，s\"</code></li>
<li><code>Modelica.Units.SI.Time deadline(min=0) = 0.5 \"最大检出时间，s\"</code></li>
<li><code>Boolean applicable = true \"本次评价适用\"</code></li>
</ul>
<p><b>时序与基准行为</b> 首个真值事件前的报警不记检测时刻。若真值入口已有报警，时差计零并另计误报。事件结束后不会关联后续检测。</p>
<p><b>最小用法</b> 单独接真值和检测输出，组合 DetectionConfusion 检查误报。 <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">MissionAndProtectionEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 同刻真值降为 false 且检测到达时不计检测。窗口终点仍未结束的事件依截止规则处理。</p>
</html>"));
end LabelEpisodeDelay;
