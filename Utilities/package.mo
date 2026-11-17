within EvaluationLibrary;
package Utilities "Result types, connectors and shared evaluation functions"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-58.88,0},{-3.68,55.2}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-47.84,49.68},{-14.72,4.6}}, textString="f", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{7.36,-50.6},{58.88,-0.92}}, lineColor={128,128,128}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{14.72,-5.52},{52.44,-45.08}}, textString="T", textColor={64,64,64}, fontSize=0),
        Line(points={{-31.28,0},{-31.28,-25.76},{7.36,-25.76}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid)
      }));
  annotation(Documentation(info="<html><p>This package contains the types, directional connectors and functions used by the evaluation blocks. <code>Types.MetricResult</code> holds a result and its observation metadata; <code>Interfaces.MetricInput</code> and <code>Interfaces.MetricOutput</code> carry the same information between components.</p><p>Use <code>Functions</code> for result conversion and formatting. <code>Internal</code> contains implementation helpers intended for use by the library components.</p></html>"));
end Utilities;
