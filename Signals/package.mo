within EvaluationLibrary;
package Signals "Signal transformations and data validity"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-57.04,29.44},{-21.16,29.44}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-57.04,-23.92},{-21.16,-23.92}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Rectangle(extent={{-20.24,-36.8},{39.56,42.32}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-11.96,35.88},{30.36,-29.44}}, textString="Δ", textColor={0,0,127}, fontSize=0),
        Line(points={{39.56,2.76},{60.72,2.76}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled})
      }));
  annotation(Documentation(info="<html><p>Signal blocks for differences, relative and angular errors, sampled differentiation and input qualification. These blocks expose numerical outputs and validity flags without an observation-window verdict.</p></html>"));
end Signals;
