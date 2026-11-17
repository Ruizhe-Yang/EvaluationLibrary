within EvaluationLibrary.Response;
block ConditionOccupancy "Measure condition duration and occupancy fraction"
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

  Modelica.Blocks.Interfaces.BooleanInput valid "Validity of the observed inputs" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "True inside the applicable observation window" annotation(Placement(transformation(extent={{94,66},{106,78}}), iconTransformation(extent={{94,66},{106,78}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Observation coverage and data validity";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid observation duration" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  parameter Real budget(min=0,max=1) = 0.05 "Inclusive maximum unsafe fraction of valid observed time, dimensionless";
  Modelica.Blocks.Interfaces.BooleanInput unsafe "Condition whose occupied duration is measured" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput duration(unit="s",start=0,fixed=true) "Cumulative duration for which unsafe is true and valid" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  Modelica.Blocks.Interfaces.RealOutput fraction "Fraction of valid observation with the condition true" annotation(Placement(transformation(extent={{94,-78},{106,-66}}), iconTransformation(extent={{94,-78},{106,-66}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement outcome, separate from data qualification";
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable) "Observation coverage and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
initial equation
  assert(budget >= 0 and budget <= 1, "Occupancy budget must be in [0,1].");
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
  result.value=duration; result.valueAvailable=(observedDuration>0) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
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
  der(duration) = if inWindow and dataOK and unsafe then 1 else 0;
  fraction = if noEvent(observedDuration > 0) then min(1,max(0,duration/observedDuration)) else 0;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if fraction <= budget then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-64,-24},{64,40}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4, radius=0),
        Rectangle(extent={{-48,-24},{-29,40}}, lineColor={128,128,128}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.35, radius=0),
        Rectangle(extent={{0,-24},{28,40}}, lineColor={128,128,128}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.35, radius=0),
        Line(points={{-64,-24},{-48,-24},{-48,40},{-29,40},{-29,-24},{0,-24},{0,40},{28,40},{28,-24},{64,-24}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-64,-38},{64,-38}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-64,-43},{-64,-33}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{64,-43},{64,-33}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="Tu / Tv", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="ConditionOccupancy")}),
    Documentation(info="<html><p>Integrates the valid time for which <code>unsafe</code> is true in <code>[windowStart, windowEnd)</code>. <code>duration</code> is measured in seconds and <code>fraction</code> is the duration divided by valid observed time. The reported numerical result is the duration.</p><p>Set <code>budget</code> between 0 and 1. With complete valid observation, a fraction no greater than this inclusive limit satisfies the requirement. Connect <code>valid</code>; the budget is a fraction, not a time allowance.</p></html>"));
end ConditionOccupancy;
