within EvaluationLibrary.Frequency;
block SingleFrequency "Amplitude and phase at a selected frequency"
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
  parameter Integer nSamples(min=16,max=1024)=200 "Number of uniformly spaced observations in the finite record";
  parameter EvaluationLibrary.Utilities.Types.Taper taper=EvaluationLibrary.Utilities.Types.Taper.Rectangular "Rectangular or Hann taper";
  parameter Boolean removeMean=false "Subtract the sample mean before spectral projection";
    Modelica.Blocks.Interfaces.RealInput u "Observed signal" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  output Modelica.Units.SI.Frequency frequencyResolution "Frequency-bin spacing";
  output Modelica.Units.SI.Frequency nyquist "Nyquist frequency";

  parameter Modelica.Units.SI.Frequency frequency(min=0)=5 "Selected frequency in hertz, not above Nyquist";
  output Real re(start=0,fixed=true) "Real Fourier coefficient";
  output Real im(start=0,fixed=true) "Imaginary Fourier coefficient";
  output Real amplitude(start=0,fixed=true) "Fourier amplitude";
  output Real phase(unit="rad",start=0,fixed=true) "Fourier phase";
  Modelica.Blocks.Interfaces.RealOutput value "Numerical value; check result.valueAvailable" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True when the numerical value is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Internal validity signal" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "Internal external-window signal" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation-window qualification";
  Boolean dataOK "Combined input validity";
  Boolean violationNow "Current valid violation condition";
  EvaluationLibrary.Utilities.Internal.SpectrumBuffer cache(n=nSamples) "Finite sample buffer";

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
    Documentation(info="<html><p>Projects the sampled input onto a selected frequency between zero and Nyquist. Outputs are the real and imaginary coefficients, amplitude in the input unit, and phase in radians. <code>result.value</code> reports amplitude. Select rectangular or Hann tapering and optional mean removal; phase at negligible amplitude should not be interpreted.</p><p>Choose the observation interval and sample grid to provide exactly <code>nSamples</code> valid samples. Fewer samples give incomplete evidence; extra samples overflow the buffer. For <code>sampleStart=windowStart=0</code>, <code>samplePeriod=0.01</code> and <code>nSamples=200</code>, set <code>windowStop=2</code>. The result is available after the interval closes. Tapering and record length affect spectral leakage.</p></html>"));
end SingleFrequency;
