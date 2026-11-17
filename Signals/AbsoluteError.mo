within EvaluationLibrary.Signals;
block AbsoluteError "Absolute difference between two signals"
Modelica.Blocks.Interfaces.RealInput u "Observed signal" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput reference "Reference signal in the same unit" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Absolute error" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True when the numerical value is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
equation
  available=abs(u)<Modelica.Constants.inf and abs(reference)<Modelica.Constants.inf;
  y=if available then abs(u-reference) else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,33},{-32,33}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-65,-18},{-32,-18}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-69,62},{-39,39}}, textString="u", textColor={128,128,128}, fontSize=0),
        Text(extent={{-74,-22},{-34,-44}}, textString="ref", textColor={128,128,128}, fontSize=0),
        Text(extent={{-28,51},{65,-32}}, textString="|Δ|", textColor={0,0,127}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="absolute", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Computes <code>y = abs(u - reference)</code>. Connect signals with the same engineering unit. Both inputs must be finite; otherwise <code>available=false</code> and <code>y=0</code>.</p></html>"));
end AbsoluteError;
