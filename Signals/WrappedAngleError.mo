within EvaluationLibrary.Signals;
block WrappedAngleError "Signed angular error wrapped to one revolution"
Modelica.Blocks.Interfaces.RealInput angle(unit="rad") "Observed angle in radians" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput reference(unit="rad") "Reference signal in the same unit" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y(unit="rad") "Wrapped signed angular error" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True when the numerical value is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
equation
  available=abs(angle)<Modelica.Constants.inf and abs(reference)<Modelica.Constants.inf;
  y=if available then Modelica.Math.atan2(sin(angle-reference),cos(angle-reference)) else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Ellipse(extent={{-42,-31},{42,53}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.65),
        Line(points={{0,11},{-41.8402,14.6605}}, color={128,128,128}, thickness=0.75, pattern=LinePattern.Solid),
        Line(points={{0,11},{-38.0649,-6.74997}}, color={0,0,127}, thickness=1.05, pattern=LinePattern.Solid),
        Line(points={{-30.882,13.7018},{-30.9811,12.0819},{-30.9953,10.459},{-30.9245,8.83755},{-30.7689,7.22205},{-30.529,5.61691},{-30.2055,4.02652},{-29.7991,2.45524},{-29.3111,0.907387},{-28.7427,-0.612804},{-28.0955,-2.10117}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Ellipse(extent={{-2.5,8.5},{2.5,13.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Text(extent={{27,-18},{67,-45}}, textString="±π", textColor={64,64,64}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="wrap(Δφ)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Computes <code>atan2(sin(angle - reference), cos(angle - reference))</code> in radians, with a branch cut at plus or minus pi. Both inputs must be finite. Equivalent full rotations have zero error; unavailable inputs produce <code>available=false</code> and <code>y=0</code>.</p></html>"));
end WrappedAngleError;
