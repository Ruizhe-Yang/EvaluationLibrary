within EvaluationLibrary.Response;
block EventIntervals "相邻事件间隔及最短观测间隔"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,43},{106,55}}), iconTransformation(extent={{94,43},{106,55}})));
  Modelica.Blocks.Interfaces.BooleanInput eventSignal "An event is a rising edge" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.IntegerOutput count(start=0,fixed=true) "Events observed in the window" annotation(Placement(transformation(extent={{94,10},{106,22}}), iconTransformation(extent={{94,10},{106,22}})));
  Modelica.Blocks.Interfaces.RealOutput lastInterval(unit="s",start=0,fixed=true) "Most recent complete interval" annotation(Placement(transformation(extent={{94,-22},{106,-10}}), iconTransformation(extent={{94,-22},{106,-10}})));
  Modelica.Blocks.Interfaces.RealOutput minInterval(unit="s",start=0,fixed=true) "Shortest complete interval" annotation(Placement(transformation(extent={{94,-55},{106,-43}}), iconTransformation(extent={{94,-55},{106,-43}})));
  Modelica.Blocks.Interfaces.BooleanOutput intervalDefined "At least two events have occurred" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
  discrete Modelica.Units.SI.Time lastTime(start=0,fixed=true);
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid;
  when {initial(),eventSignal} then
    if not initial() and inWindow and dataOK then
      count = pre(count)+1;
      lastInterval = if pre(count)>0 then time-pre(lastTime) else 0;
      minInterval = if pre(count)==1 then lastInterval elseif pre(count)>1 then min(pre(minInterval),lastInterval) else 0;
      lastTime = time;
    else
      count = pre(count);
      lastInterval = pre(lastInterval);
      minInterval = pre(minInterval);
      lastTime = pre(lastTime);
    end if;
  end when;
  intervalDefined = count > 1;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-45,-35},{-45,39}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-8,-35},{-8,39}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{48,-35},{48,39}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-45,11},{-8,11}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-8,11},{48,11}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="Δtᵢ", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p><b>Purpose</b> 相邻事件间隔及最短观测间隔</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.BooleanInput eventSignal \"An event is a rising edge\"; Modelica.Blocks.Interfaces.IntegerOutput count(start=0,fixed=true) \"Events observed in the window\"; Modelica.Blocks.Interfaces.RealOutput lastInterval(unit=\"s\",start=0,fixed=true) \"Most recent complete interval\"; Modelica.Blocks.Interfaces.RealOutput minInterval(unit=\"s\",start=0,fixed=true) \"Shortest complete interval\"; Modelica.Blocks.Interfaces.BooleanOutput intervalDefined \"At least two events have occurred\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"</p><p><b>Behavior</b> 相邻事件间隔及最短观测间隔</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.FirstOrderResponse\">EvaluationLibrary.Examples.FirstOrderResponse</a></p>
<p>相邻事件间隔及最短观测间隔</p>
<p><b>行为</b> 只记录窗口内新上升沿，起点已有的高电平不视为新事件。</p>
<p><b>最小用法</b> 连接周期任务或报警的布尔边沿。</p>
<p><b>适用边界</b> 同一布尔信号无法表示同一时刻的两个独立事件。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput eventSignal \"An event is a rising edge\"</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput count(start=0,fixed=true) \"Events observed in the window\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput lastInterval(unit=\"s\",start=0,fixed=true) \"Most recent complete interval\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput minInterval(unit=\"s\",start=0,fixed=true) \"Shortest complete interval\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput intervalDefined \"At least two events have occurred\"</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">IntegratedResultsReporting</a> 提供同域宿主参考。</p>
</html>"));
end EventIntervals;
