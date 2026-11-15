within EvaluationLibrary.Utilities.Types;
type NumericComparison = enumeration(AtMost "Numeric comparison", AtLeast "Numeric comparison", Inside "Numeric comparison") "Numeric comparison"
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Text(extent={{-68,4},{68,-26}}, textString="<=  >=", textColor={255,255,255}, fontSize=0),
        Line(points={{-48,-50},{48,-50}}, color={255,255,255}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-48,-40},{-48,-60}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{48,-40},{48,-60}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid)
      }),
    Documentation(info="<html><p>Numeric comparison. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
