within EvaluationLibrary.Utilities.Types;
type WritePolicy = enumeration(RejectExisting,Overwrite) "Explicit existing file policy" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-61,74},{61,0}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-57,-16},{-27,-46}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-57,-46},{-27,-16}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{6,-35},{43,-35},{43,-17}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled})
      }));
