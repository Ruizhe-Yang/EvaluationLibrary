within EvaluationLibrary.Examples;
model FirstOrderResponse "Measure rise and terminal settling of a first-order response"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Step command(startTime=0.5,height=1) annotation(Placement(transformation(origin={-183,2},extent={{-13,-13},{13,13}},rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder plant(T=0.5,initType=Modelica.Blocks.Types.Init.InitialState,y_start=0) annotation(Placement(transformation(origin={-92,2},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Response.RiseTime rise(windowStart=0.5,windowStop=4,stepTime=0.5) annotation(Placement(transformation(origin={38,56},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput riseSeconds annotation(Placement(transformation(origin={170,56},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Response.SettlingTime settling(windowStart=0.5,windowStop=4,stepTime=0.5) annotation(Placement(transformation(origin={38,-53},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput settlingSeconds annotation(Placement(transformation(origin={170,-53},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(command.y,plant.u) annotation(Line(points={{-168.7,2},{-108.8,2}},color={0,0,127}));
  connect(plant.y,rise.u) annotation(Line(points={{-76.6,2},{-71.6,2},{-71.6,59.96666},{21,59.96666}},color={0,0,127}));
  connect(rise.value,riseSeconds) annotation(Line(points={{55,52.03334},{170,52.03334},{170,56}},color={0,0,127}));
  connect(plant.y,settling.u) annotation(Line(points={{-76.6,2},{-27.8,2},{-27.8,-49.03334},{21,-49.03334}},color={0,0,127}));
  connect(settling.value,settlingSeconds) annotation(Line(points={{55,-56.96666},{170,-56.96666},{170,-53}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=4.1,Interval=0.008199999999999999,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-240,-160},{240,160}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Measure rise and terminal settling of a first-order response</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> Expected rise time 0.5 ln(9) and final band entry 0.5 ln(50) after the step. Settling is confirmed at window closure.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> rise.value, settling.value, settling.settled and both timestamps.</p></html>"));
end FirstOrderResponse;
