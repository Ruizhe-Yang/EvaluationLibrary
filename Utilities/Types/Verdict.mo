within EvaluationLibrary.Utilities.Types;
type Verdict = enumeration(UNDECIDED,SATISFIED,VIOLATED,INVALID,NOT_APPLICABLE) "Requirement verdict independent of data coverage" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-61,74},{61,0}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-37.5,-36},{-28,-46},{-9.5,-22}}, color={255,255,255}, thickness=1.5, pattern=LinePattern.Solid),
        Line(points={{19,-23},{45,-49}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{19,-49},{45,-23}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid)
      }));
