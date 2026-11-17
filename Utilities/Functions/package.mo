within EvaluationLibrary.Utilities;
package Functions "Functions for result qualification, formatting and spectral analysis"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-57.04,-57.04},{57.04,57.04}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-33.12,46},{33.12,-46}}, textString="f", textColor={108,88,49}, fontSize=0)
      }));
  annotation(Documentation(info="<html><p>Functions for combining verdicts, converting status codes, formatting result records, counting samples and evaluating a finite sinusoidal projection. Formatting functions return strings; they do not write files or print to the console.</p></html>"));
end Functions;
