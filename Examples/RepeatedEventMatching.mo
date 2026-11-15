within EvaluationLibrary.Examples;
model RepeatedEventMatching "Match repeated requests and responses one to one"
 Modelica.Blocks.Sources.BooleanPulse requests(period=0.4,width=20,startTime=0.1) "Requests" annotation(Placement(transformation(origin={-80,50},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.BooleanPulse responses(period=0.4,width=20,startTime=0.2) "Responses" annotation(Placement(transformation(origin={-80,0},extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.BooleanPulse extraResponses(period=0.2,width=20,startTime=0.15) "Extra responses" annotation(Placement(transformation(origin={-80,-50},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Response.EventAssessment assessment(n=2,metricId={"fifo","extra_feedback"},deadline=fill(0.25,2),windowStop=1.25) "Assessment" annotation(Placement(transformation(origin={0,0},extent={{-10,-10},{10,10}})));
 EvaluationLibrary.Results.ConsoleWriter report(n=2,runId="repeated_events") "Report" annotation(Placement(transformation(origin={80,0},extent={{-10,-10},{10,10}})));
equation
 connect(requests.y,assessment.request[1]) annotation(Line(points={{-70.0, 50.0}, {-40, 50}, {-40, 5}, {-10.0, 5.0}},color={0,0,127}));
 connect(requests.y,assessment.request[2]) annotation(Line(points={{-70.0, 50.0}, {-35, 50}, {-35, 5}, {-10.0, 5.0}},color={0,0,127}));
 connect(responses.y,assessment.response[1]) annotation(Line(points={{-70.0, 0.0}, {-30, 0}, {-30, -5}, {-10.0, -5.0}},color={0,0,127}));
 connect(extraResponses.y,assessment.response[2]) annotation(Line(points={{-70.0, -50.0}, {-25, -50}, {-25, -5}, {-10.0, -5.0}},color={0,0,127}));
 connect(assessment.y,report.u) annotation(Line(points={{10.0, 0.0}, {70.0, 0.0}},color={0,0,127}));
 annotation(experiment(StartTime=0,StopTime=1.4,Interval=0.01,Tolerance=1e-7),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-120,-100},{120,100}})),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-90,-90},{90,90}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Polygon(points={{-62,43},{-62,-43},{-5,0},{-62,43}}, lineColor={75,138,73}, fillColor={75,138,73}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{14.56,24.96},{14.56,10.56}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{21.76,1.44},{21.76,-12.96}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{14.56,10.08},{21.76,1.92}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{35.2,24.96},{35.2,10.56}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{42.4,1.44},{42.4,-12.96}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{35.2,10.08},{42.4,1.92}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{55.84,24.96},{55.84,10.56}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{63.04,1.44},{63.04,-12.96}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{55.84,10.08},{63.04,1.92}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Documentation(info="<html><p>Match repeated requests and responses one to one. All excitation, observation and result reporting are internal. No external input ports or result-field equations are required.</p><p>Three requests occur at 0.1,0.5,0.9 s. The first channel matches three delays of 0.1 s. The second matches three delays of 0.05 s and retains three unmatched extra responses. Extra feedback cannot count as a second success for the same request.</p><p>The console lists each metric and its data qualification separately from its verdict. Statistics without a requirement remain UNDECIDED, including when numerical evidence is COMPLETE. See verification/example_verification.md for measured values and the actual compiler scope.</p></html>"));
end RepeatedEventMatching;
