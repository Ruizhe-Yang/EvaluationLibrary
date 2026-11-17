within EvaluationLibrary.Statistics;
block LinearTrend "Least-squares linear trend of uniformly sampled values"
  parameter String metricId=getInstanceName() "Metric identifier";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Requirement version";
  parameter String unitName="1/s" "Engineering unit of the reported value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Result record with value, status and observation metadata" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "True after normal simulation termination";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Retained valid violation flag";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "First valid violation time";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Status used in the result record";
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive observation start";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive observation end";
  parameter Boolean applicable = true "Whether this evaluation applies";

  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 "Sampling interval";
  parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 "First sample offset from windowStart";
  parameter Integer minimumSamples(min=1) = 2 "Minimum valid observations";

  Modelica.Blocks.Interfaces.BooleanInput valid "External input-validity condition" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "True while the observation window is active" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Status of the observation data";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Number of valid samples" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  parameter Real referenceOffset = 0 "Numerical centring offset in the input unit";
  Modelica.Blocks.Interfaces.RealInput u "Observed signal" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput slope "Least-squares slope, input unit per second" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput intercept "Fit at the first clock instant" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.BooleanOutput defined "At least two time-distinct valid samples" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples) "Observation coverage and qualification";
  Boolean dataOK "External validity and numerical-domain checks";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset "First scheduled sampling instant";
  Boolean takeTick "True at eligible sample instants";
  discrete Real sumT(start=0,fixed=true) "Sum of sample times relative to the first tick";
  discrete Real sumTT(start=0,fixed=true) "Sum of squared relative sample times";
  discrete Real sumX(start=0,fixed=true) "Sum of centred values";
  discrete Real sumTX(start=0,fixed=true) "Sum of time-value products";
  Real tRelative(unit="s") "Time relative to the first sample";
  Real xCentered "Value relative to referenceOffset";
  Real denominator "Least-squares denominator";
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (dataState)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (dataState);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=slope; result.valueAvailable=(defined) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
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
  tRelative = time-firstSample;
  xCentered = if dataOK then u-referenceOffset else 0;
  when sample(firstSample,samplePeriod) then
    sumT = pre(sumT)+(if takeTick and dataOK then tRelative else 0);
    sumTT = pre(sumTT)+(if takeTick and dataOK then tRelative^2 else 0);
    sumX = pre(sumX)+(if takeTick and dataOK then xCentered else 0);
    sumTX = pre(sumTX)+(if takeTick and dataOK then tRelative*xCentered else 0);
  end when;
  denominator = validSamples*sumTT-sumT^2;
  defined = validSamples >= 2 and noEvent(denominator > 0) and dataState <> EvaluationLibrary.Utilities.Types.DataStatus.INVALID;
  slope = if defined then (validSamples*sumTX-sumT*sumX)/denominator else 0;
  intercept = if defined then referenceOffset+(sumX-slope*sumT)/validSamples else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,61},{-64,-38},{65,-38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-57,-24},{58,53}}, color={0,0,127}, thickness=1.05, pattern=LinePattern.Solid),
        Line(points={{-53,-23},{-53,-21.3217}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{-32,8},{-32,-7.26087}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{-12,7},{-12,6.13043}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{10,33},{10,20.8609}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{31,30},{31,34.9217}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{51,55},{51,48.313}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Ellipse(extent={{-56.3,-26.3},{-49.7,-19.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{-35.3,4.7},{-28.7,11.3}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{-15.3,3.7},{-8.7,10.3}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{6.7,29.7},{13.3,36.3}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{27.7,26.7},{34.3,33.3}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{47.7,51.7},{54.3,58.3}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Text(extent={{-65,-50},{65,-75}}, textString="LS slope", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Fits <code>u</code> against time measured from the first sample. <code>referenceOffset</code> centres the input for the calculation. A positive fit denominator and at least two valid samples are required. <code>slope</code> has input units per second and <code>intercept</code> is the fitted value at the first sample; <code>result.value</code> reports the slope.</p><p>Connect <code>valid</code> and configure the half-open interval <code>[windowStart, windowEnd)</code>. The first sample is <code>windowStart + sampleOffset</code>; subsequent samples use <code>samplePeriod</code>. Invalid scheduled samples invalidate the result. The result connector carries the sample counts, data status and numerical availability.</p></html>"));
end LinearTrend;
