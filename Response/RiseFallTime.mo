within EvaluationLibrary.Response;
block RiseFallTime "Measure the elapsed time between two directed level crossings"
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

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "True inside the applicable observation window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Observation coverage and data validity";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid observation duration" annotation(Placement(transformation(extent={{94,49},{106,61}}), iconTransformation(extent={{94,49},{106,61}})));
  parameter Real firstLevel = 0.1 "First crossing level in the signal unit";
  parameter Real secondLevel = 0.9 "Second crossing level in the signal unit";
  parameter Boolean falling = false "Measure the falling rather than rising transition";
  Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.BooleanOutput started(start=false,fixed=true) "Started" annotation(Placement(transformation(extent={{94,21},{106,33}}), iconTransformation(extent={{94,21},{106,33}})));
  Modelica.Blocks.Interfaces.BooleanOutput finished(start=false,fixed=true) "Finished" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput firstTime(unit="s",start=0,fixed=true) "Time of the first directed level crossing" annotation(Placement(transformation(extent={{94,-33},{106,-21}}), iconTransformation(extent={{94,-33},{106,-21}})));
  Modelica.Blocks.Interfaces.RealOutput secondTime(unit="s",start=0,fixed=true) "Time of the second directed level crossing" annotation(Placement(transformation(extent={{94,-61},{106,-49}}), iconTransformation(extent={{94,-61},{106,-49}})));
  Modelica.Blocks.Interfaces.RealOutput duration(unit="s") "Duration" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable) "Observation coverage and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
  Boolean firstHit "Valid observation beyond the first directed level";
  Boolean secondHit "Valid observation beyond the second directed level";
initial equation
  assert(if falling then firstLevel > secondLevel else firstLevel < secondLevel, "Levels must match the measurement direction.");
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (dataState)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (dataState);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=duration; result.valueAvailable=(finished) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(resultStatus,qualifiedViolation,false));
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
  dataOK = valid and abs(u) < Modelica.Constants.inf;
  firstHit = inWindow and dataOK and (if falling then u <= firstLevel else u >= firstLevel);
  secondHit = inWindow and dataOK and started and (if falling then u <= secondLevel else u >= secondLevel);
  when {initial(), firstHit} then
    started = if initial() then firstHit else true;
    firstTime = if firstHit and not pre(started) then time else pre(firstTime);
  end when;
  when {initial(), secondHit} then
    finished = if initial() then secondHit else true;
    secondTime = if secondHit and not pre(finished) then time else pre(secondTime);
  end when;
  duration = if finished then secondTime-firstTime else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,-26},{65,-26}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{-65,39},{65,39}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{-64,-34},{-54,-34},{-44,-27},{-28,-6},{-12,15},{10,38},{35,47},{64,47}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-43.2381,-26},{-43.2381,-44}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{12.7778,39},{12.7778,-44}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{-43.2381,-39},{12.7778,-39}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-43.2381,-44},{-43.2381,-34}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{12.7778,-44},{12.7778,-34}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-83,-18},{-65,-34}}, textString="L1", textColor={128,128,128}, fontSize=0),
        Text(extent={{-83,47},{-65,31}}, textString="L2", textColor={128,128,128}, fontSize=0),
        Line(points={{56,36},{56,-16}}, color={128,128,128}, thickness=0.75, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="dt(levels)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="RiseFallTime")}),
    Documentation(info="<html><p>Records the first valid crossing of <code>firstLevel</code>, followed by the first valid crossing of <code>secondLevel</code>. Set <code>falling=true</code> for decreasing transitions and order the levels accordingly.</p><p>Connect <code>u</code> and <code>valid</code>, and set <code>[windowStart, windowEnd)</code>. <code>duration</code> is available after <code>finished</code> becomes true. Levels are inclusive; a signal already beyond both levels at the window start may give zero duration.</p></html>"));
end RiseFallTime;
