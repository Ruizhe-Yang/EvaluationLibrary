within EvaluationLibrary.Response;
block SteadyStateError "End-window sample bias and residual spread"
  parameter String metricId=getInstanceName() "Stable identity of this retained specialist";
  parameter String requirementId="" "Requirement identity, when configured";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName="1" "Engineering unit of the reported specialist value";
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

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,66},{106,78}}), iconTransformation(extent={{94,66},{106,78}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Accepted observations" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  parameter Real biasLimit(min=0) = 0.05 "Maximum allowed absolute end-window bias";
  parameter Real spreadLimit(min=0) = 0.02 "Maximum allowed end-window sample spread";
  Modelica.Blocks.Interfaces.RealInput measured "Measured" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput reference "Declared reference in the same engineering unit" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput bias "Bias" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  Modelica.Blocks.Interfaces.RealOutput spread "Spread" annotation(Placement(transformation(extent={{94,-78},{106,-66}}), iconTransformation(extent={{94,-78},{106,-66}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement decision independent of observation completeness";
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples) "Evidence";
  Boolean dataOK "Validity combined with the metric data domain";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset "First scheduled uniform observation time";
  Boolean takeTick "Only the scheduled half-open grid is accepted";
  EvaluationLibrary.Statistics.SampledMoments moments(windowStart=windowStart,windowEnd=windowEnd,
    samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples,applicable=applicable) "Moments";
initial equation
  assert(biasLimit >= 0 and spreadLimit >= 0, "Error limits must be nonnegative.");
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if verdict==EvaluationLibrary.Utilities.Types.Verdict.INVALID then EvaluationLibrary.Utilities.Types.DataStatus.INVALID
    elseif verdict==EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE
    elseif dataState==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and verdict==EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE
    elseif dataState==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else dataState;
  when {initial(),verdict==EvaluationLibrary.Utilities.Types.Verdict.VIOLATED} then
    qualifiedViolation=pre(qualifiedViolation) or verdict==EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
    qualifiedViolationTime=if not pre(qualifiedViolation) and verdict==EvaluationLibrary.Utilities.Types.Verdict.VIOLATED then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=bias; result.valueAvailable=(validSamples>0) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=EvaluationLibrary.Utilities.Functions.QualifiedCode(Integer(resultStatus),if qualifiedViolation then 3 else Integer(verdict));
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
  dataOK = valid and abs(measured) < Modelica.Constants.inf and abs(reference) < Modelica.Constants.inf;
  moments.valid = dataOK;
  moments.u = if dataOK then measured-reference else 0;
  bias = moments.mean;
  spread = sqrt(moments.variance);
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if abs(bias) <= biasLimit and spread <= spreadLimit then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-10,-33},{66,47}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.35, radius=0),
        Line(points={{-65,-13},{66,-13}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{-10,14},{66,14}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-65,51},{-48,31},{-34,8},{-19,18}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{-6.7,6.3},{-1.3,11.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{5.3,16.3},{10.7,21.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{17.3,9.3},{22.7,14.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{29.3,18.3},{34.7,23.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{41.3,7.3},{46.7,12.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{54.3,10.3},{59.7,15.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Line(points={{70,4},{70,25}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{66,4},{74,4}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{66,25},{74,25}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{-18,-13},{-18,14}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="mean(e), sd(e)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="SteadyStateError")}),
    Documentation(info="<html><p>On the configured finite sample window, observe measured-reference in their common unit. biasLimit defaults to 0.05 and spreadLimit to 0.02; both are nonnegative. The mean bias and population standard deviation of the sampled error must satisfy their inclusive limits after complete coverage. This assesses the declared end window and does not infer infinite-time convergence.</p><p>The observation defaults to [0,5) s, with a 0.02 s uniform period and zero offset unless declared otherwise. The period is positive, offset is nonnegative and smaller than the period, and minimumSamples must be positive. The exclusive stop is not sampled. Invalid scheduled observations latch INVALID; insufficient or missing scheduled observations give INCOMPLETE. Received samples, valid samples, observed time and valid time are distinct; sampled evidence does not assert strict behavior between ticks.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end SteadyStateError;
