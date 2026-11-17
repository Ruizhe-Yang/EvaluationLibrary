within EvaluationLibrary.Requirements;
block CircularErrorBound "Check an inclusive bound on a wrapped angular error"
  parameter String metricId=getInstanceName() "Identifier carried by the result";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Optional requirement version";
  parameter String unitName="rad" "Unit label for the reported value";
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
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid observation duration" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  Modelica.Blocks.Interfaces.BooleanOutput violationObserved "Violation observed" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput firstViolationTime(unit="s",start=0,fixed=true) "Time of the first valid violation" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement outcome, separate from data qualification";
  parameter Modelica.Units.SI.Angle bound(min=0,max=Modelica.Constants.pi) = 0.1 "Inclusive error or skew bound in the declared unit";
  Modelica.Blocks.Interfaces.RealInput angle(unit="rad") "Angle" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput reference(unit="rad") "Reference signal in the same unit as the input" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput error(unit="rad") "Error" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable) "Observation coverage and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
  Boolean outside "Outside";
  Boolean violationNow "Valid requirement violation at the current instant";
  discrete Boolean seen(start=false,fixed=true) "True after the condition has been observed";
initial equation
  assert(bound >= 0 and bound <= Modelica.Constants.pi, "Circular bound must be in [0,pi].");
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
  result.value=error; result.valueAvailable=(observedDuration>0) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=EvaluationLibrary.Utilities.Functions.QualifiedCode(Integer(resultStatus),if violationObserved then 3 else Integer(verdict));
  result.complete=time>=windowEnd or terminalSeen;
  result.windowStart=windowStart; result.windowStop=windowEnd;
  result.observedDuration=evidence.totalObservedDuration;
  result.validDuration=observedDuration;
  result.expectedSamples=0; result.receivedSamples=0; result.validSamples=0;
  result.everViolated=violationObserved; result.firstViolationTime=firstViolationTime;
  result.samplePeriod=0; result.evidenceKind=1;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  violationNow = inWindow and dataOK and outside;
  when {initial(), violationNow} then
    seen = if initial() then violationNow else true;
    firstViolationTime = if violationNow and not pre(seen) then time else pre(firstViolationTime);
  end when;
  violationObserved = seen;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if seen then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED else EvaluationLibrary.Utilities.Types.Verdict.SATISFIED;
  dataOK = valid and abs(angle) < Modelica.Constants.inf and abs(reference) < Modelica.Constants.inf;
  error = if dataOK then Modelica.Math.atan2(sin(angle-reference),cos(angle-reference)) else 0;
  outside = abs(error) > bound;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Ellipse(extent={{-51,-44},{51,58}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.55),
        Line(points={{0,7},{43.1024,45.8096}}, color={128,128,128}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{0,7},{57.2859,16.0732}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{34.5691,12.4752},{34.103,14.8733},{33.4707,17.233},{32.6753,19.5429},{31.7208,21.7916},{30.6117,23.9683},{29.3535,26.0624},{27.9522,28.0635},{26.4148,29.9621}}, color={0,0,127}, thickness=0.85, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Ellipse(extent={{-3.2,3.8},{3.2,10.2}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Text(extent={{-51,68},{-8,45}}, textString="rad", textColor={128,128,128}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="|dphi| <= b", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="CircularErrorBound")}),
    Documentation(info="<html><p>Computes the principal angular difference <code>atan2(sin(angle-reference), cos(angle-reference))</code> in radians. A valid observation violates the requirement when its absolute value exceeds <code>bound</code>. The bound must lie between 0 and pi; the first violation is retained.</p><p>Connect both angular signals and <code>valid</code>, and set the fixed interval <code>[windowStart, windowEnd)</code>. The result reports the current signed angular error. A satisfied verdict requires complete valid observation.</p></html>"));
end CircularErrorBound;
