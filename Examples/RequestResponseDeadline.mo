within EvaluationLibrary.Examples;
model RequestResponseDeadline "Compare timely, late, missing and undemanded responses"
 Modelica.Blocks.Sources.BooleanStep request(startTime=0.2) "Request" annotation(Placement(transformation(origin={-90,70},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.BooleanStep fast(startTime=0.3) "Fast" annotation(Placement(transformation(origin={-90,30},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.BooleanStep late(startTime=0.6) "Late" annotation(Placement(transformation(origin={-90,-20},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.BooleanConstant absent(k=false) "Absent" annotation(Placement(transformation(origin={-90,-70},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Response.EventAssessment assessment(n=5,metricId={"action","same_instant","missing_action","not_demanded","late_action"},deadline=fill(0.2,5),windowStop=1) "Assessment" annotation(Placement(transformation(origin={0,0},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.ConsoleWriter report(n=5,runId="deadline") "Report" annotation(Placement(transformation(origin={90,0},extent={{-10,-10},{10,10}})));
equation
 connect(request.y,assessment.request[1]) annotation(Line(points={{-80.0, 70.0}, {-40, 70}, {-40, 5}, {-10.0, 5.0}},color={0,0,127}));
 connect(request.y,assessment.request[2]) annotation(Line(points={{-80.0, 70.0}, {-40, 70}, {-40, 5}, {-10.0, 5.0}},color={0,0,127}));
 connect(request.y,assessment.request[3]) annotation(Line(points={{-80.0, 70.0}, {-40, 70}, {-40, 5}, {-10.0, 5.0}},color={0,0,127}));
 connect(request.y,assessment.request[5]) annotation(Line(points={{-80.0, 70.0}, {-35, 70}, {-35, 5}, {-10.0, 5.0}},color={0,0,127}));
 connect(absent.y,assessment.request[4]) annotation(Line(points={{-80.0, -70.0}, {-45, -70}, {-45, 5}, {-10.0, 5.0}},color={0,0,127}));
 connect(fast.y,assessment.response[1]) annotation(Line(points={{-80.0, 30.0}, {-30, 30}, {-30, -5}, {-10.0, -5.0}},color={0,0,127}));
 connect(request.y,assessment.response[2]) annotation(Line(points={{-80.0, 70.0}, {-25, 70}, {-25, -5}, {-10.0, -5.0}},color={0,0,127}));
 connect(absent.y,assessment.response[3]) annotation(Line(points={{-80.0, -70.0}, {-35, -70}, {-35, -5}, {-10.0, -5.0}},color={0,0,127}));
 connect(absent.y,assessment.response[4]) annotation(Line(points={{-80.0, -70.0}, {-35, -70}, {-35, -5}, {-10.0, -5.0}},color={0,0,127}));
 connect(late.y,assessment.response[5]) annotation(Line(points={{-80.0, -20.0}, {-25, -20}, {-25, -5}, {-10.0, -5.0}},color={0,0,127}));
 connect(assessment.y,report.u) annotation(Line(points={{10.0, 0.0}, {80.0, 0.0}},color={0,0,127}));
 annotation(experiment(StartTime=0,StopTime=1.2,Interval=0.01,Tolerance=1e-7),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-120,-100},{120,100}})),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-90,-90},{90,90}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Polygon(points={{-62,43},{-62,-43},{-5,0},{-62,43}}, lineColor={75,138,73}, fillColor={75,138,73}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{11.2,11.52},{24.64,11.52},{24.64,25.44},{35.2,25.44},{35.2,11.52},{68.8,11.52}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{11.2,-13.92},{43.84,-13.92},{43.84,0},{54.4,0},{54.4,-13.92},{68.8,-13.92}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{24.64,8.64},{24.64,-20.64}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dot),
        Line(points={{43.84,8.16},{43.84,-20.64}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dot),
        Line(points={{24.64,-19.2},{43.84,-19.2}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{61.12,27.84},{61.12,-20.64}}, color={191,0,0}, thickness=0.65, pattern=LinePattern.Dash),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Documentation(info="<html><p>Applies a 0.2 s deadline to five channels. Responses delayed by 0.1 s and 0 s satisfy the requirement; missing and late responses violate it. The channel with no request is not applicable. Inspect <code>assessment.timedOut</code> and <code>assessment.y</code>, and compare the five console results.</p></html>"));
end RequestResponseDeadline;
