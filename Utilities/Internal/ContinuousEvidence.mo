within EvaluationLibrary.Utilities.Internal;
block ContinuousEvidence "连续窗口时长与失效证据"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  input Boolean dataOK "Already checked input validity and numerical domain";

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s",start=0,fixed=true) "Accumulated valid duration" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
protected

  parameter Modelica.Units.SI.Time simulationStart(fixed=false);
  Boolean invalidSeen;
  Boolean sufficient;

initial equation
  simulationStart = time;
  assert(windowEnd > windowStart, "Window must have positive duration.");

equation
  when {initial(),inWindow and not dataOK} then
    invalidSeen = inWindow and not dataOK;
  end when;
  der(observedDuration) = if inWindow and dataOK then 1 else 0;
  sufficient = observedDuration > 0;

  inWindow = applicable and time >= windowStart and time < windowEnd;
  dataState = if not applicable then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE
    elseif invalidSeen then EvaluationLibrary.Utilities.Types.DataStatus.INVALID
    elseif time < windowEnd then EvaluationLibrary.Utilities.Types.DataStatus.PENDING
    elseif simulationStart > windowStart or not sufficient then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE
    else EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-49,-26},{49,37}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-49,46},{-49,-35}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{49,46},{49,-35}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-49,4},{-46.55,6.81582},{-44.1,9.56231},{-41.65,12.1718},{-39.2,14.5801},{-36.75,16.7279},{-34.3,18.5623},{-31.85,20.0381},{-29.4,21.119},{-26.95,21.7784},{-24.5,22},{-22.05,21.7784},{-19.6,21.119},{-17.15,20.0381},{-14.7,18.5623},{-12.25,16.7279},{-9.8,14.5801},{-7.35,12.1718},{-4.9,9.56231},{-2.45,6.81582},{0,4},{2.45,1.18418},{4.9,-1.56231},{7.35,-4.17183},{9.8,-6.58013},{12.25,-8.72792},{14.7,-10.5623},{17.15,-12.0381},{19.6,-13.119},{22.05,-13.7784},{24.5,-14},{26.95,-13.7784},{29.4,-13.119},{31.85,-12.0381},{34.3,-10.5623},{36.75,-8.72792},{39.2,-6.58013},{41.65,-4.17183},{44.1,-1.56231},{46.55,1.18418},{49,4}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{21.75,-36},{30.3,-45},{46.95,-23.4}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="dt", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>连续窗口时长与失效证据</p>
<p><b>行为</b> 连续窗口时长与失效证据。</p>
<p><b>最小用法</b> 由本库组件按源码中的参数和接口装配。</p>
<p><b>适用边界</b> 实现细节随本库版本演进。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>input Boolean dataOK \"Already checked input validity and numerical domain\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\",start=0,fixed=true) \"Accumulated valid duration\"</code></li>
</ul>
</html>"));
end ContinuousEvidence;
