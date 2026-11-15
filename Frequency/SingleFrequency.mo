within EvaluationLibrary.Frequency;
block SingleFrequency "Evaluate the amplitude and phase of one selected frequency"
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
  parameter Integer nSamples(min=16,max=1024)=200 "Number of uniformly spaced observations in the finite record";
  parameter EvaluationLibrary.Utilities.Types.Taper taper=EvaluationLibrary.Utilities.Types.Taper.Rectangular "Finite spectral taper; rectangular or Hann";
  parameter Boolean removeMean=false "Subtract the sample mean before spectral projection";
    Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  output Modelica.Units.SI.Frequency frequencyResolution "Frequency resolution";
  output Modelica.Units.SI.Frequency nyquist "Nyquist";

  parameter Modelica.Units.SI.Frequency frequency(min=0)=5 "Selected frequency in hertz, not above Nyquist";
  output Real re(start=0,fixed=true) "Re";
  output Real im(start=0,fixed=true) "Im";
  output Real amplitude(start=0,fixed=true) "Amplitude";
  output Real phase(unit="rad",start=0,fixed=true) "Phase";
  Modelica.Blocks.Interfaces.RealOutput value "Numerical metric; meaningful only when available" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "The numerical output exists in the current data domain" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Trusted" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Gate";
  Boolean dataOK "Data ok";
  Boolean violationNow "Violation now";
  EvaluationLibrary.Utilities.Internal.SpectrumBuffer cache(n=nSamples) "Cache";

initial equation
  assert(nSamples>=16 and nSamples<=1024,"Invalid spectral sample count.");
  assert(frequency>=0 and frequency*samplePeriod<=0.5,"The selected frequency exceeds Nyquist.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted and abs(u)<Modelica.Constants.inf;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=cache.overflow or (false);
  violationNow=(if true then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
  when {initial(),violationNow} then
    everViolated=(not initial() and pre(everViolated)) or violationNow;
    firstViolationTime=if violationNow and (initial() or not pre(everViolated)) then time
      else if initial() then 0 else pre(firstViolationTime);
  end when;
  dataStatus=if gate.status==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and cache.count<>nSamples then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else gate.status;
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
  result.evidenceKind=Integer(EvaluationLibrary.Utilities.Types.EvidenceKind.Sampled);
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

  cache.u=u;
  cache.take=gate.sampleInWindow and dataOK and gate.tick;
  frequencyResolution=1/(nSamples*samplePeriod);
  nyquist=1/(2*samplePeriod);
  value=if available then amplitude else 0;
  available=cache.ready and gate.complete and dataStatus==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and (true);
algorithm
  when cache.ready then
    (re,im,amplitude,phase):=EvaluationLibrary.Utilities.Functions.Tone(cache.samples,samplePeriod,frequency,taper,removeMean);
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,61},{-64,-38},{65,-38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-12,-38},{-12,44}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Ellipse(extent={{-15.8,40.2},{-8.2,47.8}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{-49,-12},{-17,-12}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Ellipse(extent={{26,18},{61,53}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{43.5,35.5},{55,47}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="A, φ @ f", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Project the ordered finite record onto sine and cosine at frequency, default 5 Hz. nSamples defaults to 200, samplePeriod to 0.01 s, rectangular taper and removeMean=false. The declared frequency must not exceed Nyquist. Return amplitude in the input unit and phase in radians; finite record length and taper determine leakage, so this is not an infinite-duration spectrum.</p><p>The default fixed observation is [0,5) s. ExternalSingle instead observes only the first contiguous external gate; a later gate invalidates the history. useValidInput defaults to false; when enabled, false validity or nonfinite in-window data latch INVALID. Early normal termination or missing coverage is INCOMPLETE. DataStatus qualifies evidence independently of Verdict. Numeric availability and violation witnesses must be inspected separately. Stable identity, unitName and optional requirement metadata originate here and travel directly with result to a writer.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end SingleFrequency;
