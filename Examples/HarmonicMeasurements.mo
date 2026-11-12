within EvaluationLibrary.Examples;
model HarmonicMeasurements "Resolve a finite window containing two coherent sinusoidal tones"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression wave(y=sin(2*Modelica.Constants.pi*5*time)+0.1*sin(2*Modelica.Constants.pi*10*time)) annotation(Placement(transformation(origin={-273,0},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Frequency.DiscreteSpectrum spectrum(windowStop=2,nSamples=200,samplePeriod=0.01) annotation(Placement(transformation(origin={-12,126},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput spectrumValue annotation(Placement(transformation(origin={222,126},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Frequency.SingleFrequency fundamental(windowStop=2,nSamples=200,samplePeriod=0.01,frequency=5) annotation(Placement(transformation(origin={-12,0},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput fundamentalValue annotation(Placement(transformation(origin={222,0},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Frequency.HarmonicDistortion distortion(windowStop=2,nSamples=200,samplePeriod=0.01,fundamental=5,harmonics=3) annotation(Placement(transformation(origin={-12,-128},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput distortionValue annotation(Placement(transformation(origin={222,-128},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(wave.y,spectrum.u) annotation(Line(points={{-257.6,0},{-252.6,0},{-252.6,129.96666},{-29,129.96666}},color={0,0,127}));
  connect(spectrum.value,spectrumValue) annotation(Line(points={{5,126},{222,126}},color={0,0,127}));
  connect(wave.y,fundamental.u) annotation(Line(points={{-257.6,0},{-252.6,0},{-252.6,3.96666},{-29,3.96666}},color={0,0,127}));
  connect(fundamental.value,fundamentalValue) annotation(Line(points={{5,0},{222,0}},color={0,0,127}));
  connect(wave.y,distortion.u) annotation(Line(points={{-257.6,0},{-252.6,0},{-252.6,-124.03334},{-29,-124.03334}},color={0,0,127}));
  connect(distortion.value,distortionValue) annotation(Line(points={{5,-128},{222,-128}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=2.1,Interval=0.004200000000000001,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Resolve a finite window containing two coherent sinusoidal tones</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> Fundamental 1, second harmonic 0.1, THD 0.1, frequency spacing 0.5 Hz and complete coverage.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> spectrum.amplitude[11], spectrum.amplitude[21], frequencyResolution, fundamental.value and distortion.thd.</p></html>"));
end HarmonicMeasurements;
