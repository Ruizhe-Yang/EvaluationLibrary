within EvaluationLibrary.Response;
block RiseTime "Measure the 10% to 90% progress time of a rising step"
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

  parameter Real referenceStart=0 "Declared pre-step signal value in the input unit";
  parameter Real referenceFinal=1 "Final signal value used to normalise step progress";
  parameter Modelica.Units.SI.Time stepTime=0.5 "Declared transition instant in seconds";
    Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput found(start=false,fixed=true) "True after both progress levels have been reached" annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));
  discrete Modelica.Units.SI.Time t10(start=0,fixed=true) "Time of the first 10% progress observation";
  discrete Modelica.Units.SI.Time t90(start=0,fixed=true) "Time of the first 90% progress observation";
  Modelica.Blocks.Interfaces.RealOutput value "Numerical result; meaningful only when available" annotation(Placement(transformation(origin={100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True if the numerical result is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Effective input validity" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation window and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
  Boolean violationNow "Valid requirement violation at the current instant";
  Real progress "Normalised progress of the declared step";
  Boolean cross10 "Valid observation at or beyond 10% progress";
  Boolean cross90 "Valid observation at or beyond 90% progress";
  discrete Boolean found10(start=false,fixed=true) "True after the 10% progress level has been reached";
initial equation
  assert(referenceFinal>referenceStart,"Step direction and nonzero amplitude are required.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted and abs(u)<Modelica.Constants.inf;
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

  progress=(u-referenceStart)/(referenceFinal-referenceStart);
  cross10=gate.inWindow and dataOK and time>=stepTime and progress>=0.1;
  cross90=gate.inWindow and dataOK and time>=stepTime and progress>=0.9;
  value=if found then t90-t10 else 0;
  available=found;
algorithm

  when {initial(),cross10,cross90} then
    if cross10 and not found10 then found10:=true; t10:=time; end if;
    if cross90 and found10 and not found then found:=true; t90:=time; end if;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
        Text(extent={{-83,-18},{-65,-34}}, textString="10", textColor={128,128,128}, fontSize=0),
        Text(extent={{-83,47},{-65,31}}, textString="90", textColor={128,128,128}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="t10-90", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Normalises the observed signal between <code>referenceStart</code> and <code>referenceFinal</code> for a declared rising step. The final reference must be greater than the initial reference. At or after <code>stepTime</code>, the first 10% and 90% progress observations are retained.</p><p>The numerical result is <code>t90-t10</code> and becomes available after both levels are reached. A discontinuous step may cross both at the same instant. Set the observation window to include the transition; this block measures a duration without imposing a requirement.</p></html>"));
end RiseTime;
