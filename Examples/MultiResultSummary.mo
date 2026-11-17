within EvaluationLibrary.Examples;
model MultiResultSummary "Combine required verdicts while retaining individual results"
 Modelica.Blocks.Sources.Constant safe(k=0.5) "Safe" annotation(Placement(transformation(origin={-90,50},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.Constant unsafe(k=1.5) "Condition whose occupied duration is measured" annotation(Placement(transformation(origin={-90,-30},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Statistics.SignalAssessment assessment(n=3,metricId={"within_1","over_bound","within_2"},lower=zeros(3),upper=fill(1,3),windowStop=1) "Assessment" annotation(Placement(transformation(origin={-20,20},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Requirements.WithinBand notApplicable(applicable=false,metricId="optional_not_applicable",windowStop=1) "Not applicable" annotation(Placement(transformation(origin={-20,-50},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.VerdictAggregator aggregate(n=4,required={true,true,true,false},logOnComplete=false) "Aggregate" annotation(Placement(transformation(origin={40,60},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.ConsoleWriter report(n=4,required={true,true,true,false},runId="summary") "Report" annotation(Placement(transformation(origin={90,-10},extent={{-10,-10},{10,10}})));
equation
 connect(safe.y,assessment.u[1]) annotation(Line(points={{-80.0, 50.0}, {-40, 50}, {-40, 0}, {-30.0, 20.0}},color={0,0,127}));
 connect(unsafe.y,assessment.u[2]) annotation(Line(points={{-80.0, -30.0}, {-40, -30}, {-40, 0}, {-30.0, 20.0}},color={0,0,127}));
 connect(safe.y,assessment.u[3]) annotation(Line(points={{-80.0, 50.0}, {-40, 50}, {-40, 0}, {-30.0, 20.0}},color={0,0,127}));
 connect(safe.y,notApplicable.u) annotation(Line(points={{-80.0, 50.0}, {-55, 50}, {-55, -50}, {-30.0, -47.666667}},color={0,0,127}));
 connect(assessment.y[1],aggregate.u[1]) annotation(Line(points={{-10.0, 20.0}, {20, 20}, {20, 60}, {30.0, 60.0}},color={0,0,127}));
 connect(assessment.y[2],aggregate.u[2]) annotation(Line(points={{-10.0, 20.0}, {20, 20}, {20, 60}, {30.0, 60.0}},color={0,0,127}));
 connect(assessment.y[3],aggregate.u[3]) annotation(Line(points={{-10.0, 20.0}, {20, 20}, {20, 60}, {30.0, 60.0}},color={0,0,127}));
 connect(assessment.y[1],report.u[1]) annotation(Line(points={{-10.0, 20.0}, {60, 20}, {60, -10}, {80.0, -10.0}},color={0,0,127}));
 connect(assessment.y[2],report.u[2]) annotation(Line(points={{-10.0, 20.0}, {60, 20}, {60, -10}, {80.0, -10.0}},color={0,0,127}));
 connect(assessment.y[3],report.u[3]) annotation(Line(points={{-10.0, 20.0}, {60, 20}, {60, -10}, {80.0, -10.0}},color={0,0,127}));
 connect(notApplicable.result,aggregate.u[4]) annotation(Line(points={{-10.0, -43.0}, {20, -50}, {20, 60}, {30.0, 60.0}},color={0,0,127}));
 connect(notApplicable.result,report.u[4]) annotation(Line(points={{-10.0, -43.0}, {60, -50}, {60, -10}, {80.0, -10.0}},color={0,0,127}));
 annotation(experiment(StartTime=0,StopTime=1.2,Interval=0.01,Tolerance=1e-7),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-120,-100},{120,100}})),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-90,-90},{90,90}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Polygon(points={{-62,43},{-62,-43},{-5,0},{-62,43}}, lineColor={75,138,73}, fillColor={75,138,73}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Rectangle(extent={{11.68,11.52},{26.56,21.12}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{26.56,16.32},{36.64,16.32}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{11.68,-4.8},{26.56,4.8}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{26.56,0},{36.64,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{11.68,-21.12},{26.56,-11.52}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{26.56,-16.32},{36.64,-16.32}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{36.64,16.32},{36.64,-16.32}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{36.64,0},{46.72,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Rectangle(extent={{47.2,-9.12},{68.8,10.08}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{49.6,8.64},{66.4,-7.2}}, textString="&", textColor={0,0,127}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Documentation(info="<html><p>Evaluates three channels against an inclusive [0,1] interval and adds one optional, inapplicable requirement. The channel verdicts are satisfied, violated and satisfied; the required conjunction is violated. Inspect <code>aggregate</code> and the console output to compare the combined verdict with the four individual results.</p></html>"));
end MultiResultSummary;
