within EvaluationLibrary.Utilities.Internal;
block ContinuousAccumulator "Integrate a signal and its squared value while enabled"
Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput integrate "Enable accumulation" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput total(start=0,fixed=true) "Time integral of the signal" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput squareTotal(start=0,fixed=true) "Time integral of the squared signal" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
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
    Documentation(info="<html><p>Integrate <code>u</code> and <code>u*u</code> while <code>integrate</code> is true. Both accumulated values start at zero and are held while disabled. The caller supplies the observation and validity condition; this block performs no validity check or reset.</p></html>"));
end ContinuousAccumulator;
