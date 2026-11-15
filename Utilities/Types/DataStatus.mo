within EvaluationLibrary.Utilities.Types;
type DataStatus = enumeration(PENDING,COMPLETE,INCOMPLETE,INVALID,NOT_APPLICABLE) "Qualification of data coverage" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-57,-4},{57,-4}}, color={255,255,255}, thickness=3, pattern=LinePattern.Solid),
        Line(points={{-57,-27},{17,-27}}, color={255,255,255}, thickness=3, pattern=LinePattern.Solid),
        Line(points={{-57,-50},{-17,-50}}, color={255,255,255}, thickness=3, pattern=LinePattern.Solid),
        Text(extent={{-55,-62},{55,-80}}, textString="DATA", textColor={255,255,255}, fontSize=0)
      }),Documentation(info="<html><p>DataStatus supports the single complete-result and explicit qualification contract. See the parameter and field descriptions for its numerical or logical meaning.</p></html>"));
