within EvaluationLibrary.Utilities;
package Interfaces "Directional connectors for structured evaluation results"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Polygon(points={{-58.88,37.72},{-58.88,-37.72},{-16.56,0},{-58.88,37.72}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{-16.56,0},{15.64,0}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid),
        Polygon(points={{15.64,37.72},{15.64,-37.72},{58.88,0},{15.64,37.72}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5)
      }));
  annotation(Documentation(info="<html><p><code>MetricOutput</code> connects an evaluation block to a <code>MetricInput</code> on a reporting or aggregation block. Each connector carries the value, availability flags, status, verdict and observation metadata together.</p><p>The corresponding record is <code>Types.MetricResult</code>. Connector fields use integer enumeration ordinals; the record uses enumeration types.</p></html>"));
end Interfaces;
