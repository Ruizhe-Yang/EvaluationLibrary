within EvaluationLibrary.Utilities.Types;
type WritePolicy = enumeration(RejectExisting,Overwrite) "Policy for an existing output file" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Rectangle(extent={{-22,-46},{40,10}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=1, radius=0),
        Line(points={{-61,-1},{-40,-22}}, color={255,255,255}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-61,-22},{-40,-1}}, color={255,255,255}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-49,-46},{-31,-46}}, color={255,255,255}, thickness=1.2, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-52,-62},{52,-80}}, textString="FILE", textColor={255,255,255}, fontSize=0)
      }),Documentation(info="<html><p><code>RejectExisting</code> skips an export when the destination already exists. <code>Overwrite</code> removes the existing file before writing the new result set.</p></html>"));
