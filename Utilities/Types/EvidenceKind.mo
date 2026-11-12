within EvaluationLibrary.Utilities.Types;
type EvidenceKind = enumeration(Continuous,Sampled,Event,Derived) "Basis of a numeric or requirement result" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-61,74},{61,0}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-61,-37},{-51,-25},{-41,-37},{-31,-25},{-21,-37}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid),
        Ellipse(extent={{-7,-38},{1,-30}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Ellipse(extent={{12,-30},{20,-22}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{43,-46},{43,-16}}, color={255,255,255}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled})
      }));
