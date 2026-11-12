within EvaluationLibrary.Examples;
model ConsistencyAndLabels "Separate label statistics from simultaneous numeric consistency"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.BooleanExpression groundTruth(y=time>=2) annotation(Placement(transformation(origin={-268,168},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Sources.BooleanExpression decision(y=time>=1 and time<3) annotation(Placement(transformation(origin={-268,96},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Comparison.LabelPerformance labels(windowStop=4,sampleStart=0.5,samplePeriod=1) annotation(Placement(transformation(origin={-16,127},extent={{-20,-20},{20,20}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput accuracy annotation(Placement(transformation(origin={225,127},extent={{-7,-7},{7,7}},rotation=0)));
  Modelica.Blocks.Sources.RealExpression channel1(y=1) annotation(Placement(transformation(origin={-268,31},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Sources.RealExpression channel2(y=2) annotation(Placement(transformation(origin={-268,-51},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Sources.RealExpression channel3(y=3) annotation(Placement(transformation(origin={-268,-133},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Comparison.ChannelConsistency range(windowStop=4) annotation(Placement(transformation(origin={-16,-56},extent={{-20,-20},{20,20}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput spread annotation(Placement(transformation(origin={225,-56},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(groundTruth.y,labels.truth) annotation(Line(points={{-252.6,168},{-144.3,168},{-144.3,134},{-36,134}},color={255,0,255}));
  connect(decision.y,labels.decision) annotation(Line(points={{-252.6,96},{-144.3,96},{-144.3,127},{-36,127}},color={255,0,255}));
  connect(labels.value,accuracy) annotation(Line(points={{4,127},{225,127}},color={0,0,127}));
  connect(channel1.y,range.u[1]) annotation(Line(points={{-252.6,31},{-144.3,31},{-144.3,-47.6},{-36,-47.6}},color={0,0,127}));
  connect(channel2.y,range.u[2]) annotation(Line(points={{-252.6,-51},{-144.3,-51},{-144.3,-47.6},{-36,-47.6}},color={0,0,127}));
  connect(channel3.y,range.u[3]) annotation(Line(points={{-252.6,-133},{-144.3,-133},{-144.3,-47.6},{-36,-47.6}},color={0,0,127}));
  connect(range.value,spread) annotation(Line(points={{4,-60.66666},{225,-60.66666},{225,-56}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=4.1,Interval=0.008199999999999999,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Separate label statistics from simultaneous numeric consistency</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> Each confusion count is one and accuracy and recall are 0.5. The consistency range is 2 during observation.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> labels.TP, TN, FP, FN, accuracy, recall and denominator flags. range.value while its window is open.</p></html>"));
end ConsistencyAndLabels;
