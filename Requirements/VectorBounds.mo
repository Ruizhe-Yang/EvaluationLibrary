within EvaluationLibrary.Requirements;
block VectorBounds "Evaluate independent finite numeric channel bounds"
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
  output Boolean everViolated(start=false,fixed=true) "A qualified violation witness exists";
  output Modelica.Units.SI.Time firstViolationTime(start=0,fixed=true) "First qualified violation instant; meaningful only when everViolated";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete directly reportable evidence result" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

  parameter Integer n(min=1)=3 "Number of channels, records or configured items; at least one";
  parameter Real lower[n]=fill(0,n) "Inclusive lower acceptance bound";
  parameter Real upper[n]=fill(1,n) "Inclusive upper acceptance bound";
  parameter Real tolerance[n]=fill(0,n) "Nonnegative numerical acceptance allowance";
  parameter String channelUnit[n]=fill("1",n) "Engineering unit of each simultaneous channel";
  parameter Boolean useChannelValid=false "Expose per-channel validity flags";
    Modelica.Blocks.Interfaces.RealInput u[n] "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,42},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,42},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput channelValid[n] if useChannelValid "Channel valid" annotation(Placement(transformation(origin={-100,14},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput perChannelVerdict[n] "Per channel verdict" annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));
  output Boolean channelViolated[n](each start=false,each fixed=true) "Channel violated";
  output Modelica.Units.SI.Time channelFirstViolation[n](each start=0,each fixed=true) "Channel first violation";
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
  Boolean qualifiedChannel[n] "Qualified channel";
  Boolean violation[n] "Violation";
  Boolean invalid[n] "Invalid";
  discrete Boolean invalidSeen[n](each start=false,each fixed=true) "Invalid seen";
initial equation
  assert(n>=1,"At least one channel is required.");
  for i in 1:n loop
    assert(lower[i]<=upper[i] and tolerance[i]>=0 and abs(lower[i])<Modelica.Constants.inf and
      abs(upper[i])<Modelica.Constants.inf and tolerance[i]<Modelica.Constants.inf,"Invalid channel bound.");
  end for;
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=sum({if qualifiedChannel[i] then 1 else 0 for i in 1:n})==n;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=false;
  violationNow=(if false then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
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

  connect(channelValid,validity);
  if not useChannelValid then validity=fill(true,n); end if;
  for i in 1:n loop
    qualifiedChannel[i]=trusted and validity[i] and abs(u[i])<Modelica.Constants.inf;
    violation[i]=gate.inWindow and qualifiedChannel[i] and (u[i]<lower[i]-tolerance[i] or u[i]>upper[i]+tolerance[i]);
    invalid[i]=gate.inWindow and not qualifiedChannel[i];
    when {initial(),violation[i],invalid[i]} then
      channelViolated[i]=(not initial() and pre(channelViolated[i])) or violation[i];
      channelFirstViolation[i]=if violation[i] and (initial() or not pre(channelViolated[i])) then time
        elseif initial() then 0 else pre(channelFirstViolation[i]);
      invalidSeen[i]=(not initial() and pre(invalidSeen[i])) or invalid[i];
    end when;
    perChannelVerdict[i]=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(if invalidSeen[i] then EvaluationLibrary.Utilities.Types.DataStatus.INVALID
      elseif gate.status==EvaluationLibrary.Utilities.Types.DataStatus.INVALID then (if gate.complete and gate.actualStop>gate.actualStart and
      gate.observedDuration>=gate.actualStop-gate.actualStart-1e-7 then EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE else EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE)
      else gate.status,channelViolated[i],true));
  end for;
  value=sum({if channelViolated[i] then 1 else 0 for i in 1:n});
  available=gate.observedDuration>0 or everViolated;
algorithm
  when {initial(),sum({if violation[i] then 1 else 0 for i in 1:n})>0} then
    if sum({if violation[i] then 1 else 0 for i in 1:n})>0 and not pre(everViolated) then
      everViolated:=true;
      firstViolationTime:=time;
    end if;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-60,25},{60,49}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45, radius=0),
        Rectangle(extent={{-42,-8},{49,16}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45, radius=0),
        Rectangle(extent={{-55,-41},{32,-17}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45, radius=0),
        Ellipse(extent={{-15.7,33.3},{-8.3,40.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{20.3,0.3},{27.7,7.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{42.3,-32.7},{49.7,-25.3}}, lineColor={191,0,0}, fillColor={191,0,0}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Line(points={{67,49},{74,49},{74,-41},{67,-41}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="Li <= ui <= Ui", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Apply independent inclusive lower/upper bounds and tolerances to n simultaneous channels. Defaults are n=3, bounds zero and one and zero tolerance. channelUnit labels each channel; optional channelValid combines with common validity. Per-channel results and violation witnesses remain separate; no cross-unit numerical total is formed.</p><p>The default fixed observation is [0,5) s. ExternalSingle instead observes only the first contiguous external gate; a later gate invalidates the history. useValidInput defaults to false; when enabled, false validity or nonfinite in-window data latch INVALID. Early normal termination or missing coverage is INCOMPLETE. DataStatus qualifies evidence independently of Verdict. Numeric availability and violation witnesses must be inspected separately. Stable identity, unitName and optional requirement metadata originate here and travel directly with result to a writer.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end VectorBounds;
