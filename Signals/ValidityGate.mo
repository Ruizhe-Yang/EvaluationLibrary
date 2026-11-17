within EvaluationLibrary.Signals;
block ValidityGate "Signal pass-through with range and age qualification"
parameter Real lower=-Modelica.Constants.inf "Inclusive lower acceptance bound";
  parameter Real upper=Modelica.Constants.inf "Inclusive upper acceptance bound";
  parameter Modelica.Units.SI.Time maxAge(min=0)=1 "Maximum age of evidence in seconds";
    Modelica.Blocks.Interfaces.RealInput u "Observed signal" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput age(unit="s") "Age of the input value" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput validIn "External input-validity condition" annotation(Placement(transformation(origin={70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={70,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y "Unmodified input value" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput valid "Combined validity condition" annotation(Placement(transformation(origin={-70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={-70,100},extent={{-10,-10},{10,10}})));
initial equation
  assert(lower<=upper and maxAge>=0,"Invalid data validity bounds.");
equation
  y=u;
  valid=validIn and abs(u)<Modelica.Constants.inf and u>=lower and u<=upper and age>=0 and age<=maxAge;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-67,40},{66,40}}, color={0,0,127}, thickness=1.05, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-53,40},{-53,10},{-17,10}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Rectangle(extent={{-18,-32},{22,11}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55, radius=0),
        Text(extent={{-14,7},{18,-28}}, textString="&", textColor={0,0,127}, fontSize=0),
        Line(points={{2,-32},{2,-51}}, color={0,0,127}, thickness=0.75, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Ellipse(extent={{-60,-35},{-36,-11}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{-48,-14},{-48,-23},{-41.4,-27.2}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{-36,-23},{-18,-17}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{38,-20},{65,-20}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{38,-29},{38,-11}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{65,-29},{65,-11}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Ellipse(extent={{48.2,-22.8},{53.8,-17.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{38,-20},{22,-17}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="value + valid", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Passes <code>u</code> to <code>y</code> unchanged. The separate <code>valid</code> output requires <code>validIn=true</code>, a finite value within the inclusive bounds <code>lower</code> and <code>upper</code>, and an age between zero and <code>maxAge</code>. An invalid value is not replaced or latched.</p></html>"));
end ValidityGate;
