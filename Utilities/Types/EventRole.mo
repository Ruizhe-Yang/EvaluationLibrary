within EvaluationLibrary.Utilities.Types;
type EventRole=enumeration(Observation,ProtectionRequest,ActionFeedback,Detection,Isolation,Recovery) "Descriptive task role; it never changes event matching" annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-39,-58},{-39,10}}, color={255,255,255}, thickness=1.2, pattern=LinePattern.Solid),
        Polygon(points={{-39,8},{49,8},{32,-9},{49,-26},{-39,-26},{-39,8}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=1),
        Text(extent={{-57,-60},{57,-80}}, textString="ROLE", textColor={255,255,255}, fontSize=0)
      }),
    Documentation(info="<html><p>EventRole supports the single complete-result and explicit qualification contract. See the parameter and field descriptions for its numerical or logical meaning.</p></html>"));
