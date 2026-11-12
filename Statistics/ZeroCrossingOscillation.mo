within EvaluationLibrary.Statistics;
block ZeroCrossingOscillation "由相同方向穿越估计振荡周期"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  parameter Real level = 0 "Reference level in the signal unit";
  Modelica.Blocks.Interfaces.RealInput u "Observed waveform" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.IntegerOutput crossings(start=0,fixed=true) "Observed upward crossings" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput meanPeriod(unit="s") "First-to-last span divided by complete cycles" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.BooleanOutput defined "At least one complete observed cycle" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output Modelica.Units.SI.Time firstCrossing(start=0,fixed=true);
  output Modelica.Units.SI.Time lastCrossing(start=0,fixed=true);
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
  Boolean high;
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid and noEvent(abs(u) < Modelica.Constants.inf);
  high = u > level;
  when {initial(),high} then
    if not initial() and inWindow and dataOK then
      crossings = pre(crossings)+1;
      firstCrossing = if pre(crossings)==0 then time else pre(firstCrossing);
      lastCrossing = time;
    else
      crossings = pre(crossings);
      firstCrossing = pre(firstCrossing);
      lastCrossing = pre(lastCrossing);
    end if;
  end when;
  defined = crossings >= 2 and dataState <> EvaluationLibrary.Utilities.Types.DataStatus.INVALID;
  meanPeriod = if defined then (lastCrossing-firstCrossing)/(crossings-1) else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-58,6},{62,6}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{-55,6},{-52.2,14.3435},{-49.4,21.8702},{-46.6,27.8435},{-43.8,31.6785},{-41,33},{-38.2,31.6785},{-35.4,27.8435},{-32.6,21.8702},{-29.8,14.3435},{-27,6},{-24.2,-2.34346},{-21.4,-9.8702},{-18.6,-15.8435},{-15.8,-19.6785},{-13,-21},{-10.2,-19.6785},{-7.4,-15.8435},{-4.6,-9.8702},{-1.8,-2.34346},{1,6},{3.8,14.3435},{6.6,21.8702},{9.4,27.8435},{12.2,31.6785},{15,33},{17.8,31.6785},{20.6,27.8435},{23.4,21.8702},{26.2,14.3435},{29,6},{31.8,-2.34346},{34.6,-9.8702},{37.4,-15.8435},{40.2,-19.6785},{43,-21},{45.8,-19.6785},{48.6,-15.8435},{51.4,-9.8702},{54.2,-2.34346},{57,6}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Ellipse(extent={{-58,3},{-52,9}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-2,3},{4,9}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{54,3},{60,9}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Line(points={{-55,-26},{1,-26}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="period", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p><b>Purpose</b> 由相同方向穿越估计振荡周期</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.RealInput u \"Observed waveform\"; Modelica.Blocks.Interfaces.IntegerOutput crossings(start=0,fixed=true) \"Observed upward crossings\"; Modelica.Blocks.Interfaces.RealOutput meanPeriod(unit=\"s\") \"First-to-last span divided by complete cycles\"; Modelica.Blocks.Interfaces.BooleanOutput defined \"At least one complete observed cycle\"; output Modelica.Units.SI.Time firstCrossing(start=0,fixed=true); output Modelica.Units.SI.Time lastCrossing(start=0,fixed=true)</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Real level = 0 \"Reference level in the signal unit\"</p><p><b>Behavior</b> 由相同方向穿越估计振荡周期</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">EvaluationLibrary.Examples.AnalyticStatistics</a></p>
<p>由相同方向穿越估计振荡周期</p>
<p><b>行为</b> 只累计从低到严格超过 level 的自然上穿，窗入口已有高电平不计一次穿越。</p>
<p><b>最小用法</b> 将振荡响应接 u，level 设为振荡中心，读取 meanPeriod。</p>
<p><b>适用边界</b> 要求周期内一次有效上穿。多重穿越的噪声应由宿主先处理。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Real level = 0 \"Reference level in the signal unit\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput u \"Observed waveform\"</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput crossings(start=0,fixed=true) \"Observed upward crossings\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput meanPeriod(unit=\"s\") \"First-to-last span divided by complete cycles\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput defined \"At least one complete observed cycle\"</code></li>
<li><code>output Modelica.Units.SI.Time firstCrossing(start=0,fixed=true)</code></li>
<li><code>output Modelica.Units.SI.Time lastCrossing(start=0,fixed=true)</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">MechanicalResponseEvaluation</a> 提供同域宿主参考。</p>
</html>"));
end ZeroCrossingOscillation;
