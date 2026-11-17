within EvaluationLibrary.Response;
block OvershootUndershoot "Measure sampled overshoot and undershoot of a transition"
  parameter String metricId=getInstanceName() "Identifier carried by the result";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Optional requirement version";
  parameter String unitName="%" "Unit label for the reported value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Value, qualification and requirement outcome" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "True after normal simulation termination";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Latched valid requirement violation";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "Time of the first valid requirement violation";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Qualification of the reported result";
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive start of the observation window";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive end of the observation window";
  parameter Boolean applicable = true "True if this assessment is applicable";

  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 "Sampling interval, s";
  parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 "First tick offset from windowStart, s";
  parameter Integer minimumSamples(min=1) = 2 "Minimum valid observations";

  Modelica.Blocks.Interfaces.BooleanInput valid "Validity of the observed inputs" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "True inside the applicable observation window" annotation(Placement(transformation(extent={{94,66},{106,78}}), iconTransformation(extent={{94,66},{106,78}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Observation coverage and data validity";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Accepted observations" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  parameter Real initialValue = 0 "Pre-step baseline";
  parameter Real target = 1 "Final target, different from initialValue";
  Modelica.Blocks.Interfaces.RealInput u "Measured response" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput overshootPercent(unit="%") "Largest excursion past target" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  Modelica.Blocks.Interfaces.RealOutput undershootPercent(unit="%") "Largest excursion opposite the step" annotation(Placement(transformation(extent={{94,-78},{106,-66}}), iconTransformation(extent={{94,-78},{106,-66}})));
  output Modelica.Units.SI.Time overshootAt(start=0,fixed=true) "Time of the largest sampled overshoot";
  output Modelica.Units.SI.Time undershootAt(start=0,fixed=true) "Time of the largest sampled undershoot";
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples) "Observation coverage and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset "First scheduled uniform observation time";
  Boolean takeTick "Only the scheduled half-open grid is accepted";
  discrete Real high(start=1,fixed=true) "High";
  discrete Real low(start=0,fixed=true) "Low";
  Real normalized "Normalised transition progress";
initial equation
  assert(abs(target-initialValue)>Modelica.Constants.small, "Target and initial value must differ.");
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (dataState)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (dataState);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=overshootPercent; result.valueAvailable=(validSamples>0) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(resultStatus,qualifiedViolation,false));
  result.complete=time>=windowEnd or terminalSeen;
  result.windowStart=windowStart; result.windowStop=windowEnd;
  result.observedDuration=evidence.observedDuration;
  result.validDuration=evidence.validDuration;
  result.expectedSamples=EvaluationLibrary.Utilities.Functions.SampleCount(windowStart,windowEnd,windowStart+sampleOffset,samplePeriod); result.receivedSamples=evidence.receivedSamples; result.validSamples=validSamples;
  result.everViolated=qualifiedViolation; result.firstViolationTime=qualifiedViolationTime;
  result.samplePeriod=samplePeriod; result.evidenceKind=2;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  validSamples = evidence.validSamples;
  takeTick = evidence.takeTick;
  dataOK = valid and noEvent(abs(u) < Modelica.Constants.inf);
  normalized = if dataOK then (u-initialValue)/(target-initialValue) else 0;
  when sample(firstSample,samplePeriod) then
    high = if takeTick and dataOK then max(pre(high),normalized) else pre(high);
    low = if takeTick and dataOK then min(pre(low),normalized) else pre(low);
    overshootAt = if takeTick and dataOK and normalized > pre(high) then time else pre(overshootAt);
    undershootAt = if takeTick and dataOK and normalized < pre(low) then time else pre(undershootAt);
  end when;
  overshootPercent = 100*(high-1);
  undershootPercent = -100*low;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,24},{66,24}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{-65,-23},{66,-23}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{-55,-23},{-39,-36},{-22,-5},{-5,45},{12,33},{29,18},{46,25},{62,24}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Solid),
        Ellipse(extent={{-57.7,-25.7},{-52.3,-20.3}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-41.7,-38.7},{-36.3,-33.3}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-24.7,-7.7},{-19.3,-2.3}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-7.7,42.3},{-2.3,47.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{9.3,30.3},{14.7,35.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{26.3,15.3},{31.7,20.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{43.3,22.3},{48.7,27.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{59.3,21.3},{64.7,26.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Line(points={{-5,24},{-5,45}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-39,-23},{-39,-36}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="OS / US %", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Normalises <code>u</code> as <code>(u-initialValue)/(target-initialValue)</code> and tracks extrema on the declared sample grid. <code>overshootPercent</code> measures excursions beyond the target; <code>undershootPercent</code> measures excursions opposite to the transition. Both are non-negative and work for rising or falling transitions.</p><p>Set distinct initial and target values, the observation window and <code>samplePeriod</code>. Connect <code>valid</code>. The result reports sampled overshoot; excursions between samples are not captured. Peak times are meaningful only when the corresponding excursion is positive.</p></html>"));
end OvershootUndershoot;
