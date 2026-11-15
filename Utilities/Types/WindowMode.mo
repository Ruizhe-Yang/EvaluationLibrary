within EvaluationLibrary.Utilities.Types;
type WindowMode = enumeration(FixedTime,ExternalSingle) "Fixed or externally triggered observation window" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-60,-31},{60,-31}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid),
        Ellipse(extent={{-64,-35},{-56,-27}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Ellipse(extent={{56,-35},{64,-27}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=1),
        Line(points={{-34,11},{-34,-15}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-54,-60},{54,-80}}, textString="WIN", textColor={255,255,255}, fontSize=0)
      }),Documentation(info="<html><p>WindowMode supports the single complete-result and explicit qualification contract. See the parameter and field descriptions for its numerical or logical meaning.</p></html>"));
