within EvaluationLibrary.Examples;
model PairedPerformance "Compare integrals for two declared comparable trajectories"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression baselineSignal(y=time) annotation(Placement(transformation(origin={-274,105},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Sources.RealExpression candidateSignal(y=0.8*time) annotation(Placement(transformation(origin={-274,-81},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Statistics.Integral baseline(windowStop=2) annotation(Placement(transformation(origin={-139,105},extent={{-17,-17},{17,17}},rotation=0)));
  EvaluationLibrary.Statistics.Integral candidate(windowStop=2) annotation(Placement(transformation(origin={-139,-81},extent={{-17,-17},{17,17}},rotation=0)));
  EvaluationLibrary.Comparison.Improvement improvement(comparisonId="paired-integral",referenceUnit="s",referenceStop=2) annotation(Placement(transformation(origin={46,12},extent={{-21,-21},{21,21}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput absoluteChange annotation(Placement(transformation(origin={253,61},extent={{-7,-7},{7,7}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput relativeChange annotation(Placement(transformation(origin={253,-34},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(baselineSignal.y,baseline.u) annotation(Line(points={{-258.6,105},{-253.6,105},{-253.6,108.96666},{-156,108.96666}},color={0,0,127}));
  connect(candidateSignal.y,candidate.u) annotation(Line(points={{-258.6,-81},{-253.6,-81},{-253.6,-77.03334},{-156,-77.03334}},color={0,0,127}));
  connect(baseline.result,improvement.reference) annotation(Line(points={{-122,116.9},{-48.5,116.9},{-48.5,26.7},{25,26.7}},color={62,85,140}));
  connect(candidate.result,improvement.candidate) annotation(Line(points={{-122,-69.1},{-48.5,-69.1},{-48.5,-2.7},{25,-2.7}},color={62,85,140}));
  connect(improvement.absoluteImprovement,absoluteChange) annotation(Line(points={{67,26.7},{253,26.7},{253,61}},color={0,0,127}));
  connect(improvement.relativeImprovement,relativeChange) annotation(Line(points={{67,12},{253,12},{253,-34}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=2.1,Interval=0.004200000000000001,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Compare integrals for two declared comparable trajectories</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> Complete integrals are 2 and 1.6. The absolute improvement is 0.4 and the relative improvement is 0.2.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> baseline.value, candidate.value, improvement.absoluteImprovement and improvement.relativeImprovement.</p></html>"));
end PairedPerformance;
