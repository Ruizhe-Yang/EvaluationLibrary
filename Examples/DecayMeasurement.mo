within EvaluationLibrary.Examples;
model DecayMeasurement "Measure the decay between positive peaks of a known oscillation"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression decayingWave(y=exp(-time)*sin(2*Modelica.Constants.pi*5*time)) annotation(Placement(transformation(origin={-152,0},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Frequency.DecayRatio decay(windowStop=3,samplePeriod=0.001) annotation(Placement(transformation(origin={-10,0},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput peakRatio annotation(Placement(transformation(origin={157,0},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(decayingWave.y,decay.u) annotation(Line(points={{-136.6,0},{-81.8,0},{-81.8,3.96666},{-27,3.96666}},color={0,0,127}));
  connect(decay.value,peakRatio) annotation(Line(points={{7,0},{157,0}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=3.1,Interval=0.001,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-240,-160},{240,160}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Measure the decay between positive peaks of a known oscillation</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> The ratio is near exp(-0.2) and the logarithmic decrement is near 0.2.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> decay.peakCount, decay.ratio and decay.logarithmicDecrement.</p></html>"));
end DecayMeasurement;
