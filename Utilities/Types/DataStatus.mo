within EvaluationLibrary.Utilities.Types;
type DataStatus = enumeration(PENDING,COMPLETE,INCOMPLETE,INVALID,NOT_APPLICABLE) "Observation coverage and data-validity status" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-57,-4},{57,-4}}, color={255,255,255}, thickness=3, pattern=LinePattern.Solid),
        Line(points={{-57,-27},{17,-27}}, color={255,255,255}, thickness=3, pattern=LinePattern.Solid),
        Line(points={{-57,-50},{-17,-50}}, color={255,255,255}, thickness=3, pattern=LinePattern.Solid),
        Text(extent={{-55,-62},{55,-80}}, textString="DATA", textColor={255,255,255}, fontSize=0)
      }),Documentation(info="<html><p><code>PENDING</code> means that observation is still open; <code>COMPLETE</code> means the producing block has obtained the required coverage; <code>INCOMPLETE</code> means coverage is insufficient; <code>INVALID</code> denotes unusable input, configuration or observation history; <code>NOT_APPLICABLE</code> excludes an inapplicable evaluation.</p><p>These statuses are independent of requirement verdicts. Their ordinals are 1 through 5 in the order shown and are used by the result connectors.</p></html>"));
