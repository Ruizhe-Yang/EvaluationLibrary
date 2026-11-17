within EvaluationLibrary.Utilities;
package Types "Result record and enumeration types"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-57.04,-57.04},{57.04,57.04}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=11.04),
        Text(extent={{-41.4,42.32},{41.4,-40.48}}, textString="T", textColor={255,255,255}, fontSize=0)
      }));
  annotation(Documentation(info="<html><p>Types shared by evaluation and reporting components. <code>MetricResult</code> stores the numerical result and its supporting metadata. <code>DataStatus</code>, <code>Verdict</code> and <code>EvidenceKind</code> distinguish observation quality, requirement outcome and evidence basis.</p></html>"));
end Types;
