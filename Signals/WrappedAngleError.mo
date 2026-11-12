within EvaluationLibrary.Signals;
block WrappedAngleError "Compute wrapped angular direction error"
Modelica.Blocks.Interfaces.RealInput angle(unit="rad") annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput reference(unit="rad") annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y(unit="rad") annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
equation
  available=abs(angle)<Modelica.Constants.inf and abs(reference)<Modelica.Constants.inf;
  y=if available then Modelica.Math.atan2(sin(angle-reference),cos(angle-reference)) else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Ellipse(extent={{-48,-39},{44,53}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{-2,7},{-2,47}}, color={128,128,128}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-2,7},{29,35}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-2,32},{5,32},{13,29},{18,24}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Ellipse(extent={{-5,4},{1,10}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{37,-27},{66,-48}}, textString="±π", textColor={64,64,64}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="wrap(Δφ)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Compute wrapped angular direction error.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput angle(unit=\"rad\"); Modelica.Blocks.Interfaces.RealInput reference(unit=\"rad\"); Modelica.Blocks.Interfaces.RealOutput y(unit=\"rad\"); Modelica.Blocks.Interfaces.BooleanOutput available</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Compute wrapped angular direction error</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Pair input samples before use. A numeric placeholder when unavailable does not represent zero error.</p><p><b>Observables</b> y, available</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p></html>"));
end WrappedAngleError;
