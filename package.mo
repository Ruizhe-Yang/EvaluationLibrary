within;
package EvaluationLibrary "Signal metrics, requirement checks and qualified result reporting"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-60.72,41.4},{-45.08,41.4},{-32.2,56.12},{-17.48,27.6},{-1.84,41.4},{11.04,41.4}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-60.72,2.76},{-38.64,2.76},{-21.16,22.08},{-1.84,-11.96},{11.04,2.76}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-60.72,-36.8},{-35.88,-36.8},{-20.24,-22.08},{11.04,-36.8}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Rectangle(extent={{24.84,-42.32},{63.48,55.2}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{32.2,34.04},{56.12,34.04}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{32.2,6.44},{56.12,6.44}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{32.2,-21.16},{56.12,-21.16}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid)
      }),
    uses(Modelica(version="4.0.0")), version="1.0.0", Documentation(info="<html><p><b>EvaluationLibrary</b> provides signal statistics, event and response measurements, requirement checks, comparisons and finite-window frequency analysis. Complete results carry numerical availability, data status and requirement verdicts to console, CSV and text writers.</p><p>The library requires Modelica Standard Library 4.0.0. Begin with <a href=\"modelica://EvaluationLibrary.UsersGuide.GettingStarted\">GettingStarted</a> and <a href=\"modelica://EvaluationLibrary.Examples.MultiSignalAssessment\">MultiSignalAssessment</a>. The <a href=\"modelica://EvaluationLibrary.UsersGuide\">User's Guide</a> describes observation conventions and limitations. Each public block documents its inputs, parameters and numerical interpretation.</p></html>"));
end EvaluationLibrary;
