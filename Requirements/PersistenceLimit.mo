within EvaluationLibrary.Requirements;
block PersistenceLimit "Limit the duration of each continuous true interval"
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

  parameter Modelica.Units.SI.Time maxDuration(min=0)=1 "Inclusive allowed uninterrupted duration in seconds";
    Modelica.Blocks.Interfaces.BooleanInput u "Observed Boolean condition" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  output Modelica.Units.SI.Time currentDuration "Duration of the active uninterrupted true interval";
  output Modelica.Units.SI.Time longestDuration "Longest valid uninterrupted true interval";
  Modelica.Blocks.Interfaces.RealOutput value "Numerical result; meaningful only when available" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True if the numerical result is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Effective input validity" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation window and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
  Boolean violationNow "Valid requirement violation at the current instant";
  Boolean during "Valid true condition inside the observation window";
  discrete Modelica.Units.SI.Time began(start=0,fixed=true) "Start time of the active true interval";
  discrete Modelica.Units.SI.Time longestComplete(start=0,fixed=true) "Longest completed true interval";
initial equation
  assert(maxDuration>=0,"Negative persistence duration.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=false;
  violationNow=(if false then gate.sampleInWindow else gate.inWindow) and dataOK and (during and currentDuration>maxDuration);
  when {initial(),violationNow} then
    everViolated=(not initial() and pre(everViolated)) or violationNow;
    firstViolationTime=if violationNow and (initial() or not pre(everViolated)) then time
      else if initial() then 0 else pre(firstViolationTime);
  end when;
  dataStatus=gate.status;
  verdict=EvaluationLibrary.Utilities.Functions.ToVerdict(dataStatus,everViolated,true);
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
  result.evidenceKind=Integer(EvaluationLibrary.Utilities.Types.EvidenceKind.Continuous);
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

  during=gate.inWindow and dataOK and u;
  when {initial(),change(during)} then
    began=if initial() or during then time else pre(began);
    longestComplete=if initial() then 0 elseif not during then max(pre(longestComplete),time-pre(began)) else pre(longestComplete);
  end when;
  currentDuration=if during then time-began else 0;
  longestDuration=max(longestComplete,currentDuration);
  value=longestDuration;
  available=gate.validDuration>0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-6,-18},{46,35}}, lineColor={235,235,235}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.1, radius=0),
        Line(points={{-66,-18},{-54,-18},{-54,35},{-39,35},{-39,-18},{-6,-18},{-6,35},{46,35},{46,-18},{66,-18}}, color={0,0,127}, thickness=1.05, pattern=LinePattern.Solid),
        Line(points={{25,-42},{25,59}}, color={191,0,0}, thickness=0.7, pattern=LinePattern.Dash),
        Text(extent={{14,77},{35,56}}, textString="T", textColor={191,0,0}, fontSize=0),
        Line(points={{-6,-35},{46,-35}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-6,-40},{-6,-30}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{46,-40},{46,-30}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="max(dt) <= T", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Measures each uninterrupted interval for which <code>u</code> is true and valid inside the observation window. A duration strictly greater than <code>maxDuration</code> is a violation; equality is accepted. <code>currentDuration</code> describes the active interval, while <code>longestDuration</code> and <code>value</code> retain the longest interval.</p><p>A false input, invalid input or window closure ends the active interval. Configure a fixed or externally gated window and read the qualified verdict through <code>result</code>. Separate true intervals are not added when applying the duration limit.</p></html>"));
end PersistenceLimit;
