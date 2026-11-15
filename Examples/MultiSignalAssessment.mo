within EvaluationLibrary.Examples;
model MultiSignalAssessment "Assess angle, position and current with one shared window"
 Modelica.Blocks.Sources.Sine angle(amplitude=0.1,f=1) "Angle" annotation(Placement(transformation(origin={-80,60},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.Ramp position(height=2,duration=1) "Position" annotation(Placement(transformation(origin={-80,0},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.Constant current(k=0.3) "Current" annotation(Placement(transformation(origin={-80,-60},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Statistics.SignalAssessment assessment(n=3,metricId={"angle","position","current"},unitName={"rad","m","A"},interpretation=fill(EvaluationLibrary.Utilities.Types.InputInterpretation.AbsoluteValue,3),lower=zeros(3),upper={0.2,1,0.5},windowStop=2,samplePeriod=0.01) "Assessment" annotation(Placement(transformation(origin={0,0},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.ConsoleWriter report(n=3,runId="multi_signal") "Report" annotation(Placement(transformation(origin={80,0},extent={{-10,-10},{10,10}})));
equation
 connect(angle.y,assessment.u[1]) annotation(Line(points={{-70.0, 60.0}, {-40, 60}, {-40, 0}, {-10.0, 0.0}},color={0,0,127}));
 connect(position.y,assessment.u[2]) annotation(Line(points={{-70.0, 0.0}, {-40, 0}, {-40, 0}, {-10.0, 0.0}},color={0,0,127}));
 connect(current.y,assessment.u[3]) annotation(Line(points={{-70.0, -60.0}, {-40, -60}, {-40, 0}, {-10.0, 0.0}},color={0,0,127}));
 connect(assessment.y,report.u) annotation(Line(points={{10.0, 0.0}, {70.0, 0.0}},color={0,0,127}));
 annotation(experiment(StartTime=0,StopTime=2.2,Interval=0.01,Tolerance=1e-7),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-120,-100},{120,100}})),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-90,-90},{90,90}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Polygon(points={{-62,43},{-62,-43},{-5,0},{-62,43}}, lineColor={75,138,73}, fillColor={75,138,73}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{10.72,19.2},{22.72,24.96},{34.24,16.8},{48.64,22.56},{64.48,19.2}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{10.72,1.92},{23.2,1.92},{49.6,11.52},{64.48,11.52}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{10.72,-14.4},{64.48,-14.4}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{68.32,27.84},{68.32,-21.12}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Documentation(info="<html><p>Assess angle, position and current with one shared window. All excitation, observation and result reporting are internal. No external input ports or result-field equations are required.</p><p>The window is [0,2) s. Sampled absolute peaks are 0.1 rad, 2 m and 0.3 A. Position violates the inclusive 1 m bound at 0.5 s, while the angle and current requirements are satisfied. The three values are never collapsed into a score.</p><p>The console lists each metric and its data qualification separately from its verdict. Statistics without a requirement remain UNDECIDED, including when numerical evidence is COMPLETE. See verification/example_verification.md for measured values and the actual compiler scope.</p></html>"));
end MultiSignalAssessment;
