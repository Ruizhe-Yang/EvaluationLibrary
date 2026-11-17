within EvaluationLibrary.Requirements;
block NumericRequirement "Apply numerical acceptance bounds to an existing metric"
  parameter String metricId=getInstanceName() "Identifier carried by the result";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Optional requirement version";
  parameter String unitName="1" "Unit label for the reported value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Value, qualification and requirement outcome" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "True after normal simulation termination";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Latched valid requirement violation";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "Time of the first valid requirement violation";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Qualification of the reported result";
  parameter EvaluationLibrary.Utilities.Types.NumericComparison comparison = EvaluationLibrary.Utilities.Types.NumericComparison.Inside "Numeric bound interpretation";
  parameter Real lower = 0 "Inclusive lower limit";
  parameter Real upper = 1 "Inclusive upper limit";
  Modelica.Blocks.Interfaces.RealInput value "Numerical evidence in the units of the bounds" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));
  Modelica.Blocks.Interfaces.BooleanInput defined "The metric value exists" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  input EvaluationLibrary.Utilities.Types.DataStatus dataState "Evidence coverage and validity";
  Modelica.Blocks.Interfaces.RealOutput margin "Signed distance to applicable boundary" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement outcome";
protected
  Boolean finiteValue "Finite value";
initial equation
  assert(comparison <> EvaluationLibrary.Utilities.Types.NumericComparison.Inside or lower <= upper, "Inverted range.");
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
  result.value=value; result.valueAvailable=(defined and finiteValue) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=EvaluationLibrary.Utilities.Functions.QualifiedCode(Integer(resultStatus),if qualifiedViolation then 3 else Integer(verdict));
  result.complete=terminalSeen or result.dataStatus<>1;
  result.windowStart=0; result.windowStop=0;
  result.observedDuration=0;
  result.validDuration=0;
  result.expectedSamples=0; result.receivedSamples=0; result.validSamples=0;
  result.everViolated=qualifiedViolation; result.firstViolationTime=qualifiedViolationTime;
  result.samplePeriod=0; result.evidenceKind=4;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
  finiteValue = noEvent(abs(value) < Modelica.Constants.inf);
  margin = if defined and finiteValue then
    (if comparison == EvaluationLibrary.Utilities.Types.NumericComparison.AtMost then upper-value elseif comparison == EvaluationLibrary.Utilities.Types.NumericComparison.AtLeast then value-lower
      else min(value-lower,upper-value)) else 0;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if not defined then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED elseif not finiteValue then EvaluationLibrary.Utilities.Types.Verdict.INVALID elseif noEvent(margin>=0) then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,5},{66,5}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid),
        Rectangle(extent={{-38,-5},{34,15}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-38,-12},{-38,25}}, color={64,64,64}, thickness=0.75, pattern=LinePattern.Solid),
        Line(points={{34,-12},{34,25}}, color={64,64,64}, thickness=0.75, pattern=LinePattern.Solid),
        Ellipse(extent={{3.8,0.8},{12.2,9.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Text(extent={{-48,-17},{-26,-38}}, textString="L", textColor={64,64,64}, fontSize=0),
        Text(extent={{23,-17},{45,-38}}, textString="U", textColor={64,64,64}, fontSize=0),
        Text(extent={{-61,63},{61,37}}, textString="<=  >=  []", textColor={0,0,127}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="qualified value", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Interprets <code>value</code> using the supplied <code>defined</code> flag and <code>dataState</code>. Choose <code>AtMost</code>, <code>AtLeast</code> or <code>Inside</code> to apply an inclusive upper bound, lower bound or interval. The signed <code>margin</code> is non-negative for an accepted value.</p><p>A requirement verdict is issued only for complete evidence with a defined finite value. Missing coverage remains undecided and invalid input remains invalid. This block does not collect a new observation window; duration and sample-count metadata are not inferred.</p></html>"));
end NumericRequirement;
