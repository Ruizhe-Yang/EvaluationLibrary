within EvaluationLibrary.Examples;
model WrappedAngleAndSeverity "Evaluate wrapped angular errors and configured severity levels"
 Modelica.Blocks.Sources.Ramp crossing(offset=3.1,height=0.2,duration=1) "Crossing" annotation(Placement(transformation(origin={-80,60},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.Constant small(k=3.15) "Small" annotation(Placement(transformation(origin={-80,20},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.Constant medium(k=2.9) "Medium" annotation(Placement(transformation(origin={-80,-20},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.Constant large(k=2.5) "Large" annotation(Placement(transformation(origin={-80,-60},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Statistics.SignalAssessment assessment(n=4,metricId={"crossing","level0","level1","level2"},unitName=fill("rad",4),interpretation=fill(EvaluationLibrary.Utilities.Types.InputInterpretation.WrappedAngleDifference,4),reference=fill(-3.1,4),lower=fill(-0.5,4),upper=fill(0.5,4),classifySeverity=fill(true,4),level0Upper=fill(0.1,4),level1Upper=fill(0.5,4),windowStop=1,samplePeriod=0.01) "Assessment" annotation(Placement(transformation(origin={0,0},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.ConsoleWriter report(n=4,runId="wrapped_angle") "Report" annotation(Placement(transformation(origin={80,0},extent={{-10,-10},{10,10}})));
equation
 connect(crossing.y,assessment.u[1]) annotation(Line(points={{-70.0, 60.0}, {-40, 60}, {-40, 0}, {-10.0, 0.0}},color={0,0,127}));
 connect(small.y,assessment.u[2]) annotation(Line(points={{-70.0, 20.0}, {-40, 20}, {-40, 0}, {-10.0, 0.0}},color={0,0,127}));
 connect(medium.y,assessment.u[3]) annotation(Line(points={{-70.0, -20.0}, {-40, -20}, {-40, 0}, {-10.0, 0.0}},color={0,0,127}));
 connect(large.y,assessment.u[4]) annotation(Line(points={{-70.0, -60.0}, {-40, -60}, {-40, 0}, {-10.0, 0.0}},color={0,0,127}));
 connect(assessment.y,report.u) annotation(Line(points={{10.0, 0.0}, {70.0, 0.0}},color={0,0,127}));
 annotation(experiment(StartTime=0,StopTime=1.2,Interval=0.01,Tolerance=1e-7),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-120,-100},{120,100}})),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-90,-90},{90,90}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Polygon(points={{-62,43},{-62,-43},{-5,0},{-62,43}}, lineColor={75,138,73}, fillColor={75,138,73}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Ellipse(extent={{14.56,-17.76},{52.96,20.64}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{33.76,1.44},{18.88,11.52}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{33.76,1.44},{17.44,-7.2}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{15.52,34.56},{54.4,21.12}}, textString="±π", textColor={0,0,127}, fontSize=0),
        Rectangle(extent={{58.24,-17.28},{62.56,-10.08}}, lineColor={0,0,127}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{64.48,-17.28},{68.8,-2.4}}, lineColor={0,0,127}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{70.72,-17.28},{75.04,5.76}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Documentation(info="<html><p>Computes principal angular differences for a ramp and three constant signals relative to -3.1 rad. The constant absolute errors are approximately 0.0332, 0.2832 and 0.6832 rad, giving configured levels 0, 1 and 2. The largest error also violates the 0.5 rad bound. Inspect <code>assessment.y</code> and the console report.</p></html>"));
end WrappedAngleAndSeverity;
