within EvaluationLibrary.Comparison;
block ChannelConsistency "Compare the range of qualified simultaneous channels"
  parameter String metricId=getInstanceName() "Stable metric identity";
  parameter String requirementId="" "Requirement identity; empty for a statistic";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName="1" "Engineering unit of the reported value";
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed-time or first externally gated observation window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive observation start in seconds";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive observation stop in seconds";
  parameter Boolean applicable=true "Whether this evaluation applies";
  parameter Boolean useValidInput=false "Expose the host-provided validity connector";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Positive uniform sampling interval in seconds";
  parameter Modelica.Units.SI.Time sampleStart=0 "Uniform sample grid origin in seconds";
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "Host declares the observed inputs valid" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Evidence qualification independent of requirement verdict";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement decision independent of observation completeness";
  output Boolean complete "Collection has closed; inspect DataStatus before assuming full evidence";
  output Boolean everViolated "A qualified violation witness exists";
  output Modelica.Units.SI.Time firstViolationTime "First qualified violation instant; meaningful only when everViolated";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete directly reportable evidence result" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

  parameter Integer n(min=2)=3 "Number of channels, records or configured items; at least one";
  parameter Boolean useChannelValid=false "Expose per-channel validity flags";
    Modelica.Blocks.Interfaces.RealInput u[n] "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,42},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,42},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput channelValid[n] if useChannelValid "Channel valid" annotation(Placement(transformation(origin={-100,14},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput nValid "N valid" annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Interfaces.RealOutput value "Numerical metric; meaningful only when available" annotation(Placement(transformation(origin={100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "The numerical output exists in the current data domain" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Trusted" annotation(Placement(transformation(origin={-100,-14},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-42},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-42},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Gate";
  Boolean dataOK "Data ok";
  Boolean violationNow "Violation now";
  Modelica.Blocks.Interfaces.BooleanInput validity[n] "Validity" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Boolean eligible[n] "Eligible";
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
    Documentation(info="<html><p>Compare simultaneous finite channels in one common engineering unit. n defaults to 3 and must be at least two; optional channelValid combines per-channel and shared validity. Return the observed channel range and retained evidence. This range is not a difference between time windows or a score across unlike physical units.</p><p>The default fixed observation is [0,5) s. ExternalSingle instead observes only the first contiguous external gate; a later gate invalidates the history. useValidInput defaults to false; when enabled, false validity or nonfinite in-window data latch INVALID. Early normal termination or missing coverage is INCOMPLETE. DataStatus qualifies evidence independently of Verdict. Numeric availability and violation witnesses must be inspected separately. Stable identity, unitName and optional requirement metadata originate here and travel directly with result to a writer.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end ChannelConsistency;
