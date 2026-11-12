within EvaluationLibrary.Utilities.Internal;
block ContinuousAccumulator "Integrate first and second moments over qualified time"
Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput integrate annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput total(start=0,fixed=true) annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput squareTotal(start=0,fixed=true) annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
equation
  der(total)=if integrate then u else 0;
  der(squareTotal)=if integrate then u*u else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-56,57},{-8,-22}}, textString="∫", textColor={0,0,127}, fontSize=0),
        Text(extent={{-3,36},{66,-4}}, textString="u, u²", textColor={64,64,64}, fontSize=0),
        Line(points={{-53,-31},{56,-31}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="µ, σ², RMS", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Integrate first and second moments over qualified time.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.BooleanInput integrate; Modelica.Blocks.Interfaces.RealOutput total(start=0,fixed=true); Modelica.Blocks.Interfaces.RealOutput squareTotal(start=0,fixed=true)</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Integrate first and second moments over qualified time</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> total, squareTotal</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p></html>"));
end ContinuousAccumulator;
