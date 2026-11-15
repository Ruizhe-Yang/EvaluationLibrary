within EvaluationLibrary.Requirements;
block LabelEpisodeDelay "Detection latency within the same labelled episode"
  parameter String metricId=getInstanceName() "Stable identity of this retained specialist";
  parameter String requirementId="" "Requirement identity, when configured";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName="s" "Engineering unit of the reported specialist value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete specialist result" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "Terminal seen";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Qualified violation";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "Qualified violation time";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Result status";
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive observation start in seconds";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive observation end in seconds";
  parameter Modelica.Units.SI.Time deadline(min=0) = 0.5 "Maximum request-response delay in seconds, inclusive";
  parameter Boolean applicable = true "Whether this evaluation applies";
  Modelica.Blocks.Interfaces.BooleanInput valid "Host declares the observed inputs valid" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));
  Modelica.Blocks.Interfaces.BooleanInput truth "Truth" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.BooleanInput detected "Detected" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput latency(unit="s") "Latency" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.BooleanOutput detectedInEpisode "Detected in episode" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Evidence qualification independent of requirement verdict";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement decision independent of observation completeness";
protected
  EvaluationLibrary.Requirements.ResponseTime timer(windowStart=windowStart,windowEnd=windowEnd,deadline=deadline,applicable=applicable) "Timer";
  discrete Boolean ended(start=false,fixed=true) "Ended";
  Boolean firstEpisodeEnded "First episode ended";
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
  result.value=latency; result.valueAvailable=(detectedInEpisode) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=EvaluationLibrary.Utilities.Functions.QualifiedCode(Integer(resultStatus),if qualifiedViolation then 3 else Integer(verdict));
  result.complete=time>=windowEnd or terminalSeen;
  result.windowStart=windowStart; result.windowStop=windowEnd;
  result.observedDuration=0;
  result.validDuration=0;
  result.expectedSamples=0; result.receivedSamples=0; result.validSamples=0;
  result.everViolated=qualifiedViolation; result.firstViolationTime=qualifiedViolationTime;
  result.samplePeriod=0; result.evidenceKind=4;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
  timer.valid = valid;
  timer.request = truth;
  timer.response = truth and detected and not ended;
  firstEpisodeEnded = timer.triggered and not truth and timer.inWindow and valid;
  when {initial(),firstEpisodeEnded} then
    ended = if initial() then false else true;
  end when;
  latency = timer.latency;
  detectedInEpisode = timer.responded;
  dataState = timer.dataState;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and ended and not timer.responded then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED else timer.verdict;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-42,-31},{48,59}}, lineColor={245,245,245}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.1, radius=0),
        Line(points={{-66,32},{-42,32},{-42,59},{48,59},{48,32},{65,32}}, color={128,128,128}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-66,-14},{2,-14},{2,8},{65,8}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-42,26},{-42,-43}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{48,25},{48,-43}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{2,-5},{2,-43}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{-42,-36},{2,-36}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-42,-41},{-42,-31}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{2,-41},{2,-31}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="episode dt", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="LabelEpisodeDelay")}),
    Documentation(info="<html><p>Measure detection latency in the first truth episode using the first-request ResponseTime timer. detected qualifies only while truth remains true in that episode. deadline defaults to 0.5 s and is nonnegative. Episode termination without detection is a violation after complete observation; a later detection cannot repair the ended episode. No truth demand is not successful detection.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end LabelEpisodeDelay;
