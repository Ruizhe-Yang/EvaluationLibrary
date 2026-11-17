within EvaluationLibrary.Frequency;
block DiscreteSpectrum "Single-sided discrete Fourier amplitude spectrum"
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

  final parameter Integer nBins=div(nSamples,2)+1 "Number of finite Fourier bins";
  output Modelica.Units.SI.Frequency frequency[nBins] "Selected frequency in hertz, not above Nyquist";
  output Real amplitude[nBins](each start=0,each fixed=true) "Fourier amplitude";
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
  discrete Real re(start=0,fixed=true) "Real Fourier coefficient";
  discrete Real im(start=0,fixed=true) "Imaginary Fourier coefficient";
  discrete Real phase(start=0,fixed=true) "Fourier phase";
initial equation
  assert(nSamples>=16 and nSamples<=1024,"Invalid spectral sample count.");

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

  for k in 1:nBins loop frequency[k]=(k-1)*frequencyResolution; end for;
  value=if available then max(amplitude) else 0;
  available=cache.ready and gate.complete and dataStatus==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and (true);
algorithm
  when cache.ready then
    for k in 1:nBins loop
      (re,im,amplitude[k],phase):=EvaluationLibrary.Utilities.Functions.Tone(cache.samples,samplePeriod,frequency[k],taper,removeMean);
    end for;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,61},{-64,-38},{65,-38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-48,-38},{-48,-4}}, color={0,0,127}, thickness=1.05, pattern=LinePattern.Solid),
        Ellipse(extent={{-50.9,-6.9},{-45.1,-1.1}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{-29,-38},{-29,43}}, color={0,0,127}, thickness=1.05, pattern=LinePattern.Solid),
        Ellipse(extent={{-31.9,40.1},{-26.1,45.9}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{-10,-38},{-10,3}}, color={0,0,127}, thickness=1.05, pattern=LinePattern.Solid),
        Ellipse(extent={{-12.9,0.1},{-7.1,5.9}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{9,-38},{9,24}}, color={0,0,127}, thickness=1.05, pattern=LinePattern.Solid),
        Ellipse(extent={{6.1,21.1},{11.9,26.9}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{28,-38},{28,-11}}, color={0,0,127}, thickness=1.05, pattern=LinePattern.Solid),
        Ellipse(extent={{25.1,-13.9},{30.9,-8.1}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{47,-38},{47,7}}, color={0,0,127}, thickness=1.05, pattern=LinePattern.Solid),
        Ellipse(extent={{44.1,4.1},{49.9,9.9}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Text(extent={{56,-35},{74,-16}}, textString="f", textColor={128,128,128}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="DFT", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Calculates <code>div(nSamples, 2) + 1</code> frequency bins once the record is filled. Bin spacing is <code>1/(nSamples*samplePeriod)</code>. DC and the Nyquist bin, when present, use one-sided scaling. <code>result.value</code> reports the largest bin amplitude.</p><p>Choose the observation interval and sample grid to provide exactly <code>nSamples</code> valid samples. Fewer samples give incomplete evidence; extra samples overflow the buffer. For <code>sampleStart=windowStart=0</code>, <code>samplePeriod=0.01</code> and <code>nSamples=200</code>, set <code>windowStop=2</code>. The result is available after the interval closes. Tapering and record length affect spectral leakage.</p></html>"));
end DiscreteSpectrum;
