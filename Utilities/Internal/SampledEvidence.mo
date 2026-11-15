within EvaluationLibrary.Utilities.Internal;
block SampledEvidence "Half-open uniform sample coverage and latched invalidity"
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

  output Boolean takeTick "Take tick";
  output Integer receivedSamples(start=0,fixed=true) "All observed scheduled ticks, including invalid samples";
  output Modelica.Units.SI.Time observedDuration "Observed half-open window duration";
  output Modelica.Units.SI.Time validDuration "Duration of valid input; sampled qualification still uses validSamples";
protected
  Boolean validNow "Current valid portion of the observation window";
  discrete Real validElapsed(start=0,fixed=true) "Completed valid segment duration";
  discrete Real validEnteredAt(start=0,fixed=true) "Start of the current valid segment";

  parameter Modelica.Units.SI.Time simulationStart(fixed=false) "Observed simulation initialization time";
  Boolean invalidSeen "Invalid seen";
  Boolean sufficient "Sufficient";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset "First scheduled uniform observation time";
  final parameter Real tickSpan = (windowEnd-firstSample)/samplePeriod "Number of scheduled grid intervals";
  final parameter Integer expected = if tickSpan <= 0 then 0 else
    max(1,integer(ceil(tickSpan-8*Modelica.Constants.eps*max(1,abs(tickSpan))))) "Declared expected value or sample count";
  discrete Boolean badSample(start=false,fixed=true) "Bad sample";

initial equation
  simulationStart = time;
  assert(windowEnd > windowStart, "Window must have positive duration.");

  assert(samplePeriod > 0 and sampleOffset >= 0 and sampleOffset < samplePeriod and minimumSamples >= 1,
    "Invalid sampling grid.");
equation
  observedDuration=if applicable then max(0,min(time,windowEnd)-max(simulationStart,windowStart)) else 0;
  validNow=inWindow and dataOK;
  when {initial(),change(validNow)} then
    validElapsed=if initial() then 0 elseif pre(validNow) then pre(validElapsed)+time-pre(validEnteredAt) else pre(validElapsed);
    validEnteredAt=if validNow and (initial() or not pre(validNow)) then time else pre(validEnteredAt);
  end when;
  validDuration=validElapsed+(if validNow then time-validEnteredAt else 0);
  takeTick = applicable and expected > 0 and noEvent(time < firstSample+(expected-0.5)*samplePeriod);
  when sample(firstSample,samplePeriod) then
    receivedSamples = pre(receivedSamples)+(if takeTick then 1 else 0);
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
        Line(points={{-57,44},{57,44}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{-61,40},{-53,48}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Ellipse(extent={{53,40},{61,48}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-57,32},{-57,73}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{57,32},{57,73}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{-57,-18},{57,-18}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-57,25},{-57,-18}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-61,4},{-53,12}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-28,25},{-28,-18}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-32,4},{-24,12}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{1,25},{1,-18}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-3,4},{5,12}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{30,25},{30,-18}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{26,4},{34,12}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{57,25},{57,-18}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{53,4},{61,12}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Text(extent={{-54,-38},{54,-70}}, textString="n / N", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Half-open uniform sample coverage and latched invalidity. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
end SampledEvidence;
