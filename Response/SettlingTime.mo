within EvaluationLibrary.Response;
block SettlingTime "Confirm the final sustained entry into an error band"
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

  parameter Real reference=1 "Reference signal in the same unit as the input";
  parameter Real band(min=0)=0.02 "Inclusive absolute target-error radius";
  parameter Modelica.Units.SI.Time stepTime=0.5 "Declared transition instant in seconds";
  parameter Modelica.Units.SI.Time minDwell(min=0)=0.2 "Required uninterrupted valid residence in seconds";
    Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput settled(start=false,fixed=true) "True after settling is confirmed at window closure" annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));
  discrete Modelica.Units.SI.Time lastEntry(start=0,fixed=true) "Most recent valid entry into the settling band";
  Modelica.Blocks.Interfaces.RealOutput value "Numerical result; meaningful only when available" annotation(Placement(transformation(origin={100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True if the numerical result is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Effective input validity" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation window and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
  Boolean violationNow "Valid requirement violation at the current instant";
  Boolean inside "Valid in-band observation at or after the declared step";
initial equation
  assert(band>=0 and minDwell>=0,"Invalid settling band or dwell.");
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

  inside=gate.inWindow and dataOK and time>=stepTime and abs(u-reference)<=band;
  when {initial(),inside} then lastEntry=if inside then time else 0; end when;
  when gate.complete then settled=pre(inside) and gate.actualStop-pre(lastEntry)>=minDwell and dataStatus==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE; end when;
  value=if settled then lastEntry-stepTime else 0;
  available=settled;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-65,-3},{66,24}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.35, radius=0),
        Line(points={{-65,10.5},{66,10.5}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{-65,-34},{-49,-33},{-37,44},{-24,16},{-11,-20},{4,16},{15,31},{24,24},{28,19},{40,5},{51,12},{65,11}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-49,-43},{-49,56}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{24,-43},{24,56}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dash),
        Line(points={{66,-43},{66,57}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{24,42},{24,49},{66,49},{66,42}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{-49,-38},{24,-38}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-49,-43},{-49,-33}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{24,-43},{24,-33}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="t_settle", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Tracks entry into the inclusive band <code>abs(u-reference) &lt;= band</code> at or after <code>stepTime</code>. At window closure, settling is confirmed only if the signal remained valid and in the band for at least <code>minDwell</code> after its last entry, with complete observation coverage.</p><p>When <code>settled</code> is true, <code>value</code> is the last entry time minus <code>stepTime</code>. A temporary early entry is not sufficient. The value remains unavailable until the complete observation window has established settling.</p></html>"));
end SettlingTime;
