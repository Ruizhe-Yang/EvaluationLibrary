within EvaluationLibrary.Statistics;
block LinearTrend "Least-squares linear trend on uniform samples"
  parameter String metricId=getInstanceName() "Stable identity of this retained specialist";
  parameter String requirementId="" "Requirement identity, when configured";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName="1/s" "Engineering unit of the reported specialist value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete specialist result" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "Terminal seen";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Qualified violation";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "Qualified violation time";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Result status";
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 "Sampling interval, s";
  parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 "First tick offset from windowStart, s";
  parameter Integer minimumSamples(min=1) = 2 "Minimum valid observations";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Accepted observations" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  parameter Real referenceOffset = 0 "Numerical centering in the input unit";
  Modelica.Blocks.Interfaces.RealInput u "Observed signal" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput slope "Least-squares slope, input unit per second" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput intercept "Fit at the first clock instant" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.BooleanOutput defined "At least two time-distinct valid samples" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples) "Evidence";
  Boolean dataOK "Validity combined with the metric data domain";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset "First scheduled uniform observation time";
  Boolean takeTick "Only the scheduled half-open grid is accepted";
  discrete Real sumT(start=0,fixed=true) "Sum t";
  discrete Real sumTT(start=0,fixed=true) "Sum tt";
  discrete Real sumX(start=0,fixed=true) "Sum x";
  discrete Real sumTX(start=0,fixed=true) "Sum tx";
  Real tRelative(unit="s") "T relative";
  Real xCentered "X centered";
  Real denominator "Denominator";
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
    Documentation(info="<html><p>Fit u against seconds relative to the first sample using finite least-squares sums. referenceOffset defaults to zero and centers the signal without changing slope. Two distinct accepted times and a positive fit denominator are required. slope has input units per second and intercept is the fitted value at the first sample; the complete result reports slope.</p><p>The observation defaults to [0,5) s, with a 0.02 s uniform period and zero offset unless declared otherwise. The period is positive, offset is nonnegative and smaller than the period, and minimumSamples must be positive. The exclusive stop is not sampled. Invalid scheduled observations latch INVALID; insufficient or missing scheduled observations give INCOMPLETE. Received samples, valid samples, observed time and valid time are distinct; sampled evidence does not assert strict behavior between ticks.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end LinearTrend;
