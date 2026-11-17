within EvaluationLibrary.Utilities.Types;
type ReportFormat = enumeration(CSV "Comma-separated values", Text "Readable plain text") "Format of a result report"
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Rectangle(extent={{-53,-50},{53,8}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=1, radius=0),
        Line(points={{-9,-50},{-9,8}}, color={255,255,255}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-47,-5},{-17,-41}}, textString=",", textColor={255,255,255}, fontSize=0),
        Line(points={{4,-8},{41,-8}}, color={255,255,255}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{4,-24},{41,-24}}, color={255,255,255}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{4,-40},{28,-40}}, color={255,255,255}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-70,-61},{70,-80}}, textString="CSV/TXT", textColor={255,255,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Select comma-separated values (<code>CSV</code>) or readable plain text (<code>Text</code>) where a reporting component exposes this choice.</p></html>"));
