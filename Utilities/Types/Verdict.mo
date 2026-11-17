within EvaluationLibrary.Utilities.Types;
type Verdict = enumeration(UNDECIDED,SATISFIED,VIOLATED,INVALID,NOT_APPLICABLE) "Requirement outcome independent of observation coverage" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-48.75,-27},{-38.3,-38},{-17.95,-11.6}}, color={255,255,255}, thickness=1.5, pattern=LinePattern.Solid),
        Line(points={{16,-9},{48,-43}}, color={255,255,255}, thickness=1.5, pattern=LinePattern.Solid),
        Line(points={{16,-43},{48,-9}}, color={255,255,255}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-49,-59},{49,-80}}, textString="REQ", textColor={255,255,255}, fontSize=0)
      }),Documentation(info="<html><p><code>UNDECIDED</code> denotes no established decision; <code>SATISFIED</code> denotes an accepted requirement; <code>VIOLATED</code> denotes an observed failure; <code>INVALID</code> denotes an unusable assessment; <code>NOT_APPLICABLE</code> excludes an inapplicable requirement.</p><p>The ordinals are 1 through 5 in the declared order. They are identifiers, not a ranking. Descriptive statistics need not yield <code>SATISFIED</code> even when their data status is complete.</p></html>"));
