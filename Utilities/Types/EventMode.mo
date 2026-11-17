within EvaluationLibrary.Utilities.Types;
type EventMode=enumeration(Occurrence,RequestResponse,Recovery) "Event-assessment task" annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-59,-1},{-42,-1},{-42,14},{-22,14},{-22,-1},{59,-1}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-59,-36},{15,-36},{15,-21},{35,-21},{35,-36},{59,-36}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid),
        Text(extent={{-61,-59},{61,-80}}, textString="EVENT", textColor={255,255,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Select occurrence counting, request-response matching or recovery assessment. The selected mode determines how <code>Response.EventAssessment</code> interprets its request and response inputs.</p></html>"));
