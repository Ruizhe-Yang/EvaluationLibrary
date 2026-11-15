within EvaluationLibrary.Examples;
model DiagnosticLabelPerformance "Measure diagnostic labels against independent truth"
 Modelica.Blocks.Sources.BooleanPulse truth(period=1,width=50,startTime=0) "Truth" annotation(Placement(transformation(origin={-80,40},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.BooleanPulse decision(period=1,width=50,startTime=0.25) "Decision" annotation(Placement(transformation(origin={-80,-40},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Comparison.LabelPerformance diagnostic(metricId="diagnostic_accuracy",windowStop=2,samplePeriod=0.25) "Diagnostic" annotation(Placement(transformation(origin={0,0},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.ConsoleWriter report(n=8,runId="diagnostic") "Report" annotation(Placement(transformation(origin={80,0},extent={{-10,-10},{10,10}})));
equation
 connect(truth.y,diagnostic.truth) annotation(Line(points={{-70.0, 40.0}, {-30, 40}, {-30, 3.5}, {-10.0, 3.5}},color={0,0,127}));
 connect(decision.y,diagnostic.decision) annotation(Line(points={{-70.0, -40.0}, {-30, -40}, {-30, 0}, {-10.0, 0.0}},color={0,0,127}));
 connect(diagnostic.y,report.u) annotation(Line(points={{10.0, -3.0}, {40, 7}, {40, 0}, {70.0, 0.0}},color={0,0,127}));
 annotation(experiment(StartTime=0,StopTime=2.2,Interval=0.01,Tolerance=1e-7),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-120,-100},{120,100}})),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-90,-90},{90,90}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Polygon(points={{-62,43},{-62,-43},{-5,0},{-62,43}}, lineColor={75,138,73}, fillColor={75,138,73}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Rectangle(extent={{16,-20.16},{64,24}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{16,1.92},{64,1.92}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{40,-20.16},{40,24}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Text(extent={{17.92,21.6},{37.6,4.8}}, textString="TP", textColor={0,0,127}, fontSize=0),
        Text(extent={{42.4,21.6},{62.08,4.8}}, textString="FN", textColor={64,64,64}, fontSize=0),
        Text(extent={{17.92,-0.48},{37.6,-17.28}}, textString="FP", textColor={64,64,64}, fontSize=0),
        Text(extent={{42.4,-0.48},{62.08,-17.28}}, textString="TN", textColor={0,0,127}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Documentation(info="<html><p>Measure diagnostic labels against independent truth. All excitation, observation and result reporting are internal. No external input ports or result-field equations are required.</p><p>On the declared eight-sample grid, truth and delayed labels produce TP=2, TN=2, FP=2 and FN=2. Accuracy, precision, recall and specificity are 0.5 with explicit denominator availability. No diagnostic controller or fault injection is present.</p><p>The console lists each metric and its data qualification separately from its verdict. Statistics without a requirement remain UNDECIDED, including when numerical evidence is COMPLETE. See verification/example_verification.md for measured values and the actual compiler scope.</p></html>"));
end DiagnosticLabelPerformance;
