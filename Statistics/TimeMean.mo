within EvaluationLibrary.Statistics;
block TimeMean "Time-weighted mean of a continuous signal"
  parameter String metricId=getInstanceName() "Metric identifier";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Requirement version";
  parameter String unitName="1" "Engineering unit of the reported value";
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed interval or first contiguous external window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive observation start";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive observation stop";
  parameter Boolean applicable=true "Whether this evaluation applies";
  parameter Boolean useValidInput=false "Enable the external validity input";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Uniform sampling interval; must be positive";
  parameter Modelica.Units.SI.Time sampleStart=0 "Origin of the uniform sampling grid";
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "External input-validity condition" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Status of the observation data";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement verdict";
  output Boolean complete "True when collection has closed; check data status for completeness";
  output Boolean everViolated "True if a valid violation has been observed";
  output Modelica.Units.SI.Time firstViolationTime "First valid violation time; meaningful when everViolated is true";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Result record with value, status and observation metadata" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput u "Observed signal" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput value "Numerical value; check result.valueAvailable" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True when the numerical value is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Units.SI.Time duration "Accumulated valid observation duration";
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Internal validity signal" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "Internal external-window signal" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation-window qualification";
  Boolean dataOK "Combined input validity";
  Boolean violationNow "Current valid violation condition";
  EvaluationLibrary.Utilities.Internal.ContinuousAccumulator acc "Continuous or sampled accumulator";
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

  connect(u,acc.u);
  acc.integrate=gate.inWindow and dataOK;
  duration=gate.validDuration;
  available=duration>0 and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  value=if available then acc.total/gate.validDuration else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,61},{-64,-38},{65,-38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-56,10},{-54.4444,13.2632},{-52.8889,16.4705},{-51.3333,19.5671},{-49.7778,22.5},{-48.2222,25.219},{-46.6667,27.6777},{-45.1111,29.8338},{-43.5556,31.6506},{-42,33.097},{-40.4444,34.1481},{-38.8889,34.7861},{-37.3333,35},{-35.7778,34.7861},{-34.2222,34.1481},{-32.6667,33.097},{-31.1111,31.6506},{-29.5556,29.8338},{-28,27.6777},{-26.4444,25.219},{-24.8889,22.5},{-23.3333,19.5671},{-21.7778,16.4705},{-20.2222,13.2632},{-18.6667,10},{-17.1111,6.73685},{-15.5556,3.52952},{-14,0.432914},{-12.4444,-2.5},{-10.8889,-5.21904},{-9.33333,-7.67767},{-7.77778,-9.83383},{-6.22222,-11.6506},{-4.66667,-13.097},{-3.11111,-14.1481},{-1.55556,-14.7861},{0,-15},{1.55556,-14.7861},{3.11111,-14.1481},{4.66667,-13.097},{6.22222,-11.6506},{7.77778,-9.83383},{9.33333,-7.67767},{10.8889,-5.21904},{12.4444,-2.5},{14,0.432914},{15.5556,3.52952},{17.1111,6.73685},{18.6667,10},{20.2222,13.2632},{21.7778,16.4705},{23.3333,19.5671},{24.8889,22.5},{26.4444,25.219},{28,27.6777},{29.5556,29.8338},{31.1111,31.6506},{32.6667,33.097},{34.2222,34.1481},{35.7778,34.7861},{37.3333,35},{38.8889,34.7861},{40.4444,34.1481},{42,33.097},{43.5556,31.6506},{45.1111,29.8338},{46.6667,27.6777},{48.2222,25.219},{49.7778,22.5},{51.3333,19.5671},{52.8889,16.4705},{54.4444,13.2632},{56,10}}, color={0,0,127}, thickness=0.95, pattern=LinePattern.Solid),
        Line(points={{-57,10},{59,10}}, color={95,115,95}, thickness=0.6, pattern=LinePattern.Dash),
        Text(extent={{-65,-50},{65,-75}}, textString="mean(t)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Integrates finite valid values of <code>u</code> and divides by the accumulated valid duration. The result has the input unit and is available after a positive duration. It is a time-weighted mean rather than an arithmetic mean of output samples.</p><p>Set <code>windowStart</code> and <code>windowStop</code> for a half-open observation interval, or select <code>ExternalSingle</code> and connect the first contiguous <code>window</code> interval. A subsequent interval invalidates the result. Set <code>useValidInput=true</code> to supply external validity. Check <code>result.dataStatus</code> and <code>result.valueAvailable</code> before using the value.</p></html>"));
end TimeMean;
