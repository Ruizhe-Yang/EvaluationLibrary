within EvaluationLibrary.Examples;
model ContinuousAndSampleStatistics "Compare continuous and uniformly sampled statistics"
 Modelica.Blocks.Sources.Ramp ramp(height=2,duration=2) "Ramp" annotation(Placement(transformation(origin={-90,0},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Statistics.TimeMean mean(windowStop=2,metricId="continuous_mean",unitName="m") "Mean" annotation(Placement(transformation(origin={-10,60},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Statistics.TimeRMS rms(windowStop=2,metricId="continuous_rms",unitName="m") "Continuous root-mean-square value" annotation(Placement(transformation(origin={-10,20},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Statistics.SampleMean sampleMean(windowStop=2,samplePeriod=0.5,metricId="sample_mean",unitName="m") "Sample mean" annotation(Placement(transformation(origin={-10,-20},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Statistics.SampleVariance variance(windowStop=2,samplePeriod=0.5,ddof=0,metricId="sample_variance",unitName="m2") "Variance" annotation(Placement(transformation(origin={-10,-60},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.ConsoleWriter report(n=4,runId="statistics") "Report" annotation(Placement(transformation(origin={80,0},extent={{-10,-10},{10,10}})));
equation
 connect(ramp.y,mean.u) annotation(Line(points={{-80.0, 0.0}, {-50, 0}, {-50, 60}, {-20.0, 62.333333}},color={0,0,127}));
 connect(ramp.y,rms.u) annotation(Line(points={{-80.0, 0.0}, {-50, 0}, {-50, 20}, {-20.0, 22.333333}},color={0,0,127}));
 connect(ramp.y,sampleMean.u) annotation(Line(points={{-80.0, 0.0}, {-50, 0}, {-50, -20}, {-20.0, -17.666667}},color={0,0,127}));
 connect(ramp.y,variance.u) annotation(Line(points={{-80.0, 0.0}, {-50, 0}, {-50, -60}, {-20.0, -57.666667}},color={0,0,127}));
 connect(mean.result,report.u[1]) annotation(Line(points={{0.0, 67.0}, {50, 60}, {50, 0}, {70.0, 0.0}},color={0,0,127}));
 connect(rms.result,report.u[2]) annotation(Line(points={{0.0, 27.0}, {50, 20}, {50, 0}, {70.0, 0.0}},color={0,0,127}));
 connect(sampleMean.result,report.u[3]) annotation(Line(points={{0.0, -13.0}, {50, -20}, {50, 0}, {70.0, 0.0}},color={0,0,127}));
 connect(variance.result,report.u[4]) annotation(Line(points={{0.0, -53.0}, {50, -60}, {50, 0}, {70.0, 0.0}},color={0,0,127}));
 annotation(experiment(StartTime=0,StopTime=2.2,Interval=0.01,Tolerance=1e-7),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-120,-100},{120,100}})),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-90,-90},{90,90}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Polygon(points={{-62,43},{-62,-43},{-5,0},{-62,43}}, lineColor={75,138,73}, fillColor={75,138,73}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{10.24,26.4},{10.24,-19.2},{71.2,-19.2}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{12.64,-15.36},{66.4,23.52}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Ellipse(extent={{10.24,-17.76},{15.04,-12.96}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Ellipse(extent={{23.68,-8.16},{28.48,-3.36}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Ellipse(extent={{37.12,1.44},{41.92,6.24}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Ellipse(extent={{50.56,11.52},{55.36,16.32}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Documentation(info="<html><p>Simulate the ramp over <code>[0,2)</code> and inspect <code>mean.value</code>, <code>rms.value</code>, <code>sampleMean.value</code> and <code>variance.value</code>. The analytical values are 1, sqrt(4/3), 0.75 and 0.3125 respectively. The console reports each statistic with separate evidence qualification; descriptive statistics retain an undecided requirement verdict.</p></html>"));
end ContinuousAndSampleStatistics;
