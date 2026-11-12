within EvaluationLibrary.Signals;
block ValidityGate "Preserve the value while qualifying data and age"
parameter Real lower=-Modelica.Constants.inf;
  parameter Real upper=Modelica.Constants.inf;
  parameter Modelica.Units.SI.Time maxAge(min=0)=1;
    Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput age(unit="s") annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput validIn annotation(Placement(transformation(origin={70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={70,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput valid annotation(Placement(transformation(origin={-70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={-70,100},extent={{-10,-10},{10,10}})));
initial equation
  assert(lower<=upper and maxAge>=0,"Invalid data validity bounds.");
equation
  y=u;
  valid=validIn and abs(u)<Modelica.Constants.inf and u>=lower and u<=upper and age>=0 and age<=maxAge;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,33},{63,33}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-47,33},{-47,-20},{-15,-20}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Rectangle(extent={{-15,-39},{34,-1}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{34,-20},{65,-20}}, color={75,138,73}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-3,-19},{6.12,-28.6},{23.88,-5.56}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="value + valid", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Preserve the value while qualifying data and age.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.RealInput age(unit=\"s\"); Modelica.Blocks.Interfaces.BooleanInput validIn; Modelica.Blocks.Interfaces.RealOutput y; Modelica.Blocks.Interfaces.BooleanOutput valid</p><p><b>Parameters</b> parameter Real lower=-Modelica.Constants.inf; parameter Real upper=Modelica.Constants.inf; parameter Modelica.Units.SI.Time maxAge(min=0)=1</p><p><b>Behavior</b> Preserve the value while qualifying data and age</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> y, valid</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p></html>"));
end ValidityGate;
