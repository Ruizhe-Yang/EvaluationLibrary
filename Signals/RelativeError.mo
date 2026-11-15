within EvaluationLibrary.Signals;
block RelativeError "Compute relative error with an explicit denominator floor"
parameter Real referenceFloor(min=0)=1e-9 "Positive reference magnitude floor; smaller magnitudes are undefined";
  Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput reference "Declared reference in the same engineering unit" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Y" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "The numerical output exists in the current data domain" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
initial equation
  assert(referenceFloor>0,"Reference floor must be positive.");
equation
  available=abs(reference)>=referenceFloor and abs(reference)<Modelica.Constants.inf and abs(u)<Modelica.Constants.inf;
  y=if available then (u-reference)/abs(reference) else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,33},{-32,33}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-65,-18},{-32,-18}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-69,62},{-39,39}}, textString="u", textColor={128,128,128}, fontSize=0),
        Text(extent={{-74,-22},{-34,-44}}, textString="ref", textColor={128,128,128}, fontSize=0),
        Text(extent={{-20,61},{62,18}}, textString="Δ", textColor={0,0,127}, fontSize=0),
        Line(points={{-23,8},{62,8}}, color={0,0,127}, thickness=0.75, pattern=LinePattern.Solid),
        Text(extent={{-23,2},{62,-34}}, textString="|ref|", textColor={0,0,127}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="|ref| ≥ floor", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Return (u-reference)/abs(reference), a dimensionless signed relative error. referenceFloor defaults to 1e-9 in the reference unit and must be positive; absolute reference magnitude at least this floor is accepted. A zero or too-small reference makes the result unavailable rather than supplying zero error.</p></html>"));
end RelativeError;
