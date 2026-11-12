within EvaluationLibrary.Examples;
model RepeatedRequestResponse "Pair requests with responses and separate timeout from censoring"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.BooleanExpression requests(y=(time>=1 and time<1.025) or (time>=2 and time<2.025) or (time>=3 and time<3.025) or (time>=3.95 and time<3.975)) annotation(Placement(transformation(origin={-165,58},extent={{-14,-14},{14,14}},rotation=0)));
  Modelica.Blocks.Sources.BooleanExpression responses(y=(time>=0.5 and time<0.525) or (time>=1.1 and time<1.125) or (time>=2.15 and time<2.175)) annotation(Placement(transformation(origin={-165,-58},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Response.RepeatedResponse paired(windowStop=4,deadline=0.2) annotation(Placement(transformation(origin={9,50},extent={{-19,-19},{19,19}},rotation=0)));
  Modelica.Blocks.Interfaces.IntegerOutput pairedCount annotation(Placement(transformation(origin={170,50},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Requirements.ResponseDeadline requirement(windowStop=4,deadline=0.2) annotation(Placement(transformation(origin={9,-60},extent={{-19,-19},{19,19}},rotation=0)));
  Modelica.Blocks.Interfaces.IntegerOutput requirementCount annotation(Placement(transformation(origin={170,-60},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(requests.y,paired.request) annotation(Line(points={{-149.6,58},{-4.3,58},{-4.3,74},{-4.3,69}},color={255,0,255}));
  connect(responses.y,paired.response) annotation(Line(points={{-149.6,-58},{-144.6,-58},{-144.6,54.43333},{-10,54.43333}},color={255,0,255}));
  connect(paired.matched,pairedCount) annotation(Line(points={{28,59.5},{170,59.5},{170,50}},color={255,127,0}));
  connect(requests.y,requirement.request) annotation(Line(points={{-149.6,58},{-73.95,58},{-73.95,-35},{-4.3,-35},{-4.3,-41}},color={255,0,255}));
  connect(responses.y,requirement.response) annotation(Line(points={{-149.6,-58},{-144.6,-58},{-144.6,-55.56667},{-10,-55.56667}},color={255,0,255}));
  connect(requirement.matched,requirementCount) annotation(Line(points={{28,-50.5},{170,-50.5},{170,-60}},color={255,127,0}));
  annotation(experiment(StartTime=0,StopTime=4.1,Interval=0.008199999999999999,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-240,-160},{240,160}},preserveAspectRatio=true)),
    Documentation(info="<html><p><b>Purpose</b> Pair requests with responses and separate timeout from censoring</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> Two matched, one timed out, one censored and one unmatched response. Qualified delays are 0.1 and 0.15 s.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> paired.matched, paired.timedOut, paired.censored, paired.unmatchedResponse, paired.delays[1:2], requirement.verdict.</p></html>"));
end RepeatedRequestResponse;
