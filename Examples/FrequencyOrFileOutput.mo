within EvaluationLibrary.Examples;
model FrequencyOrFileOutput "Measure a finite-window tone and optionally export complete results"
 Modelica.Blocks.Sources.Sine sine(amplitude=2,f=2) "Sine" annotation(Placement(transformation(origin={-80,0},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Frequency.SingleFrequency tone(frequency=2,nSamples=100,samplePeriod=0.01,windowStop=1,metricId="tone_amplitude",unitName="V") "Tone" annotation(Placement(transformation(origin={0,0},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.ConsoleWriter report(runId="frequency") "Report" annotation(Placement(transformation(origin={80,40},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.CSVWriter csv(runId="frequency",resultSetId="tone") "Csv" annotation(Placement(transformation(origin={80,-40},extent={{-10,-10},{10,10}})));
equation
 connect(sine.y,tone.u) annotation(Line(points={{-70.0, 0.0}, {-10.0, 2.333333}},color={0,0,127}));
 connect(tone.result,report.u[1]) annotation(Line(points={{10.0, 7.0}, {40, 7}, {40, 40}, {70.0, 40.0}},color={0,0,127}));
 connect(tone.result,csv.u[1]) annotation(Line(points={{10.0, 7.0}, {40, 7}, {40, -40}, {70.0, -40.0}},color={0,0,127}));
 annotation(experiment(StartTime=0,StopTime=1.2,Interval=0.01,Tolerance=1e-7),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-120,-100},{120,100}})),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-90,-90},{90,90}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Polygon(points={{-62,43},{-62,-43},{-5,0},{-62,43}}, lineColor={75,138,73}, fillColor={75,138,73}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{10.24,26.4},{10.24,-19.2},{71.2,-19.2}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{25.12,-19.2},{25.12,24.96}}, color={0,0,127}, thickness=1.6, pattern=LinePattern.Solid),
        Line(points={{41.92,-19.2},{41.92,-5.76}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{58.72,-19.2},{58.72,-12.48}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Documentation(info="<html><p>Measure a finite-window tone and optionally export complete results. All excitation, observation and result reporting are internal. No external input ports or result-field equations are required.</p><p>A coherent rectangular 100-point window at 0.01 s resolves the 2 Hz tone with amplitude 2 V. This is a finite DFT estimate, not an infinite-duration spectrum. Console output and optional CSV consume the same complete result. An existing frequency_tone.csv is preserved by default; export success never changes UNDECIDED into SATISFIED.</p><p>The console lists each metric and its data qualification separately from its verdict. Statistics without a requirement remain UNDECIDED, including when numerical evidence is COMPLETE. See verification/example_verification.md for measured values and the actual compiler scope.</p></html>"));
end FrequencyOrFileOutput;
