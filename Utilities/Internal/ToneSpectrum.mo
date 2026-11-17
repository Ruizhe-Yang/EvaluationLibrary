within EvaluationLibrary.Utilities.Internal;
block ToneSpectrum "Calculate a finite one-sided amplitude and phase spectrum"
  parameter Integer nSamples(min=4,max=1024) = 128 "Uniform sample count";
  parameter Integer nBins(min=1,max=div(nSamples,2)) = min(32,div(nSamples,2)) "Highest retained nonnegative bin";
  parameter Modelica.Units.SI.Time startTime = 0 "First sample, s";
  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.01 "Tick period, s";
  parameter EvaluationLibrary.Utilities.Types.SpectralWindow window = EvaluationLibrary.Utilities.Types.SpectralWindow.Rectangular "Spectral weighting applied to the sample record";
  parameter Real amplitudeFloor(min=0) = 1e-9 "Smallest reportable amplitude, input unit";
  parameter Boolean applicable = true "Whether this record applies";
  final parameter Modelica.Units.SI.Frequency resolution = 1/(nSamples*samplePeriod) "Bin width, Hz";
  Modelica.Blocks.Interfaces.RealInput u "Observed real signal" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));
  Modelica.Blocks.Interfaces.BooleanInput valid "Clocked data validity" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  output Real amplitude[nBins+1] "One-sided peak amplitude, including DC";
  output Modelica.Units.SI.Angle phase[nBins+1] "Phase of cosine reference at startTime";
  output Modelica.Units.SI.Frequency frequency[nBins+1] = {(i-1)*resolution for i in 1:nBins+1} "Selected frequency in hertz, not above Nyquist";
  Modelica.Blocks.Interfaces.IntegerOutput dominantBin "Strongest non-DC bin, or zero" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.RealOutput dominantFrequency(unit="Hz") "Dominant frequency" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Evidence qualification independent of requirement verdict";
  output Integer receivedSamples "All scheduled captured ticks";
  output Integer validSamples "Accepted finite valid ticks";
  output Modelica.Units.SI.Time observedDuration "Observed capture duration";
  output Modelica.Units.SI.Time validDuration "Valid capture duration";
protected
  EvaluationLibrary.Response.SampleHistory history(n=nSamples,startTime=startTime,
    samplePeriod=samplePeriod,applicable=applicable) "Uniformly sampled observation history";
  Real bins[nBins+1,2] "Discrete spectrum of the completed history";
  Real strongest "Largest non-DC amplitude found so far";
initial equation
  assert(nSamples>=4 and nSamples<=1024 and nBins>=1 and nBins<=div(nSamples,2) and samplePeriod>0 and amplitudeFloor>=0,
    "Invalid DFT grid.");
equation
  receivedSamples=history.result.receivedSamples;
  validSamples=history.result.validSamples;
  observedDuration=history.result.observedDuration;
  validDuration=history.result.validDuration;
  history.u = u;
  history.valid = valid;
  dataState = history.dataState;
  bins = if dataState==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Internal.oneSidedDFT(history.samples,nBins,window,amplitudeFloor) else zeros(nBins+1,2);
  amplitude = bins[:,1];
  phase = bins[:,2];
  dominantFrequency = dominantBin*resolution;
algorithm
  strongest := amplitudeFloor;
  dominantBin := 0;
  for k in 1:nBins loop
    if amplitude[k+1] > strongest then
      strongest := amplitude[k+1];
      dominantBin := k;
    end if;
  end for;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-63,62},{-63,-40},{66,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-49,-40},{-49,-26}}, color={0,0,127}, thickness=1.6, pattern=LinePattern.Solid),
        Line(points={{-23,-40},{-23,-4}}, color={0,0,127}, thickness=1.6, pattern=LinePattern.Solid),
        Line(points={{3,-40},{3,43}}, color={0,0,127}, thickness=1.6, pattern=LinePattern.Solid),
        Line(points={{29,-40},{29,-15}}, color={0,0,127}, thickness=1.6, pattern=LinePattern.Solid),
        Line(points={{55,-40},{55,-29}}, color={0,0,127}, thickness=1.6, pattern=LinePattern.Solid),
        Ellipse(extent={{-5,35},{11,51}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.7),
        Line(points={{3,57},{3,72}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.None}),
        Text(extent={{22,75},{70,50}}, textString="A(f)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-47,-56},{47,-79}}, textString="peak", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Collect <code>nSamples</code> on the grid defined by <code>startTime</code> and <code>samplePeriod</code>, using <code>Response.SampleHistory</code>. Once the history is complete, calculate bins from DC to <code>nBins</code> with <code>oneSidedDFT</code>.</p><p>Amplitudes are peak values and phases refer to a cosine at <code>startTime</code>. The dominant bin excludes DC and must exceed <code>amplitudeFloor</code>; otherwise it is zero. Inspect <code>dataState</code> before interpreting the arrays, which contain zero placeholders before complete evidence is available.</p></html>"));
end ToneSpectrum;
