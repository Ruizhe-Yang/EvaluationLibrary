within EvaluationLibrary.Utilities.Types;
type Sense = enumeration(LowerIsBetter,UpperIsBetter) "Direction of performance improvement" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-30,-51},{-30,5}}, color={255,255,255}, thickness=1.3, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{30,5},{30,-51}}, color={255,255,255}, thickness=1.3, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-62},{65,-80}}, textString="BETTER", textColor={255,255,255}, fontSize=0)
      }),Documentation(info="<html><p>Sense supports the single complete-result and explicit qualification contract. See the parameter and field descriptions for its numerical or logical meaning.</p></html>"));
