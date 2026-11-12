within EvaluationLibrary.Utilities.Types;
type DataStatus = enumeration(PENDING,COMPLETE,INCOMPLETE,INVALID,NOT_APPLICABLE) "Qualification of data coverage" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-61,74},{61,0}}, textString="E", textColor={255,255,255}, fontSize=0),
        Ellipse(extent={{-58,-46},{-34,-22}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Ellipse(extent={{-12,-46},{12,-22}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{34,-22},{58,-46}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{34,-46},{58,-22}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid)
      }));
