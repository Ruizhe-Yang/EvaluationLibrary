within EvaluationLibrary.Utilities.Types;
type Grade = enumeration(UNGRADED "No qualified grade", A "Highest score range", B "Second score range", C "Third score range", D "Lowest score range") "Engineering grade assigned to a qualified score"
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Text(extent={{-70,-5},{70,-57}}, textString="-  A..D", textColor={255,255,255}, fontSize=0)
      }),
    Documentation(info="<html><p><code>UNGRADED</code> denotes a score without sufficient qualification. Grades A, B, C and D are assigned by the configured thresholds in <code>Results.GradeByThresholds</code>, with A representing the highest score range. The grade is separate from a requirement verdict.</p></html>"));
