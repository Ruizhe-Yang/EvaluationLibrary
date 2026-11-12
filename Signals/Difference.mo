within EvaluationLibrary.Signals;
block Difference "Compute a signed paired difference"
Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput reference annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
equation
  available=abs(u)<Modelica.Constants.inf and abs(reference)<Modelica.Constants.inf;
  y=if available then u-reference else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-66,34},{-35,34}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-66,-17},{-35,-17}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-61,61},{-34,35}}, textString="+", textColor={128,128,128}, fontSize=0),
        Text(extent={{-61,-23},{-34,-49}}, textString="−", textColor={128,128,128}, fontSize=0),
        Text(extent={{-29,49},{60,-32}}, textString="−", textColor={0,0,127}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="u − ref", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Compute a signed paired difference.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.RealInput reference; Modelica.Blocks.Interfaces.RealOutput y; Modelica.Blocks.Interfaces.BooleanOutput available</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Compute a signed paired difference</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Pair input samples before use. A numeric placeholder when unavailable does not represent zero error.</p><p><b>Observables</b> y, available</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p></html>"));
end Difference;
