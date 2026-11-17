within EvaluationLibrary.Comparison;
block ChannelConsistency "Instantaneous range of valid simultaneous channels"
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

  parameter Integer n(min=2)=3 "Number of simultaneous channels; at least two";
  parameter Boolean useChannelValid=false "Expose per-channel validity flags";
    Modelica.Blocks.Interfaces.RealInput u[n] "Observed signal" annotation(Placement(transformation(origin={-100,42},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,42},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput channelValid[n] if useChannelValid "Validity flag for each channel" annotation(Placement(transformation(origin={-100,14},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput nValid "Number of currently eligible channels" annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Interfaces.RealOutput value "Numerical value; check result.valueAvailable" annotation(Placement(transformation(origin={100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True when the numerical value is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Internal validity signal" annotation(Placement(transformation(origin={-100,-14},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "Internal external-window signal" annotation(Placement(transformation(origin={-100,-42},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-42},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation-window qualification";
  Boolean dataOK "Combined input validity";
  Boolean violationNow "Current valid violation condition";
  Modelica.Blocks.Interfaces.BooleanInput validity[n] "Internal channel-validity signals" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Boolean eligible[n] "Finite and valid channel flags";
initial equation
  assert(n>=2,"At least two channels are required.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted and nValid>=2;
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

  connect(channelValid,validity);
  if not useChannelValid then validity=fill(true,n); end if;
  for i in 1:n loop
    eligible[i]=validity[i] and abs(u[i])<Modelica.Constants.inf;
  end for;
  nValid=sum({if eligible[i] then 1 else 0 for i in 1:n});
  available=gate.inWindow and dataOK;
  value=if available then max({if eligible[i] then u[i] else -Modelica.Constants.inf for i in 1:n})
                       -min({if eligible[i] then u[i] else Modelica.Constants.inf for i in 1:n}) else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,-28},{65,-28}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-43,-28},{-43,5}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-4,-28},{-4,42}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{35,-28},{35,24}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Ellipse(extent={{-47,1},{-39,9}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-8,38},{0,46}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{31,20},{39,28}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Line(points={{56,5},{56,42}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{44,5},{63,5}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{5,42},{63,42}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="max - min", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Returns the current maximum minus minimum across eligible channels in a common unit. At least two finite channels and shared validity are required. Enable <code>useChannelValid</code> to exclude individual channels.</p><p>The numerical value is available only while the observation window is active. It is not retained as a final maximum range. The result still carries observation coverage and validity history; use a separate statistic when a retained range summary is needed.</p></html>"));
end ChannelConsistency;
