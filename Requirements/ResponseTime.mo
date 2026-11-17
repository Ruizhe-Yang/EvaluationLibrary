within EvaluationLibrary.Requirements;
block ResponseTime "Check the response latency after the first request"
  parameter String metricId=getInstanceName() "Identifier carried by the result";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Optional requirement version";
  parameter String unitName="s" "Unit label for the reported value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Value, qualification and requirement outcome" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "True after normal simulation termination";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Latched valid requirement violation";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "Time of the first valid requirement violation";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Qualification of the reported result";
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive start of the observation window";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive end of the observation window";
  parameter Boolean applicable = true "True if this assessment is applicable";

  Modelica.Blocks.Interfaces.BooleanInput valid "Validity of the observed inputs" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "True inside the applicable observation window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Observation coverage and data validity";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid observation duration" annotation(Placement(transformation(extent={{94,49},{106,61}}), iconTransformation(extent={{94,49},{106,61}})));
  parameter Modelica.Units.SI.Time deadline(min=0) = 0.5 "Maximum request-response delay in seconds, inclusive";
  Modelica.Blocks.Interfaces.BooleanInput request "Observed request condition" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.BooleanInput response "Observed response condition" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.BooleanOutput triggered(start=false,fixed=true) "True after a valid request condition has been observed" annotation(Placement(transformation(extent={{94,21},{106,33}}), iconTransformation(extent={{94,21},{106,33}})));
  Modelica.Blocks.Interfaces.BooleanOutput responded(start=false,fixed=true) "True after a valid response condition has been observed" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput triggerTime(unit="s",start=0,fixed=true) "Time of the first valid request condition" annotation(Placement(transformation(extent={{94,-33},{106,-21}}), iconTransformation(extent={{94,-33},{106,-21}})));
  Modelica.Blocks.Interfaces.RealOutput responseAt(unit="s",start=0,fixed=true) "Time of the first valid response condition" annotation(Placement(transformation(extent={{94,-61},{106,-49}}), iconTransformation(extent={{94,-61},{106,-49}})));
  Modelica.Blocks.Interfaces.RealOutput latency(unit="s") "Elapsed time from request to response" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement outcome, separate from data qualification";
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable) "Observation coverage and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
  Boolean triggerNow "Trigger now";
  Boolean responseNow "Response now";
initial equation
  assert(deadline >= 0, "Deadline must be nonnegative.");
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
  result.value=latency; result.valueAvailable=(responded) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=EvaluationLibrary.Utilities.Functions.QualifiedCode(Integer(resultStatus),if qualifiedViolation then 3 else Integer(verdict));
  result.complete=time>=windowEnd or terminalSeen;
  result.windowStart=windowStart; result.windowStop=windowEnd;
  result.observedDuration=evidence.totalObservedDuration;
  result.validDuration=observedDuration;
  result.expectedSamples=0; result.receivedSamples=0; result.validSamples=0;
  result.everViolated=qualifiedViolation; result.firstViolationTime=qualifiedViolationTime;
  result.samplePeriod=0; result.evidenceKind=1;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid;
  triggerNow = inWindow and dataOK and request;
  responseNow = inWindow and dataOK and triggered and response;
  when {initial(),triggerNow} then
    triggered = if initial() then triggerNow else true;
    triggerTime = if triggerNow and not pre(triggered) then time else pre(triggerTime);
  end when;
  when {initial(),responseNow} then
    responded = if initial() then responseNow else true;
    responseAt = if responseNow and not pre(responded) then time else pre(responseAt);
  end when;
  latency = if responded then responseAt-triggerTime else 0;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if not triggered then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE elseif responded then (if noEvent(latency <= deadline) then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED) elseif noEvent(triggerTime+deadline < windowEnd) then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED else EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,35},{-40,35},{-40,58},{61,58}}, color={128,128,128}, thickness=0.85, pattern=LinePattern.Solid),
        Line(points={{-65,-15},{15,-15},{15,8},{61,8}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-40,27},{-40,-36}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{15,0},{15,-36}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Ellipse(extent={{-42.7,32.3},{-37.3,37.7}}, lineColor={128,128,128}, fillColor={128,128,128}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{12.3,-17.7},{17.7,-12.3}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Line(points={{-40,-29},{15,-29}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-40,-34},{-40,-24}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{15,-34},{15,-24}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{45,-38},{45,61}}, color={191,0,0}, thickness=0.75, pattern=LinePattern.Dash),
        Text(extent={{36,77},{57,57}}, textString="T", textColor={191,0,0}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="dt <= T", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="ResponseTime")}),
    Documentation(info="<html><p>Records the first valid request condition and the first valid response condition at or after it in <code>[windowStart, windowEnd)</code>. Both inputs are interpreted as conditions, so a response already true when the request occurs can give zero latency. <code>latency</code> is meaningful only when <code>responded</code> is true.</p><p>On complete valid observation, a response satisfies the requirement when <code>latency &lt;= deadline</code>. No request gives <code>NOT_APPLICABLE</code>. A missing response violates the requirement only when the deadline lies strictly before the exclusive window end; otherwise the result remains undecided.</p></html>"));
end ResponseTime;
