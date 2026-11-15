within EvaluationLibrary.Utilities.Internal;
block ContinuousAccumulator "Integrate first and second moments over qualified time"
Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput integrate "Integrate" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput total(start=0,fixed=true) "Total" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput squareTotal(start=0,fixed=true) "Square total" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
equation
  der(total)=if integrate then u else 0;
  der(squareTotal)=if integrate then u*u else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,16},{-32,16}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-32,16},{-32,43},{-9,43}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-32,16},{-32,-20},{-9,-20}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Rectangle(extent={{-9,20},{44,66}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-5,57},{40,28}}, textString="1/s", textColor={64,64,64}, fontSize=0),
        Rectangle(extent={{-9,-43},{44,3}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-5,-6},{40,-35}}, textString="1/s", textColor={64,64,64}, fontSize=0),
        Text(extent={{-65,53},{-38,30}}, textString="u", textColor={64,64,64}, fontSize=0),
        Text(extent={{-72,-3},{-33,-29}}, textString="u^2", textColor={64,64,64}, fontSize=0),
        Line(points={{44,43},{66,43}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{44,-20},{66,-20}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Shared continuous first and second integral accumulation. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
end ContinuousAccumulator;
