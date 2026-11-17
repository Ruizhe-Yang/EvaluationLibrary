within EvaluationLibrary.Statistics;
block EnergyEfficiency "Energy efficiency over an observation interval"
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

  Modelica.Blocks.Interfaces.BooleanInput valid "External input-validity condition" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "True while the observation window is active" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Status of the observation data";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  parameter Modelica.Units.SI.Energy minimumInput(min=Modelica.Constants.small) = 1e-3 "Positive minimum observed input energy in joules";
  parameter Real requiredEfficiency(min=0,max=1) = 0.8 "Inclusive minimum useful-energy fraction between zero and one";
  Modelica.Blocks.Interfaces.RealInput inputPower(unit="W") "Input power" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput usefulPower(unit="W") "Useful power" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput inputEnergy(unit="J",start=0,fixed=true) "Accumulated input energy" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput usefulEnergy(unit="J",start=0,fixed=true) "Accumulated useful output energy" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.RealOutput efficiency "Useful-to-input energy ratio; check result.valueAvailable" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement verdict";
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable) "Observation coverage and qualification";
  Boolean dataOK "External validity and numerical-domain checks";
initial equation
  assert(minimumInput > 0 and requiredEfficiency >= 0 and requiredEfficiency <= 1, "Invalid efficiency limits.");
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
  result.value=efficiency; result.valueAvailable=(inputEnergy>=minimumInput) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
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
  dataOK = valid and abs(inputPower) < Modelica.Constants.inf and abs(usefulPower) < Modelica.Constants.inf and inputPower >= 0 and usefulPower >= 0;
  der(inputEnergy) = if inWindow and dataOK then inputPower else 0;
  der(usefulEnergy) = if inWindow and dataOK then usefulPower else 0;
  efficiency = if inputEnergy >= minimumInput then usefulEnergy/inputEnergy else 0;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if inputEnergy < minimumInput then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED elseif efficiency >= requiredEfficiency then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-54,24},{54,46}}, lineColor={128,128,128}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55, radius=0),
        Rectangle(extent={{-54,-19},{26,3}}, lineColor={0,0,127}, fillColor={225,231,240}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.65, radius=0),
        Text(extent={{-58,72},{10,50}}, textString="Ein", textColor={64,64,64}, fontSize=0),
        Text(extent={{-58,-22},{10,-43}}, textString="Eout", textColor={0,0,127}, fontSize=0),
        Line(points={{60,46},{66,46},{66,-19},{60,-19}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="Eout / Ein", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="EnergyEfficiency")}),
    Documentation(info="<html><p>Integrates non-negative finite <code>inputPower</code> and <code>usefulPower</code> in watts to obtain energies in joules. The useful-to-input energy ratio is available once <code>inputEnergy &gt;= minimumInput</code>. With complete valid coverage, a ratio at least <code>requiredEfficiency</code> satisfies the requirement. The block does not enforce an upper bound on the measured ratio.</p><p>Connect <code>valid</code> and configure the half-open interval <code>[windowStart, windowEnd)</code>. Invalid data within the interval invalidate the result. Normal termination before full coverage is reported as <code>INCOMPLETE</code>. Check the status and availability fields of <code>result</code> when reporting the measurement.</p></html>"));
end EnergyEfficiency;
