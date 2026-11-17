within EvaluationLibrary.Comparison;
block PairedArrivalSkew "Time difference between two first observed arrivals"
  parameter String metricId=getInstanceName() "Metric identifier";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Requirement version";
  parameter String unitName="s" "Engineering unit of the reported value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Result record with value, status and observation metadata" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "True after normal simulation termination";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Retained valid violation flag";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "First valid violation time";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Status used in the result record";
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive observation start";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive observation end";
  parameter Boolean applicable = true "Whether this evaluation applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "External input-validity condition" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "True while the observation window is active" annotation(Placement(transformation(extent={{94,42},{106,54}}), iconTransformation(extent={{94,42},{106,54}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Status of the observation data";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  parameter Modelica.Units.SI.Time maximumSkew(min=0) = 0.1 "Maximum absolute skew";
  Modelica.Blocks.Interfaces.BooleanInput a "First stream arrival condition" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.BooleanInput b "Second stream arrival condition" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput skew(unit="s") "First B time minus first A time" annotation(Placement(transformation(extent={{94,-54},{106,-42}}), iconTransformation(extent={{94,-54},{106,-42}})));
  output Modelica.Units.SI.Time arrivedA(start=0,fixed=true) "First qualified arrival time on input a";
  output Modelica.Units.SI.Time arrivedB(start=0,fixed=true) "First qualified arrival time on input b";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement verdict";
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable) "Observation coverage and qualification";
  Boolean dataOK "External validity and numerical-domain checks";
  discrete Boolean seenA(start=false,fixed=true) "True after the first qualified arrival on a";
  discrete Boolean seenB(start=false,fixed=true) "True after the first qualified arrival on b";
  Boolean hitA "Qualified arrival condition for a";
  Boolean hitB "Qualified arrival condition for b";
initial equation
  assert(maximumSkew >= 0,"Skew must be nonnegative.");
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
  result.value=skew; result.valueAvailable=(seenA and seenB) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
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
  hitA = inWindow and dataOK and a;
  hitB = inWindow and dataOK and b;
  when {initial(),hitA} then
    seenA = pre(seenA) or hitA;
    arrivedA = if hitA and not pre(seenA) then time else pre(arrivedA);
  end when;
  when {initial(),hitB} then
    seenB = pre(seenB) or hitB;
    arrivedB = if hitB and not pre(seenB) then time else pre(arrivedB);
  end when;
  skew = if seenA and seenB then arrivedB-arrivedA else 0;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if not (seenA and seenB) then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED elseif noEvent(abs(skew)<=maximumSkew) then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,32},{-30,32},{-30,56},{65,56}}, color={128,128,128}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-64,-19},{27,-19},{27,5},{65,5}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-79,52},{-64,30}}, textString="A", textColor={128,128,128}, fontSize=0),
        Text(extent={{-79,1},{-64,-21}}, textString="B", textColor={0,0,127}, fontSize=0),
        Line(points={{-30,25},{-30,-41}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{27,-1},{27,-41}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{-30,-34},{27,-34}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-30,-39},{-30,-29}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{27,-39},{27,-29}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="tB - tA", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Records the first qualified true conditions on <code>a</code> and <code>b</code>, including a condition already true when the window opens. <code>skew</code> is the first B time minus the first A time. Both arrivals are needed for an available value.</p><p>Connect <code>valid</code> and configure <code>[windowStart, windowEnd)</code>. With complete valid coverage, <code>abs(skew) &lt;= maximumSkew</code> satisfies the requirement. A missing arrival leaves the decision unresolved.</p></html>"));
end PairedArrivalSkew;
