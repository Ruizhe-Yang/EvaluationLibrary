within EvaluationLibrary.Statistics;
block ControlEffort "对执行量计算归一化作用量和满载时间"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,66},{106,78}}), iconTransformation(extent={{94,66},{106,78}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  parameter Real ratedMagnitude(min=Modelica.Constants.small) = 1 "额定执行量幅值";
  Modelica.Blocks.Interfaces.RealInput applied "实测执行量" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput squaredEffort(unit="s",start=0,fixed=true) "归一化执行量的平方时间积分" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  Modelica.Blocks.Interfaces.RealOutput ratedDuration(unit="s",start=0,fixed=true) "幅值大于或等于额定值的时间" annotation(Placement(transformation(extent={{94,-78},{106,-66}}), iconTransformation(extent={{94,-78},{106,-66}})));
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
  Real normalized;
initial equation
  assert(ratedMagnitude > 0, "Rated magnitude must be positive.");
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid and abs(applied) < Modelica.Constants.inf;
  normalized = if dataOK then applied/ratedMagnitude else 0;
  der(squaredEffort) = if inWindow and dataOK then normalized^2 else 0;
  der(ratedDuration) = if inWindow and dataOK and abs(normalized) >= 1 then 1 else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Polygon(points={{-55,-34},{-55,-13},{-31,31},{-2,8},{26,43},{55,15},{55,-34},{-55,-34}}, lineColor={235,235,235}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.3),
        Line(points={{-55,-13},{-31,31},{-2,8},{26,43},{55,15}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="∫ u² dt", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="ControlEffort")}),
    Documentation(info="<html><p><b>Purpose</b> 对执行量计算归一化作用量和满载时间</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.RealInput applied \"实测执行量\"; Modelica.Blocks.Interfaces.RealOutput squaredEffort(unit=\"s\",start=0,fixed=true) \"归一化执行量的平方时间积分\"; Modelica.Blocks.Interfaces.RealOutput ratedDuration(unit=\"s\",start=0,fixed=true) \"幅值大于或等于额定值的时间\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Real ratedMagnitude(min=Modelica.Constants.small) = 1 \"额定执行量幅值\"</p><p><b>Behavior</b> 对执行量计算归一化作用量和满载时间</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">EvaluationLibrary.Examples.AnalyticStatistics</a></p>
<p>对执行量计算归一化作用量和满载时间</p>
<p>专业分类为 PerformanceMetrics.EffortAndEnergy。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput applied \"实测执行量\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput squaredEffort(unit=\"s\",start=0,fixed=true) \"归一化执行量的平方时间积分\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput ratedDuration(unit=\"s\",start=0,fixed=true) \"幅值大于或等于额定值的时间\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Real ratedMagnitude(min=Modelica.Constants.small) = 1 \"额定执行量幅值\"</code></li>
</ul>
<p><b>时序与基准行为</b> 只在有效窗口累计，等于额定幅值时计入满载时间。</p>
<p><b>最小用法</b> 接实际扭矩、阀开度或电流输出。 <a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">MechanicalResponseEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 平方积分是努力量代理。使用功率输入计算真实能耗。</p>
</html>"));
end ControlEffort;
