within EvaluationLibrary.Statistics;
block GatedPeak "Sampled peak severity during a hazard condition"
  parameter String metricId=getInstanceName() "Metric identifier";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Requirement version";
  parameter String unitName="1" "Engineering unit of the reported value";
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

  Modelica.Blocks.Interfaces.BooleanInput valid "External input-validity condition" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "True while the observation window is active" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Status of the observation data";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Number of valid samples" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  parameter Real peakLimit = 1 "Inclusive maximum accepted danger severity";
  Modelica.Blocks.Interfaces.BooleanInput hazard "Condition enabling severity observations" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput severity "Observed hazard severity" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.IntegerOutput hazardSamples(start=0,fixed=true) "Number of valid hazard samples" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput peak(start=0,fixed=true) "Greatest sampled hazard severity" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.RealOutput peakTime(unit="s",start=0,fixed=true) "First occurrence of the greatest sampled severity" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement verdict";
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples) "Observation coverage and qualification";
  Boolean dataOK "External validity and numerical-domain checks";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset "First scheduled sampling instant";
  Boolean takeTick "True at eligible sample instants";
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
  result.value=peak; result.valueAvailable=(hazardSamples>0) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
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
  dataOK = valid and (not hazard or abs(severity) < Modelica.Constants.inf);
  when sample(firstSample,samplePeriod) then
    hazardSamples = pre(hazardSamples)+(if takeTick and dataOK and hazard then 1 else 0);
    if takeTick and dataOK and hazard and (pre(hazardSamples) == 0 or severity > pre(peak)) then
      peak = severity;
      peakTime = time;
    else
      peak = pre(peak);
      peakTime = pre(peakTime);
    end if;
  end when;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if hazardSamples == 0 then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE elseif peak <= peakLimit then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-34,-29},{40,59}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-54,-29},{-54,55}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-57.2,51.8},{-50.8,58.2}}, lineColor={128,128,128}, fillColor={128,128,128}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{-30,-29},{-30,12}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-33.2,8.8},{-26.8,15.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{-8,-29},{-8,39}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-11.2,35.8},{-4.8,42.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{14,-29},{14,23}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{10.8,19.8},{17.2,26.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{36,-29},{36,6}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{32.8,2.8},{39.2,9.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{57,-29},{57,48}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{53.8,44.8},{60.2,51.2}}, lineColor={128,128,128}, fillColor={128,128,128}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{-15,32},{-1,46}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{-29,39},{34,39}}, color={0,0,127}, thickness=0.6, pattern=LinePattern.Dash),
        Line(points={{-59,-47},{-34,-47},{-34,-35},{40,-35},{40,-47},{60,-47}}, color={128,128,128}, thickness=0.75, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="gated max", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="GatedPeak")}),
    Documentation(info="<html><p>Tracks the greatest <code>severity</code> at valid sample instants for which <code>hazard=true</code>. <code>peakTime</code> retains the first occurrence of the greatest value. At complete coverage, <code>peak &lt;= peakLimit</code> satisfies the requirement. With no hazard samples, the verdict is <code>NOT_APPLICABLE</code> and the peak is unavailable.</p><p>Connect <code>valid</code> and configure the half-open interval <code>[windowStart, windowEnd)</code>. The first sample is <code>windowStart + sampleOffset</code>; subsequent samples use <code>samplePeriod</code>. Invalid scheduled samples invalidate the result. The result connector carries the sample counts, data status and numerical availability.</p></html>"));
end GatedPeak;
