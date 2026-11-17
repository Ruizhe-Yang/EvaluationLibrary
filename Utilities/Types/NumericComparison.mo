within EvaluationLibrary.Utilities.Types;
type NumericComparison = enumeration(AtMost "At or below the upper bound", AtLeast "At or above the lower bound", Inside "Within both inclusive bounds") "Comparison used to interpret a numerical requirement"
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Text(extent={{-68,4},{68,-26}}, textString="<=  >=", textColor={255,255,255}, fontSize=0),
        Line(points={{-48,-50},{48,-50}}, color={255,255,255}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-48,-40},{-48,-60}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{48,-40},{48,-60}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid)
      }),
    Documentation(info="<html><p><code>AtMost</code> accepts values at or below the upper bound, <code>AtLeast</code> accepts values at or above the lower bound, and <code>Inside</code> accepts values within both inclusive bounds.</p></html>"));
