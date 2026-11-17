within EvaluationLibrary.Examples;
model RecoveryAndDwell "Compare successful and unsuccessful recovery"
 Modelica.Blocks.Sources.BooleanPulse danger(period=10,width=1,startTime=0.1) "Observed danger condition" annotation(Placement(transformation(origin={-90,60},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.BooleanConstant noFeedback(k=false) "No feedback" annotation(Placement(transformation(origin={-90,20},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.Ramp recovering(offset=1,height=-1,duration=1) "Recovering" annotation(Placement(transformation(origin={-90,-20},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.Constant unrecovered(k=1) "Unrecovered" annotation(Placement(transformation(origin={-90,-60},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Response.EventAssessment assessment(n=2,metricId={"recovery","failed_recovery"},mode=fill(EvaluationLibrary.Utilities.Types.EventMode.Recovery,2),useRecoverySignal=true,recoveryTolerance=fill(0.3,2),recoveryDwell=fill(0.2,2),windowStop=1.5) "Assessment" annotation(Placement(transformation(origin={0,0},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.ConsoleWriter report(n=2,runId="recovery") "Report" annotation(Placement(transformation(origin={90,0},extent={{-10,-10},{10,10}})));
equation
 connect(danger.y,assessment.request[1]) annotation(Line(points={{-80.0, 60.0}, {-50, 60}, {-50, 5}, {-10.0, 5.0}},color={0,0,127}));
 connect(danger.y,assessment.request[2]) annotation(Line(points={{-80.0, 60.0}, {-45, 60}, {-45, 5}, {-10.0, 5.0}},color={0,0,127}));
 connect(noFeedback.y,assessment.response[1]) annotation(Line(origin={0,0},
points={{-79,20},{-40,20},{-40,-5},{-10,-5}},
color={0,0,127}),__MWORKS(BlockSystem(NamedSignal)));
 connect(noFeedback.y,assessment.response[2]) annotation(Line(points={{-80.0, 20.0}, {-35, 20}, {-35, -5}, {-10.0, -5.0}},color={0,0,127}));
 connect(recovering.y,assessment.recoverySignal[1]) annotation(Line(points={{-80.0, -20.0}, {-30, -20}, {-30, 0}, {-10.0, 0.0}},color={0,0,127}));
 connect(unrecovered.y,assessment.recoverySignal[2]) annotation(Line(points={{-80.0, -60.0}, {-25, -60}, {-25, 0}, {-10.0, 0.0}},color={0,0,127}));
 connect(assessment.y,report.u) annotation(Line(points={{10.0, 0.0}, {80.0, 0.0}},color={0,0,127}));
 annotation(experiment(StartTime=0,StopTime=1.7,Interval=0.01,Tolerance=1e-7),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-120,-100},{120,100}})),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-90,-90},{90,90}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Polygon(points={{-62,43},{-62,-43},{-5,0},{-62,43}}, lineColor={75,138,73}, fillColor={75,138,73}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Rectangle(extent={{13.6,-11.52},{67.84,4.8}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{10.72,25.92},{23.2,19.2},{35.68,9.6},{46.72,4.8},{55.36,-3.36},{67.84,-3.36}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{46.72,6.72},{46.72,-20.16}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{46.72,-17.28},{67.84,-17.28}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Documentation(info="<html><p>Observes a danger event at 0.1 s. The decreasing signal enters the inclusive 0.3 recovery band at 0.7 s and completes its 0.2 s dwell at 0.9 s, giving a recovery delay of 0.8 s. The constant signal never enters the band. Inspect <code>assessment.recovered</code>, <code>assessment.y</code> and the console outcomes.</p></html>"));
end RecoveryAndDwell;