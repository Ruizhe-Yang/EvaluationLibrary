within EvaluationLibrary.Utilities.Functions;
function SampleCount "Count uniform samples in a half-open interval"
  extends Modelica.Icons.Function;
input Modelica.Units.SI.Time left "Inclusive interval start";
  input Modelica.Units.SI.Time right "Exclusive interval stop";
  input Modelica.Units.SI.Time origin "First point of the non-negative sample grid";
  input Modelica.Units.SI.Time period "Positive sample-grid spacing";
  output Integer n "Number of grid points in the interval";
algorithm
  assert(period>0,"Sample period must be positive.");
  n:=max(0,integer(ceil((right-origin)/period-1e-9))-max(0,integer(ceil((left-origin)/period-1e-9))));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Line(points={{-48.507,7.871},{48.507,7.871}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{-51.911,4.467},{-45.103,11.275}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Ellipse(extent={{45.103,4.467},{51.911,11.275}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-48.507,-2.341},{-48.507,32.55}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{48.507,-2.341},{48.507,32.55}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{-48.507,-23.616},{-48.507,5.318}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{-51.06,5.318},{-45.954,10.424}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-23.828,-23.616},{-23.828,5.318}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{-26.381,5.318},{-21.275,10.424}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{0.851,-23.616},{0.851,5.318}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{-1.702,5.318},{3.404,10.424}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{25.53,-23.616},{25.53,5.318}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{22.977,5.318},{28.083,10.424}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Text(extent={{-21.275,-35.53},{21.275,-65.315}}, textString="n", textColor={108,88,49}, fontSize=0)
      }),
    Documentation(info="<html><p>Count points of the grid <code>origin + k*period</code>, with non-negative integer <code>k</code>, that fall in <code>[left, right)</code>. The period must be positive. A small rounding allowance is applied when converting interval boundaries to grid indices.</p></html>"));
end SampleCount;
