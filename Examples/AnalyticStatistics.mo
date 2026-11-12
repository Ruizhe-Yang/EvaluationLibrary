within EvaluationLibrary.Examples;
model AnalyticStatistics "Compare continuous and sample statistics of a ramp"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression inputSignal(y=time) annotation(Placement(transformation(origin={-273,4},extent={{-14,-14},{14,14}},rotation=0)));
  EvaluationLibrary.Statistics.Integral integral(windowStop=2,samplePeriod=0.01) annotation(Placement(transformation(origin={-34,175},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput integralValue annotation(Placement(transformation(origin={242,175},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Statistics.TimeMean timeMean(windowStop=2,samplePeriod=0.01) annotation(Placement(transformation(origin={-34,106},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput timeMeanValue annotation(Placement(transformation(origin={242,106},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Statistics.TimeRMS timeRMS(windowStop=2,samplePeriod=0.01) annotation(Placement(transformation(origin={-34,37},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput timeRMSValue annotation(Placement(transformation(origin={242,37},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Statistics.TimeVariance timeVariance(windowStop=2,samplePeriod=0.01) annotation(Placement(transformation(origin={-34,-32},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput timeVarianceValue annotation(Placement(transformation(origin={242,-32},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Statistics.SampleMean sampleMean(windowStop=2,samplePeriod=0.01) annotation(Placement(transformation(origin={-34,-101},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput sampleMeanValue annotation(Placement(transformation(origin={242,-101},extent={{-7,-7},{7,7}},rotation=0)));
  EvaluationLibrary.Statistics.SampleExtrema sampleRange(windowStop=2,samplePeriod=0.01) annotation(Placement(transformation(origin={-34,-170},extent={{-17,-17},{17,17}},rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput sampleRangeValue annotation(Placement(transformation(origin={242,-170},extent={{-7,-7},{7,7}},rotation=0)));
equation
  connect(inputSignal.y,integral.u) annotation(Line(points={{-257.6,4},{-252.6,4},{-252.6,178.96666},{-51,178.96666}},color={0,0,127}));
  connect(integral.value,integralValue) annotation(Line(points={{-17,175},{242,175}},color={0,0,127}));
  connect(inputSignal.y,timeMean.u) annotation(Line(points={{-257.6,4},{-252.6,4},{-252.6,109.96666},{-51,109.96666}},color={0,0,127}));
  connect(timeMean.value,timeMeanValue) annotation(Line(points={{-17,106},{242,106}},color={0,0,127}));
  connect(inputSignal.y,timeRMS.u) annotation(Line(points={{-257.6,4},{-252.6,4},{-252.6,40.96666},{-51,40.96666}},color={0,0,127}));
  connect(timeRMS.value,timeRMSValue) annotation(Line(points={{-17,37},{242,37}},color={0,0,127}));
  connect(inputSignal.y,timeVariance.u) annotation(Line(points={{-257.6,4},{-252.6,4},{-252.6,-28.03334},{-51,-28.03334}},color={0,0,127}));
  connect(timeVariance.value,timeVarianceValue) annotation(Line(points={{-17,-32},{242,-32}},color={0,0,127}));
  connect(inputSignal.y,sampleMean.u) annotation(Line(points={{-257.6,4},{-252.6,4},{-252.6,-97.03334},{-51,-97.03334}},color={0,0,127}));
  connect(sampleMean.value,sampleMeanValue) annotation(Line(points={{-17,-101},{242,-101}},color={0,0,127}));
  connect(inputSignal.y,sampleRange.u) annotation(Line(points={{-257.6,4},{-252.6,4},{-252.6,-166.03334},{-51,-166.03334}},color={0,0,127}));
  connect(sampleRange.value,sampleRangeValue) annotation(Line(points={{-17,-161.5},{242,-161.5},{242,-170}},color={0,0,127}));
  annotation(experiment(StartTime=0,StopTime=2.1,Interval=0.004200000000000001,Tolerance=1e-6),
    Diagram(coordinateSystem(extent={{-360,-240},{360,240}},preserveAspectRatio=true),graphics={Text(extent={{-150,231},{176,217}},textString="Continuous measures and explicit sampled measures",textColor={34,61,73})}),
    Documentation(info="<html><p><b>Purpose</b> Compare continuous and sample statistics of a ramp</p><p><b>Interfaces</b> Instances and connections are shown in the Diagram layer.</p><p><b>Parameters</b> Default values are shown in the component modifiers.</p><p><b>Behavior</b> Integral 2, mean 1, RMS 2/sqrt(3), variance 1/3. There are 200 samples with mean 0.995 and maximum 1.99.</p><p><b>Initialization</b> All initial conditions are explicit in the source and component modifiers.</p><p><b>Activation and recovery</b> The given time windows follow the simulation time axis.</p><p><b>Limitations</b> This demonstration uses the declared inputs, initial conditions and idealized components.</p><p><b>Observables</b> Integral, timeMean, timeRMS, timeVariance, sampleMean, sampleRange.maximum, sampleMean.nValid.</p></html>"));
end AnalyticStatistics;
