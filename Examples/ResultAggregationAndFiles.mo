within EvaluationLibrary.Examples;
model ResultAggregationAndFiles "Route three structured results through a table, aggregation and one-shot writers"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression inputSignal(y=time) annotation(Placement(transformation(origin={-310,82},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Sources.BooleanExpression qualified(y=time<1 or time>=1.5) annotation(Placement(transformation(origin={-310,-130},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Requirements.UpperBound passLimit(windowStop=2,upper=3) annotation(Placement(transformation(origin={-210,130},extent={{-17,-17},{17,17}},rotation=0)));
  EvaluationLibrary.Requirements.UpperBound failLimit(windowStop=2,upper=1) annotation(Placement(transformation(origin={-210,0},extent={{-17,-17},{17,17}},rotation=0)));
  EvaluationLibrary.Requirements.UpperBound badData(windowStop=2,upper=3,useValidInput=true) annotation(Placement(transformation(origin={-210,-130},extent={{-17,-17},{17,17}},rotation=0)));
  EvaluationLibrary.Results.ResultTable table(n=3,windowStop=fill(2,3),metricId={"passing","violating","invalid"},requirementVersion=fill("1.0",3)) annotation(Placement(transformation(origin={-72,0},extent={{-19,-19},{19,19}},rotation=0)));
  EvaluationLibrary.Results.VerdictAggregator aggregate(n=3) annotation(Placement(transformation(origin={59,173},extent={{-17,-17},{17,17}},rotation=0)));
  EvaluationLibrary.Results.CSVWriter csv(n=3,windowStop=fill(2,3),metricId={"passing","violating","invalid"},requirementVersion=fill("1.0",3),runId="demo",resultSetId="csv") annotation(Placement(transformation(origin={198,79},extent={{-18,-18},{18,18}},rotation=0)));
  EvaluationLibrary.Results.TextWriter text(n=3,windowStop=fill(2,3),metricId={"passing","violating","invalid"},requirementVersion=fill("1.0",3),runId="demo",resultSetId="text") annotation(Placement(transformation(origin={198,-20},extent={{-18,-18},{18,18}},rotation=0)));
  EvaluationLibrary.Results.ConsoleWriter console(n=3,windowStop=fill(2,3),metricId={"passing","violating","invalid"},requirementVersion=fill("1.0",3),runId="demo",resultSetId="console") annotation(Placement(transformation(origin={198,-121},extent={{-18,-18},{18,18}},rotation=0)));
equation
  connect(inputSignal.y,passLimit.u) annotation(Line(points={{-294.6,82},{-289.6,82},{-289.6,133.96666},{-227,133.96666}},color={0,0,127}));
  connect(inputSignal.y,failLimit.u) annotation(Line(origin={0,0},
points={{-294.6,82},{-289.6,82},{-289.6,3.96667},{-227,3.96667}},
color={0,0,127}),__MWORKS(BlockSystem(NamedSignal)));
  connect(inputSignal.y,badData.u) annotation(Line(origin={0,0},
points={{-294.6,82},{-289.6,82},{-289.6,-126.033},{-227,-126.033}},
color={0,0,127}),__MWORKS(BlockSystem(NamedSignal)));
  connect(qualified.y,badData.valid) annotation(Line(points={{-294.6,-130},{-210,-130},{-210,-108},{-210,-113}},color={255,0,255}));
  connect(passLimit.result,table.u[1]) annotation(Line(points={{-193,141.9},{-142,141.9},{-142,0},{-91,0}},color={62,85,140}));
  connect(failLimit.result,table.u[2]) annotation(Line(points={{-193,11.9},{-142,11.9},{-142,0},{-91,0}},color={62,85,140}));
  connect(badData.result,table.u[3]) annotation(Line(points={{-193,-118.1},{-142,-118.1},{-142,0},{-91,0}},color={62,85,140}));
  connect(table.rows[1],aggregate.u[1]) annotation(Line(points={{-53,0},{-5.5,0},{-5.5,173},{42,173}},color={62,85,140}));
  connect(table.rows[1],csv.u[1]) annotation(Line(points={{-53,0},{63.5,0},{63.5,79},{180,79}},color={62,85,140}));
  connect(table.rows[1],text.u[1]) annotation(Line(points={{-53,0},{63.5,0},{63.5,-20},{180,-20}},color={62,85,140}));
  connect(table.rows[1],console.u[1]) annotation(Line(points={{-53,0},{63.5,0},{63.5,-121},{180,-121}},color={62,85,140}));
  connect(table.rows[2],aggregate.u[2]) annotation(Line(points={{-53,0},{-5.5,0},{-5.5,173},{42,173}},color={62,85,140}));
  connect(table.rows[2],csv.u[2]) annotation(Line(points={{-53,0},{63.5,0},{63.5,79},{180,79}},color={62,85,140}));
  connect(table.rows[2],text.u[2]) annotation(Line(points={{-53,0},{63.5,0},{63.5,-20},{180,-20}},color={62,85,140}));
  connect(table.rows[2],console.u[2]) annotation(Line(points={{-53,0},{63.5,0},{63.5,-121},{180,-121}},color={62,85,140}));
  connect(table.rows[3],aggregate.u[3]) annotation(Line(origin={0,0},
points={{-53,0},{-5.5,0},{-5.5,173},{42,173}},
color={62,85,140}),__MWORKS(BlockSystem(NamedSignal)));
  connect(table.rows[3],csv.u[3]) annotation(Line(points={{-53,0},{63.5,0},{63.5,79},{180,79}},color={62,85,140}));
  connect(table.rows[3],text.u[3]) annotation(Line(points={{-53,0},{63.5,0},{63.5,-20},{180,-20}},color={62,85,140}));
  connect(table.rows[3],console.u[3]) annotation(Line(points={{-53,0},{63.5,0},{63.5,-121},{180,-121}},color={62,85,140}));
  annotation(experiment(StartTime=0,StopTime=2.1,Interval=0.004200000000000001,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Route three structured results through a table, aggregation and one-shot writers</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> INVALID aggregate with an earlier child witness. Each file has three records. A repeated run in the same directory skips the existing files.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> aggregate.verdict, aggregate.firstViolationTime, all child results, csv.written and csv.skippedExisting.</p></html>"));
end ResultAggregationAndFiles;