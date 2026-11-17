within EvaluationLibrary.Utilities;
package Internal "Internal accumulation, observation and output helpers"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-57.04,9.2},{-7.36,53.36}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{7.36,-50.6},{57.04,-6.44}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-7.36,31.28},{32.2,31.28},{32.2,-6.44}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-50.6,46.92},{-12.88,14.72}}, textString="Σ", textColor={0,0,127}, fontSize=0),
        Text(extent={{14.72,-11.04},{50.6,-45.08}}, textString="z", textColor={0,0,127}, fontSize=0)
      }));
  annotation(Documentation(info="<html><p>Implementation helpers used by the library blocks, including observation windows, sample accumulation, event matching, spectral calculations and report writing. Prefer the public evaluation and reporting blocks when assembling an application model.</p></html>"));
end Internal;
