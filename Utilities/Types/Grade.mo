within EvaluationLibrary.Utilities.Types;
type Grade = enumeration(UNGRADED "Grade", A "Grade", B "Grade", C "Grade", D "Grade") "Grade"
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Text(extent={{-70,-5},{70,-57}}, textString="-  A..D", textColor={255,255,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Grade. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
