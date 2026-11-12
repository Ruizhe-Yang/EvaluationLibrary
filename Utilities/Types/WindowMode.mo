within EvaluationLibrary.Utilities.Types;
type WindowMode = enumeration(FixedTime,ExternalSingle) "Fixed or externally triggered observation window" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-61,74},{61,0}}, textString="E", textColor={255,255,255}, fontSize=0),
        Rectangle(extent={{-59,-50},{-10,-14}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{10,-49},{25,-49},{25,-14},{59,-14}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid)
      }));
