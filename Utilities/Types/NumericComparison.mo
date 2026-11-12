within EvaluationLibrary.Utilities.Types;
type NumericComparison = enumeration(AtMost "上界", AtLeast "下界", Inside "区间") "数值要求的含等号比较"
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-61,74},{61,0}}, textString="E", textColor={255,255,255}, fontSize=0),
        Text(extent={{-68,-10},{68,-62}}, textString="≤ ≥", textColor={255,255,255}, fontSize=0)
      }),
    Documentation(info="<html>
<p>数值要求的含等号比较</p>
</html>"));
