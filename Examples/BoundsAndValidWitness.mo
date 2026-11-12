within EvaluationLibrary.Examples;
model BoundsAndValidWitness "Retain a valid witness independently of subsequent bad data"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression inputSignal(y=time) annotation(Placement(transformation(origin={-255,15},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Sources.BooleanExpression qualified(y=time<1.6 or time>=1.7) annotation(Placement(transformation(origin={-255,-93},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Requirements.UpperBound alwaysValid(upper=1.2,windowStop=2) annotation(Placement(transformation(origin={-22,129},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput alwaysValidValue annotation(Placement(transformation(origin={222,129},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Requirements.UpperBound withGap(upper=1.2,useValidInput=true,windowStop=2) annotation(Placement(transformation(origin={-22,9},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput withGapValue annotation(Placement(transformation(origin={222,9},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Requirements.UpperBound passing(upper=3,windowStop=2) annotation(Placement(transformation(origin={-22,-116},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput passingValue annotation(Placement(transformation(origin={222,-116},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(inputSignal.y,alwaysValid.u) annotation(Line(points={{-239.6,15},{-234.6,15},{-234.6,132.96666},{-39,132.96666}},color={0,0,127}));
  connect(alwaysValid.value,alwaysValidValue) annotation(Line(points={{-5,129},{222,129}},color={0,0,127}));
  connect(inputSignal.y,withGap.u) annotation(Line(points={{-239.6,15},{-139.3,15},{-139.3,12.96666},{-39,12.96666}},color={0,0,127}));
  connect(withGap.value,withGapValue) annotation(Line(points={{-5,9},{222,9}},color={0,0,127}));
  connect(inputSignal.y,passing.u) annotation(Line(points={{-239.6,15},{-234.6,15},{-234.6,-112.03334},{-39,-112.03334}},color={0,0,127}));
  connect(passing.value,passingValue) annotation(Line(points={{-5,-116},{222,-116}},color={0,0,127}));
  connect(qualified.y,withGap.valid) annotation(Line(points={{-239.6,-93},{-22,-93},{-22,31},{-22,26}},color={255,0,255}));
  annotation(experiment(StartTime=0,StopTime=2.1,Interval=0.004200000000000001,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Retain a valid witness independently of subsequent bad data</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> The first two branches record the witness at 1.2 s. The gapped branch becomes INVALID and retains its witness. The third branch is SATISFIED.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> Each result dataStatus and verdict, everViolated and firstViolationTime.</p></html>"));
end BoundsAndValidWitness;
