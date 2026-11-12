within EvaluationLibrary.Utilities.Internal;
block SampledEvidence "均匀采样半开窗及完整性证据"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  input Boolean dataOK "Already checked input validity and numerical domain";

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";

  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 "Sampling interval, s";
  parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 "First tick offset from windowStart, s";
  parameter Integer minimumSamples(min=1) = 2 "Minimum valid observations";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples(start=0,fixed=true) "Accepted observations" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));

  output Boolean takeTick;
protected

  parameter Modelica.Units.SI.Time simulationStart(fixed=false);
  Boolean invalidSeen;
  Boolean sufficient;

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset;
  final parameter Real tickSpan = (windowEnd-firstSample)/samplePeriod;
  final parameter Integer expected = if tickSpan <= 0 then 0 else
    max(1,integer(ceil(tickSpan-8*Modelica.Constants.eps*max(1,abs(tickSpan)))));
  discrete Boolean badSample(start=false,fixed=true);

initial equation
  simulationStart = time;
  assert(windowEnd > windowStart, "Window must have positive duration.");

  assert(samplePeriod > 0 and sampleOffset >= 0 and sampleOffset < samplePeriod and minimumSamples >= 1,
    "Invalid sampling grid.");
equation
  takeTick = applicable and expected > 0 and noEvent(time < firstSample+(expected-0.5)*samplePeriod);
  when sample(firstSample,samplePeriod) then
    badSample = pre(badSample) or (takeTick and not dataOK);
    validSamples = pre(validSamples)+(if takeTick and dataOK then 1 else 0);
  end when;
  invalidSeen = badSample;
  sufficient = validSamples >= minimumSamples and validSamples == expected;

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
        Rectangle(extent={{-51,-27},{51,39}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-42,-27},{-42,-3.32659}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-21,-27},{-21,-8.16368}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{0,-27},{0,6}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{21,-27},{21,20.1637}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{42,-27},{42,15.3266}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Ellipse(extent={{-45,-6.32659},{-39,-0.326594}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-24,-11.1637},{-18,-5.16368}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-3,3},{3,9}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{18,17.1637},{24,23.1637}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{39,12.3266},{45,18.3266}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Line(points={{22.5,-38},{30.48,-46.4},{46.02,-26.24}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="n", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>均匀采样半开窗及完整性证据</p>
<p><b>行为</b> 均匀采样半开窗及完整性证据。</p>
<p><b>最小用法</b> 由本库组件按源码中的参数和接口装配。</p>
<p><b>适用边界</b> 实现细节随本库版本演进。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"</code></li>
<li><code>Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"</code></li>
<li><code>Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>input Boolean dataOK \"Already checked input validity and numerical domain\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput validSamples(start=0,fixed=true) \"Accepted observations\"</code></li>
<li><code>output Boolean takeTick</code></li>
</ul>
</html>"));
end SampledEvidence;
