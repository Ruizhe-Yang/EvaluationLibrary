within EvaluationLibrary.Response;
block RecoveryTime "Measure recovery delay after a sustained valid return"
  parameter String metricId=getInstanceName() "Identifier carried by the result";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Optional requirement version";
  parameter String unitName="s" "Unit label for the reported value";
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed interval or first contiguous external window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive start of the observation window";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive end of the observation window";
  parameter Boolean applicable=true "True if this assessment is applicable";
  parameter Boolean useValidInput=false "Enable the optional input validity connector";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Uniform sampling interval for sampled evaluation";
  parameter Modelica.Units.SI.Time sampleStart=0 "Time origin of the uniform sample grid";
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "True if the observed inputs are valid" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Observation coverage and data validity";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement outcome, separate from data qualification";
  output Boolean complete "Observation has ended; completeness is reported by dataStatus";
  output Boolean everViolated "True after a valid violation has been observed";
  output Modelica.Units.SI.Time firstViolationTime "Time of the first valid violation";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Value, qualification and requirement outcome" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

  parameter Modelica.Units.SI.Time recoveryDwell(min=0)=0.2 "Required uninterrupted valid recovery duration in seconds";
    Modelica.Blocks.Interfaces.BooleanInput danger "Observed danger condition" annotation(Placement(transformation(origin={-100,35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput inRecoveryBand "True when the observed state is in the recovery band" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput recovered(start=false,fixed=true) "True after the required recovery dwell has completed" annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));
  discrete Modelica.Units.SI.Time dangerTime(start=0,fixed=true) "Time of the first valid danger observation";
  discrete Modelica.Units.SI.Time recoveredAt(start=0,fixed=true) "Time at which recovery is confirmed";
  Modelica.Blocks.Interfaces.RealOutput value "Numerical result; meaningful only when available" annotation(Placement(transformation(origin={100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True if the numerical result is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Effective input validity" annotation(Placement(transformation(origin={-100,-35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation window and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
  Boolean violationNow "Valid requirement violation at the current instant";
  Boolean hazard "Hazard";
  Boolean inDwell "Valid recovery condition following a danger event";
  Boolean qualifiedRecovery "True when the required uninterrupted dwell has elapsed";
  discrete Boolean seenDanger(start=false,fixed=true) "True after the first valid danger observation";
  discrete Modelica.Units.SI.Time enteredAt(start=0,fixed=true) "Start time of the current recovery dwell";
initial equation
  assert(recoveryDwell>=0,"Negative recovery dwell.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=false;
  violationNow=(if false then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
  when {initial(),violationNow} then
    everViolated=(not initial() and pre(everViolated)) or violationNow;
    firstViolationTime=if violationNow and (initial() or not pre(everViolated)) then time
      else if initial() then 0 else pre(firstViolationTime);
  end when;
  dataStatus=gate.status;
  verdict=EvaluationLibrary.Utilities.Functions.ToVerdict(dataStatus,everViolated,false);
  complete=gate.complete;
  result.value=value;
  result.valueAvailable=available and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(dataStatus);
  result.verdict=Integer(verdict);
  result.everViolated=everViolated;
  result.firstViolationTime=firstViolationTime;
  result.validDuration=gate.validDuration;
  result.expectedSamples=gate.expectedSamples;
  result.receivedSamples=gate.receivedSamples;
  result.validSamples=gate.validSamples;
  result.metricId=metricId;
  result.requirementId=requirementId;
  result.requirementVersion=requirementVersion;
  result.unit=unitName;
  result.windowStart=gate.actualStart;
  result.windowStop=gate.actualStop;
  result.observedDuration=gate.observedDuration;
  result.samplePeriod=if gate.sampled then samplePeriod else 0;
  result.evidenceKind=Integer(EvaluationLibrary.Utilities.Types.EvidenceKind.Event);
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable);
  result.eventCountsAvailable=false; result.eventCount=0;
  result.matchedCount=0;
  result.timedOutCount=0;
  result.censoredCount=0;
  result.levelAvailable=false;
  result.level=0;
  result.level0Upper=0;
  result.level1Upper=0;
  result.complete=complete;

  hazard=gate.inWindow and dataOK and danger;
  inDwell=gate.inWindow and dataOK and pre(seenDanger) and not danger and inRecoveryBand;
  qualifiedRecovery=pre(inDwell) and inDwell and time>=pre(enteredAt)+recoveryDwell;
  when {initial(),inDwell} then enteredAt=time; end when;
  value=if recovered then recoveredAt-dangerTime else 0;
  available=recovered;
algorithm

  when {initial(),hazard,qualifiedRecovery} then
    if hazard and not seenDanger then seenDanger:=true; dangerTime:=time; end if;
    if qualifiedRecovery and not recovered then recovered:=true; recoveredAt:=time; end if;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,29},{-51,29},{-51,58},{-19,58},{-19,29},{65,29}}, color={128,128,128}, thickness=1, pattern=LinePattern.Solid),
        Rectangle(extent={{-65,-29},{65,-8}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.35, radius=0),
        Line(points={{-65,7},{-28,7},{-15,-19},{-2,-19},{8,4},{22,-8},{30,-19},{63,-19}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-51,20},{-51,-41}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{22,-31},{22,-40},{62,-40},{62,-31}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid),
        Text(extent={{24,6},{67,-8}}, textString="dwell", textColor={64,64,64}, fontSize=0),
        Line(points={{-51,-47},{62,-47}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-51,-52},{-51,-42}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{62,-52},{62,-42}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="t_rec", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Records the first valid <code>danger</code> condition, then waits for danger to clear and <code>inRecoveryBand</code> to remain true for <code>recoveryDwell</code>. Loss of validity or departure from the band interrupts the dwell.</p><p>Once <code>recovered</code> is true, <code>value</code> reports the delay from the first danger observation to dwell completion. Configure the observation window to include both events. This block reports recovery time without assigning a recovery requirement verdict.</p></html>"));
end RecoveryTime;
