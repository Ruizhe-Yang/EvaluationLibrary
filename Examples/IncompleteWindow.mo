within EvaluationLibrary.Examples;
model IncompleteWindow "Close an under-observed window at normal termination"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression inputSignal(y=time) annotation(Placement(transformation(origin={-167,0},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Requirements.UpperBound noWitness(upper=3,windowStop=2) annotation(Placement(transformation(origin={-11,56},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput noWitnessValue annotation(Placement(transformation(origin={158,56},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Requirements.UpperBound withWitness(upper=0.5,windowStop=2) annotation(Placement(transformation(origin={-11,-48},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput withWitnessValue annotation(Placement(transformation(origin={158,-48},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(inputSignal.y,noWitness.u) annotation(Line(points={{-151.6,0},{-146.6,0},{-146.6,59.96666},{-28,59.96666}},color={0,0,127}));
  connect(noWitness.value,noWitnessValue) annotation(Line(points={{6,56},{158,56}},color={0,0,127}));
  connect(inputSignal.y,withWitness.u) annotation(Line(points={{-151.6,0},{-89.8,0},{-89.8,-44.03334},{-28,-44.03334}},color={0,0,127}));
  connect(withWitness.value,withWitnessValue) annotation(Line(points={{6,-48},{158,-48}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=1,Interval=0.002,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-240,-160},{240,160}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Close an under-observed window at normal termination</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> Both windows end early. The first is INCOMPLETE and UNDECIDED. The second is INCOMPLETE and VIOLATED.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> noWitness and withWitness dataStatus, verdict and firstViolationTime.</p></html>"));
end IncompleteWindow;
